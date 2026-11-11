///|
/// BoundedSafe(k) means no selected bad state on any constrained prefix through k.
/// It is not an inductive invariant or an unbounded proof.
pub(all) enum Verdict {
  Counterexample(Trace)
  BoundedSafe(Int32)
  Unknown(String)
} derive(Debug, Eq)

///|
/// Find the shortest counterexample for one bad property using independent queries.
/// Every query gets a fresh work budget; there are at most 65 queries.
pub fn Model::check(
  self : Model,
  bound : Int32,
  bad_index~ : Int32 = 0,
  limits~ : Limits = Limits::default(),
) -> Result[Verdict, Diagnostic] {
  try {
    if bound < 0 || bound > 64 {
      fail(0, "check bound must be in 0..64")
    }
    if bad_index < 0 || bad_index >= self.bad.length() {
      fail(0, "bad property index out of range")
    }
    limits.validate()
    for depth = 0; depth <= bound; depth = depth + 1 {
      let query = match self.query(depth, bad_index~, limits~) {
        Ok(q) => q
        Err(d) => return Ok(Unknown(d.message))
      }
      match query.formula.solve(limits~) {
        Satisfiable(assignment) =>
          match query.decode(assignment) {
            Ok(trace) => return Ok(Counterexample(trace))
            Err(d) => return Err(d)
          }
        Unsatisfiable => ()
        Indeterminate(reason) => return Ok(Unknown(reason))
      }
    }
    Ok(BoundedSafe(bound))
  } catch {
    Problem(d) => Err(d)
  }
}
