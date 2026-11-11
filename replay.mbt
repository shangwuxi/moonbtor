///|
/// A finite concrete counterexample; bad_index uses property declaration order.
pub(all) struct Trace {
  frames : Array[Frame]
  bad_index : Int32
} derive(Debug, Eq)

///|
/// Independently check initial equations, every prefix constraint and every update.
/// A missing init/next is nondeterministic; it is never silently filled with zero/hold.
pub fn Model::replay(self : Model, trace : Trace) -> Result[Unit, Diagnostic] {
  try {
    if trace.frames.is_empty() || trace.frames.length() > 65 {
      fail(0, "trace must have between one and 65 frames")
    }
    if trace.bad_index < 0 || trace.bad_index >= self.bad.length() {
      fail(0, "bad property index out of range")
    }
    let mut previous : Array[UInt64] = []
    for t = 0; t < trace.frames.length(); t = t + 1 {
      let values = self.values(trace.frames[t])
      if t == 0 {
        for (target, source) in self.initial {
          if values[target] != values[source] {
            fail(t + 1, "initial equation does not hold")
          }
        }
      } else {
        for (target, source) in self.updates {
          if values[target] != previous[source] {
            fail(t + 1, "synchronous next equation does not hold")
          }
        }
      }
      for assumption in self.constraints {
        if values[assumption] == 0UL {
          fail(t + 1, "constraint does not hold")
        }
      }
      if t == trace.frames.length() - 1 &&
        values[self.bad[trace.bad_index]] == 0UL {
        fail(t + 1, "selected bad property is false at final frame")
      }
      previous = values
    }
    Ok(())
  } catch {
    Problem(d) => Err(d)
  }
}

///|
/// Execute one synchronous update with explicit values for nondeterministic states.
/// `free_next` must contain exactly the values of states without a next equation.
pub fn Model::step(
  self : Model,
  frame : Frame,
  next_inputs : Array[UInt64],
  free_next : Array[UInt64],
) -> Result[Frame, Diagnostic] {
  try {
    let observation = match self.observe(frame) {
      Ok(x) => x
      Err(d) => raise Problem(d)
    }
    let state : Array[UInt64] = []
    let mut used = 0
    for value in observation.next_state {
      match value {
        Some(v) => state.push(v)
        None => {
          if used >= free_next.length() {
            fail(0, "missing nondeterministic next value")
          }
          state.push(free_next[used])
          used += 1
        }
      }
    }
    if used != free_next.length() {
      fail(0, "extra nondeterministic next values")
    }
    let result = { state, inputs: next_inputs.copy(), }
    ignore(self.values(result))
    Ok(result)
  } catch {
    Problem(d) => Err(d)
  }
}
