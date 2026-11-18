///|
/// One concrete frame; state and input arrays use declaration order.
pub(all) struct Frame {
  state : Array[UInt64]
  inputs : Array[UInt64]
} derive(Debug, Eq)

///|
/// Values at a frame before the synchronous update.
pub(all) struct Observation {
  next_state : Array[UInt64?]
  outputs : Array[UInt64]
  bad : Array[Bool]
  constraints_hold : Bool
} derive(Debug, Eq)

///|
fn Model::values(self : Model, frame : Frame) -> Array[UInt64] raise Failure {
  self.check_scalar()
  if frame.state.length() != self.states.length() ||
    frame.inputs.length() != self.inputs.length() {
    fail(0, "state/input assignment count mismatch")
  }
  for
    (ports, values) in [(self.states, frame.state), (self.inputs, frame.inputs)] {
    for i = 0; i < ports.length(); i = i + 1 {
      if values[i] > mask(self.nodes[ports[i]].width) {
        fail(0, "state/input value exceeds width")
      }
    }
  }
  let typed : TypedFrame = {
    state: Array::makei(self.states.length(), i => {
      concrete_word(frame.state[i], self.nodes[self.states[i]].width)
    }),
    inputs: Array::makei(self.inputs.length(), i => {
      concrete_word(frame.inputs[i], self.nodes[self.inputs[i]].width)
    }),
  }
  self.typed_values(typed).map(concrete_number)
}

///|
/// Evaluate concrete values without imposing init or constraint assumptions.
pub fn Model::observe(
  self : Model,
  frame : Frame,
) -> Result[Observation, Diagnostic] {
  try {
    let values = self.values(frame)
    let next_state : Array[UInt64?] = self.states.map(s => {
      let mut found = None
      for (target, source) in self.updates {
        if target == s {
          found = Some(values[source])
        }
      }
      found
    })
    Ok({
      next_state,
      outputs: self.outputs.map(i => values[i]),
      bad: self.bad.map(i => values[i] != 0UL),
      constraints_hold: self.constraints.all(i => values[i] != 0UL),
    })
  } catch {
    Problem(d) => Err(d)
  }
}
