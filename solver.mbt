///|
/// SAT results have no implicit timeout-to-UNSAT conversion.
pub(all) enum SatResult {
  Satisfiable(Array[Bool])
  Unsatisfiable
  Indeterminate(String)
} derive(Debug, Eq)

///|
priv struct Search {
  clauses : Array[Array[Int32]]
  limits : Limits
  mut steps : Int32
}

///|
fn Search::spend(self : Search) -> Unit raise Failure {
  if self.steps >= self.limits.max_steps {
    fail(0, "SAT work budget exhausted")
  }
  self.steps += 1
}

///|
/// Unit propagation returns false only when an explicitly falsified clause is found.
fn Search::propagate(
  self : Search,
  assignment : Array[Int32],
) -> Bool raise Failure {
  let mut changed = true
  while changed {
    changed = false
    for clause in self.clauses {
      self.spend()
      let mut satisfied = false
      let mut open = 0
      let mut unit = 0
      for literal in clause {
        self.spend()
        let variable = if literal < 0 { -literal } else { literal }
        let value = assignment[variable]
        if value == 0 {
          open += 1
          unit = literal
        } else if (value == 1) == (literal > 0) {
          satisfied = true
          break
        }
      }
      if !satisfied {
        if open == 0 {
          return false
        }
        if open == 1 {
          let variable = if unit < 0 { -unit } else { unit }
          assignment[variable] = if unit > 0 { 1 } else { -1 }
          changed = true
        }
      }
    }
  }
  true
}

///|
/// Choose a variable only from a clause that is not already satisfied.
fn Search::choose(
  self : Search,
  assignment : Array[Int32],
) -> Int32 raise Failure {
  for clause in self.clauses {
    let mut satisfied = false
    let mut candidate = 0
    self.spend()
    for literal in clause {
      self.spend()
      let variable = if literal < 0 { -literal } else { literal }
      if assignment[variable] == 0 {
        candidate = variable
      } else if (assignment[variable] == 1) == (literal > 0) {
        satisfied = true
        break
      }
    }
    if !satisfied && candidate != 0 {
      return candidate
    }
  }
  0
}

///|
/// The recursion depth is bounded by a validated limit <=128.
/// The shared work counter covers both branches; copying cannot reset a budget.
fn Search::search(
  self : Search,
  assignment : Array[Int32],
  depth : Int32,
) -> Array[Int32]? raise Failure {
  if !self.propagate(assignment) {
    return None
  }
  let variable = self.choose(assignment)
  if variable == 0 {
    return Some(assignment)
  }
  if depth >= self.limits.max_decisions {
    fail(0, "SAT decision-depth budget exhausted")
  }
  let positive = assignment.copy()
  positive[variable] = 1
  match self.search(positive, depth + 1) {
    Some(solution) => Some(solution)
    None => {
      assignment[variable] = -1
      self.search(assignment, depth + 1)
    }
  }
}

///|
/// Deterministic bounded DPLL, intended for small models and integration tests.
/// Index zero in a satisfying assignment is unused; unconstrained bits default false.
pub fn Formula::solve(
  self : Formula,
  limits~ : Limits = Limits::default(),
) -> SatResult {
  try {
    limits.validate()
    if self.variables > limits.max_variables ||
      self.clauses.length() > limits.max_clauses {
      fail(0, "formula exceeds solver allocation limits")
    }
    let search = { clauses: self.clauses, limits, steps: 0, }
    match search.search(Array::make(self.variables + 1, 0), 0) {
      Some(values) => Satisfiable(values.map(x => x == 1))
      None => Unsatisfiable
    }
  } catch {
    Problem(d) => Indeterminate(d.message)
  }
}

///|
/// Check a complete assignment rather than trusting a solver's SAT status.
pub fn Formula::accepts(self : Formula, assignment : Array[Bool]) -> Bool {
  assignment.length() == self.variables + 1 &&
  self.clauses.all(c => {
    c.any(l => if l > 0 { assignment[l] } else { !assignment[-l] })
  })
}
