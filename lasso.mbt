///|
/// Find a satisfying closed path, NOT an unbounded liveness proof or a claim
/// that the selected justice condition is violated. The last state duplicates
/// loop_start; recurrent obligations are sampled before that duplicate.
pub fn Model::lasso_query(
  self : Model,
  depth : Int32,
  loop_start : Int32,
  justice_index~ : Int32? = None,
  limits~ : Limits = Limits::default(),
) -> Result[Query, Diagnostic] {
  try {
    if depth < 1 || depth > 64 || loop_start < 0 || loop_start >= depth {
      fail(0, "invalid lasso depth or start")
    }
    self.check_work_budget(depth + 1)
    let goals = self.fair.copy()
    match justice_index {
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
    let mut bits = 0
    for node in self.nodes {
      bits += node.size()
      if bits > 1000000 / (depth + 1) {
        fail(0, "frame bit allocation budget exhausted")
      }
    }
    let encoder = Encoder::new(limits)
    let frames : Array[Array[Array[Int32]]] = []
    for t = 0; t <= depth; t = t + 1 {
      let values = []
      for node in self.nodes {
        values.push(encoder.blast(node, values))
      }
      if t == 0 {
        for (target, source) in self.initial {
          for bit = 0; bit < values[target].length(); bit = bit + 1 {
            encoder.equate(
              values[target][bit],
              values[source][bit % values[source].length()],
            )
          }
        }
      } else {
        for (target, source) in self.updates {
          for bit = 0; bit < values[target].length(); bit = bit + 1 {
            encoder.equate(values[target][bit], frames[t - 1][source][bit])
          }
        }
      }
      for constraint in self.constraints {
        encoder.add_clause([values[constraint][0]])
      }
      frames.push(values)
    }
    for state in self.states {
      for bit = 0; bit < frames[depth][state].length(); bit = bit + 1 {
        encoder.equate(
          frames[depth][state][bit],
          frames[loop_start][state][bit],
        )
      }
    }
    for goal in goals {
      let occurrence = []
      for t = loop_start; t < depth; t = t + 1 {
        occurrence.push(frames[t][goal][0])
      }
      encoder.add_clause(occurrence)
    }
    Ok({
      formula: encoder.finish(),
      frames,
      model: self,
      bad_index: -1,
      loop_start: Some(loop_start),
      justice_index,
    })
  } catch {
    Problem(d) => Err(d)
  }
}
