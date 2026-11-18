///|
/// An exact-frame bad-state query, retaining the map needed to decode SAT models.
pub struct Query {
  priv formula : Formula
  priv frames : Array[Array[Array[Int32]]]
  priv model : Model
  priv bad_index : Int32
  priv loop_start : Int32?
  priv justice_index : Int32?
}

///|
pub fn Query::formula(self : Query) -> Formula {
  self.formula
}

///|
pub fn Query::depth(self : Query) -> Int32 {
  self.frames.length() - 1
}

///|
/// Expose copied literal maps for integration with an external SAT solver.
/// frame is zero-based; node_id is the original BTOR2 value-node ID.
pub fn Query::literals(
  self : Query,
  frame : Int32,
  node_id : Int32,
) -> Array[Int32]? {
  if frame < 0 || frame >= self.frames.length() {
    return None
  }
  for i = 0; i < self.model.nodes.length(); i = i + 1 {
    if self.model.nodes[i].id == node_id {
      return Some(self.frames[frame][i].copy())
    }
  }
  None
}

///|
/// Encode only the prefix through depth. Future constraints cannot erase a shorter bug.
pub fn Model::query(
  self : Model,
  depth : Int32,
  bad_index~ : Int32 = 0,
  limits~ : Limits = Limits::default(),
) -> Result[Query, Diagnostic] {
  try {
    if depth < 0 || depth > 64 {
      fail(0, "query depth must be in 0..64")
    }
    self.check_work_budget(depth + 1)
    if bad_index < 0 || bad_index >= self.bad.length() {
      fail(0, "bad property index out of range")
    }
    if !self.fair.is_empty() || !self.justice.is_empty() {
      fail(
        0, "fair/justice models require lasso_query; finite reachability is not fair liveness",
      )
    }
    let mut bits = 0
    for node in self.nodes {
      bits += node.size()
      if bits > 1000000 / (depth + 1) {
        fail(0, "frame bit allocation budget exhausted")
      }
    }
    if bits > 1000000 / (depth + 1) {
      fail(0, "frame bit allocation budget exhausted")
    }
    let encoder = Encoder::new(limits)
    let frames : Array[Array[Array[Int32]]] = []
    for t = 0; t <= depth; t = t + 1 {
      let values : Array[Array[Int32]] = []
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
        let previous = frames[t - 1]
        for (target, source) in self.updates {
          for bit = 0; bit < values[target].length(); bit = bit + 1 {
            encoder.equate(values[target][bit], previous[source][bit])
          }
        }
      }
      for constraint in self.constraints {
        encoder.add_clause([values[constraint][0]])
      }
      frames.push(values)
    }
    encoder.add_clause([frames[depth][self.bad[bad_index]][0]])
    Ok({
      formula: encoder.finish(),
      frames,
      model: self,
      bad_index,
      loop_start: None,
      justice_index: None,
    })
  } catch {
    Problem(d) => Err(d)
  }
}
