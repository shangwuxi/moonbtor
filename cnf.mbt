///|
/// Hard allocation limits for an exact-frame encoding and search limits for DPLL.
pub(all) struct Limits {
  max_variables : Int32
  max_clauses : Int32
  max_steps : Int32
  max_decisions : Int32
} derive(Debug, Eq)

///|
pub fn Limits::default() -> Limits {
  {
    max_variables: 50000,
    max_clauses: 200000,
    max_steps: 2000000,
    max_decisions: 96,
  }
}

///|
fn Limits::validate(self : Limits) -> Unit raise Failure {
  if self.max_variables < 1 ||
    self.max_variables > 100000 ||
    self.max_clauses < 1 ||
    self.max_clauses > 400000 ||
    self.max_steps < 1 ||
    self.max_steps > 20000000 ||
    self.max_decisions < 0 ||
    self.max_decisions > 128 {
    fail(0, "invalid resource limits")
  }
}

///|
/// Immutable CNF: variables are numbered 1..variable_count; zero is not a literal.
pub struct Formula {
  priv variables : Int32
  priv clauses : Array[Array[Int32]]
}

///|
pub fn Formula::variable_count(self : Formula) -> Int32 {
  self.variables
}

///|
pub fn Formula::clause_count(self : Formula) -> Int32 {
  self.clauses.length()
}

///|
/// Copying accessor prevents a caller from modifying a validated formula.
pub fn Formula::clause(self : Formula, index : Int32) -> Array[Int32]? {
  if index < 0 || index >= self.clauses.length() {
    None
  } else {
    Some(self.clauses[index].copy())
  }
}

///|
priv struct Encoder {
  mut variables : Int32
  clauses : Array[Array[Int32]]
  limits : Limits
}

///|
fn Encoder::new(limits : Limits) -> Encoder raise Failure {
  limits.validate()
  let result = { variables: 1, clauses: [], limits, }
  result.add_clause([1])
  result
}

///|
fn Encoder::fresh(self : Encoder) -> Int32 raise Failure {
  if self.variables >= self.limits.max_variables {
    fail(0, "CNF variable budget exhausted")
  }
  self.variables += 1
  self.variables
}

///|
fn Encoder::add_clause(
  self : Encoder,
  clause : Array[Int32],
) -> Unit raise Failure {
  if self.clauses.length() >= self.limits.max_clauses {
    fail(0, "CNF clause budget exhausted")
  }
  // Only owned arrays are stored. Gate callers never mutate these literals.
  self.clauses.push(clause)
}

///|
fn Encoder::finish(self : Encoder) -> Formula {
  { variables: self.variables, clauses: self.clauses, }
}

///|
fn Encoder::equate(self : Encoder, a : Int32, b : Int32) -> Unit raise Failure {
  if a != b {
    self.add_clause([-a, b])
    self.add_clause([a, -b])
  }
}

///|
fn Encoder::word(self : Encoder, width : Int32) -> Array[Int32] raise Failure {
  let result = []
  for i = 0; i < width; i = i + 1 {
    result.push(self.fresh())
  }
  result
}

///|
fn constant_word(value : UInt64, width : Int32) -> Array[Int32] {
  Array::makei(width, i => if ((value >> i) & 1UL) == 1UL { 1 } else { -1 })
}
