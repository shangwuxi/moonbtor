///|
/// A finite bad prefix or a closed, fair, justice-satisfying lasso.
pub(all) struct TypedTrace {
  frames : Array[TypedFrame]
  bad_index : Int32
  loop_start : Int32?
  justice_index : Int32?
} derive(Debug, Eq)

///|
pub extend TypedTrace with @debug.Debug::{to_repr}

///|
pub extend TypedTrace with Eq::{equal, not_equal}

///|
pub fn Query::decode_typed(
  self : Query,
  assignment : Array[Bool],
) -> Result[TypedTrace, Diagnostic] {
  try {
    if !self.formula.accepts(assignment) {
      fail(0, "assignment does not satisfy query CNF")
    }
    let decode = fn(bits : Array[Int32]) {
      bits.map(i => if i > 0 { assignment[i] } else { !assignment[-i] })
    }
    let frames = self.frames.map(values => {
      (
        {
          state: self.model.states.map(i => decode(values[i])),
          inputs: self.model.inputs.map(i => decode(values[i])),
        } : TypedFrame)
    })
    let trace : TypedTrace = {
      frames,
      bad_index: self.bad_index,
      loop_start: self.loop_start,
      justice_index: self.justice_index,
    }
    match self.model.replay_typed(trace) {
      Ok(_) => Ok(trace)
      Err(d) => Err(d)
    }
  } catch {
    Problem(d) => Err(d)
  }
}

///|
pub fn Model::replay_typed(
  self : Model,
  trace : TypedTrace,
) -> Result[Unit, Diagnostic] {
  try {
    let length = trace.frames.length()
    if length < 1 || length > 65 {
      fail(0, "trace must have between one and 65 frames")
    }
    let all : Array[Array[Array[Bool]]] = []
    for t = 0; t < length; t = t + 1 {
      let values = self.typed_values(trace.frames[t])
      if t == 0 {
        for (target, source) in self.initial {
          let source_value = values[source]
          for bit = 0; bit < values[target].length(); bit = bit + 1 {
            if values[target][bit] != source_value[bit % source_value.length()] {
              fail(t + 1, "initial equation does not hold")
            }
          }
        }
      } else {
        for (target, source) in self.updates {
          if values[target] != all[t - 1][source] {
            fail(t + 1, "synchronous next equation does not hold")
          }
        }
      }
      if self.constraints.any(i => !values[i][0]) {
        fail(t + 1, "constraint does not hold")
      }
      all.push(values)
    }
    match trace.loop_start {
      None => {
        if !self.fair.is_empty() || !self.justice.is_empty() {
          fail(0, "liveness declarations require a lasso witness")
        }
        if trace.justice_index != None ||
          trace.bad_index < 0 ||
          trace.bad_index >= self.bad.length() {
          fail(0, "invalid finite property index")
        }
        if !all[length - 1][self.bad[trace.bad_index]][0] {
          fail(length, "selected bad property is false at final frame")
        }
      }
      Some(start) => {
        if start < 0 || start >= length - 1 || trace.bad_index != -1 {
          fail(0, "invalid loop boundary or property kind")
        }
        for s in self.states {
          if all[start][s] != all[length - 1][s] {
            fail(length, "lasso state does not close")
          }
        }
        let goals = self.fair.copy()
        match trace.justice_index {
          None => ()
          Some(j) => {
            if j < 0 || j >= self.justice.length() {
              fail(0, "justice index out of range")
            }
            for goal in self.justice[j] {
              goals.push(goal)
            }
          }
        }
        for goal in goals {
          let mut seen = false
          for t = start; t < length - 1; t = t + 1 {
            seen = seen || all[t][goal][0]
          }
          if !seen {
            fail(0, "fairness/justice obligation absent from loop")
          }
        }
      }
    }
    Ok(())
  } catch {
    Problem(d) => Err(d)
  }
}

///|
pub fn Model::step_typed(
  self : Model,
  frame : TypedFrame,
  next_inputs : Array[Array[Bool]],
  free_next : Array[Array[Bool]],
) -> Result[TypedFrame, Diagnostic] {
  try {
    let obs = match self.observe_typed(frame) {
      Ok(o) => o
      Err(d) => raise Problem(d)
    }
    let state = []
    let mut used = 0
    for value in obs.next_state {
      match value {
        Some(v) => state.push(v.copy())
        None => {
          if used >= free_next.length() {
            fail(0, "missing nondeterministic next value")
          }
          state.push(free_next[used].copy())
          used += 1
        }
      }
    }
    if used != free_next.length() {
      fail(0, "extra nondeterministic next values")
    }
    let result : TypedFrame = { state, inputs: next_inputs.map(x => x.copy()), }
    ignore(self.typed_values(result))
    Ok(result)
  } catch {
    Problem(d) => Err(d)
  }
}
