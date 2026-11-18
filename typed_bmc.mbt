///|
pub(all) enum TypedVerdict {
  Counterexample(TypedTrace)
  BoundedSafe(Int32)
  Unknown(String)
} derive(Debug, Eq)

///|
pub extend TypedVerdict with @debug.Debug::{to_repr}

///|
pub extend TypedVerdict with Eq::{equal, not_equal}

///|
pub fn Model::check_typed(
  self : Model,
  bound : Int32,
  bad_index~ : Int32 = 0,
  limits~ : Limits = Limits::default(),
) -> Result[TypedVerdict, Diagnostic] {
  try {
    if bound < 0 ||
      bound > 64 ||
      bad_index < 0 ||
      bad_index >= self.bad.length() {
      fail(0, "invalid bound or property index")
    }
    limits.validate()
    for depth = 0; depth <= bound; depth = depth + 1 {
      let q = match self.query(depth, bad_index~, limits~) {
        Ok(q) => q
        Err(d) => return Ok(Unknown(d.message))
      }
      match q.formula().solve(limits~) {
        Satisfiable(a) =>
          match q.decode_typed(a) {
            Ok(t) => return Ok(Counterexample(t))
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
