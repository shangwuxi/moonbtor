///|
/// Export standard DIMACS CNF. An empty clause is written as a bare zero.
pub fn Formula::to_dimacs(self : Formula) -> String {
  let text = StringBuilder()
  text.write_string("c MoonBTOR CNF; variables start at 1\n")
  text.write_string("p cnf \{self.variables} \{self.clauses.length()}\n")
  for clause in self.clauses {
    for literal in clause {
      text.write_string("\{literal} ")
    }
    text.write_string("0\n")
  }
  text.to_string()
}

///|
fn dimacs_literal(
  word : String,
  variables : Int32,
  line : Int32,
) -> Int32 raise Failure {
  let negative = word.has_prefix("-")
  let digits = if negative { word[1:].to_owned() } else { word }
  let value = natural(digits, line)
  if value > variables {
    fail(line, "DIMACS literal outside declared variable range")
  }
  if negative && value == 0 {
    fail(line, "negative zero literal")
  }
  if negative {
    -value
  } else {
    value
  }
}

///|
/// Import bounded DIMACS. Header is mandatory; comments start a whole line with c.
/// Clauses may span lines. Declared counts, zero terminators and literal ranges are checked.
pub fn parse_dimacs(
  text : String,
  limits~ : Limits = Limits::default(),
) -> Result[Formula, Diagnostic] {
  try {
    limits.validate()
    if text.length() > 8000000 {
      fail(0, "DIMACS text budget exceeded")
    }
    let mut header = false
    let mut variables = 0
    let mut expected = 0
    let clauses : Array[Array[Int32]] = []
    let mut current : Array[Int32] = []
    let mut total = 0
    let mut line = 0
    for raw in text.split("\n") {
      line += 1
      let words = tokens(raw.to_owned())
      if words.is_empty() || words[0] == "c" {
        continue
      }
      if words[0] == "p" {
        if header || words.length() != 4 || words[1] != "cnf" {
          fail(line, "invalid or duplicate DIMACS header")
        }
        variables = natural(words[2], line)
        expected = natural(words[3], line)
        if variables > limits.max_variables || expected > limits.max_clauses {
          fail(line, "DIMACS allocation budget exceeded")
        }
        header = true
        continue
      }
      if !header {
        fail(line, "DIMACS clause precedes header")
      }
      for word in words {
        total += 1
        if total > 2000000 {
          fail(line, "DIMACS literal budget exceeded")
        }
        let literal = dimacs_literal(word, variables, line)
        if literal == 0 {
          if clauses.length() >= expected {
            fail(line, "more clauses than declared")
          }
          clauses.push(current)
          current = []
        } else {
          current.push(literal)
        }
      }
    }
    if !header || !current.is_empty() || clauses.length() != expected {
      fail(line, "missing header/terminator or clause count mismatch")
    }
    Ok({ variables, clauses, })
  } catch {
    Problem(d) => Err(d)
  }
}

///|
/// Import the strict SAT competition output subset: one `s SATISFIABLE` line and
/// one or more `v` lines ending in zero, assigning every variable exactly once.
/// UNSAT/UNKNOWN outputs are not witnesses and are rejected here.
pub fn Formula::parse_assignment(
  self : Formula,
  text : String,
) -> Result[Array[Bool], Diagnostic] {
  try {
    if text.length() > 8000000 {
      fail(0, "SAT output text budget exceeded")
    }
    let values = Array::make(self.variables + 1, false)
    let seen = Array::make(self.variables + 1, false)
    let mut status = false
    let mut ended = false
    let mut line = 0
    for raw in text.split("\n") {
      line += 1
      let words = tokens(raw.to_owned())
      if words.is_empty() || words[0] == "c" {
        continue
      }
      if words[0] == "s" {
        if status || words.length() != 2 || words[1] != "SATISFIABLE" {
          fail(line, "expected exactly one SATISFIABLE status")
        }
        status = true
      } else if words[0] == "v" {
        if !status || ended || words.length() < 2 {
          fail(line, "unexpected assignment line")
        }
        for j = 1; j < words.length(); j = j + 1 {
          if ended {
            fail(line, "data after assignment terminator")
          }
          let literal = dimacs_literal(words[j], self.variables, line)
          if literal == 0 {
            ended = true
          } else {
            let variable = if literal < 0 { -literal } else { literal }
            if seen[variable] {
              fail(line, "duplicate variable assignment")
            }
            seen[variable] = true
            values[variable] = literal > 0
          }
        }
      } else {
        fail(line, "unsupported SAT output line")
      }
    }
    if !status || !ended {
      fail(line, "missing SAT status or assignment terminator")
    }
    for v = 1; v <= self.variables; v = v + 1 {
      if !seen[v] {
        fail(line, "incomplete SAT assignment")
      }
    }
    if !self.accepts(values) {
      fail(line, "SAT output falsifies a CNF clause")
    }
    Ok(values)
  } catch {
    Problem(d) => Err(d)
  }
}
