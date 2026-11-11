///|
fn decode_word(bits : Array[Int32], assignment : Array[Bool]) -> UInt64 {
  let mut value = 0UL
  for i = 0; i < bits.length(); i = i + 1 {
    let literal = bits[i]
    let bit = if literal > 0 {
      assignment[literal]
    } else {
      !assignment[-literal]
    }
    if bit {
      value = value | (1UL << i)
    }
  }
  value
}

///|
/// Decode a complete SAT assignment only after evaluating every CNF clause.
/// Then re-evaluate the concrete BTOR2 equations through the independent evaluator.
pub fn Query::decode(
  self : Query,
  assignment : Array[Bool],
) -> Result[Trace, Diagnostic] {
  try {
    if !self.formula.accepts(assignment) {
      fail(0, "assignment does not satisfy query CNF")
    }
    let frames : Array[Frame] = self.frames.map(values => {
      state: self.model.states.map(i => decode_word(values[i], assignment)),
      inputs: self.model.inputs.map(i => decode_word(values[i], assignment)),
    })
    let trace = { frames, bad_index: self.bad_index, }
    match self.model.replay(trace) {
      Ok(_) => Ok(trace)
      Err(d) =>
        Err({
          line: d.line,
          message: "decoded assignment failed independent replay: " + d.message,
        })
    }
  } catch {
    Problem(d) => Err(d)
  }
}
