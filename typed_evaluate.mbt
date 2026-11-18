///|
pub(all) struct TypedObservation {
  next_state : Array[Array[Bool]?]
  outputs : Array[Array[Bool]]
  bad : Array[Bool]
  constraints_hold : Bool
  fair : Array[Bool]
  justice : Array[Array[Bool]]
} derive(Debug, Eq)

///|
fn Model::typed_values(
  self : Model,
  frame : TypedFrame,
) -> Array[Array[Bool]] raise Failure {
  self.check_work_budget(1)
  if frame.state.length() != self.states.length() ||
    frame.inputs.length() != self.inputs.length() {
    fail(0, "state/input assignment count mismatch")
  }
  let mut total = 0
  for n in self.nodes {
    total += n.size()
    if total > 1000000 {
      fail(0, "concrete frame allocation budget exhausted")
    }
  }
  let result : Array[Array[Bool]] = Array::makei(self.nodes.length(), _ => [])
  for
    (ports, values) in [(self.states, frame.state), (self.inputs, frame.inputs)] {
    for i = 0; i < ports.length(); i = i + 1 {
      let n = ports[i]
      if values[i].length() != self.nodes[n].size() {
        fail(0, "typed assignment width does not match sort")
      }
      result[n] = values[i].copy()
    }
  }
  for i = 0; i < self.nodes.length(); i = i + 1 {
    let n = self.nodes[i]
    if n.op != "state" && n.op != "input" {
      result[i] = concrete_operation(n, result)
      if result[i].length() != n.size() {
        fail(0, "internal concrete operation size mismatch")
      }
    }
  }
  result
}

///|
pub fn Model::observe_typed(
  self : Model,
  frame : TypedFrame,
) -> Result[TypedObservation, Diagnostic] {
  try {
    let values = self.typed_values(frame)
    let next_state : Array[Array[Bool]?] = self.states.map(s => {
      let mut result = None
      for (target, source) in self.updates {
        if target == s {
          result = Some(values[source].copy())
        }
      }
      result
    })
    Ok({
      next_state,
      outputs: self.outputs.map(i => values[i].copy()),
      bad: self.bad.map(i => values[i][0]),
      constraints_hold: self.constraints.all(i => values[i][0]),
      fair: self.fair.map(i => values[i][0]),
      justice: self.justice.map(group => group.map(i => values[i][0])),
    })
  } catch {
    Problem(d) => Err(d)
  }
}

///|
fn Model::check_scalar(self : Model) -> Unit raise Failure {
  if self.nodes.any(n => n.index_width != 0 || n.width > 64) {
    fail(0, "use typed API for arrays or bit-vectors wider than 64 bits")
  }
}
