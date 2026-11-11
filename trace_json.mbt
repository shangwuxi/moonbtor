///|
/// Versioned MoonBTOR JSON witness format, distinct from the BTOR2 witness standard.
/// Values are decimal strings to preserve exact integer semantics in every consumer.
pub fn Trace::to_json_string(self : Trace) -> String {
  let frames : Array[Json] = self.frames.map(frame => {
    Json::object(
      Map([
        (
          "state",
          Json::array(frame.state.map(x => Json::string(x.to_string()))),
        ),
        (
          "inputs",
          Json::array(frame.inputs.map(x => Json::string(x.to_string()))),
        ),
      ]),
    )
  })
  Json::object(
    Map([
      ("version", Json::number(1.0)),
      ("bad_index", Json::number(self.bad_index.to_double())),
      ("frames", Json::array(frames)),
    ]),
  ).stringify()
}

///|
fn json_values(value : Json, line : Int32) -> Array[UInt64] raise Failure {
  match value {
    Array(values) => {
      if values.length() > 10000 {
        fail(line, "too many trace port values")
      }
      let out = []
      for value in values {
        match value {
          String(word) => out.push(constant(word, 10, 32, line))
          _ => fail(line, "trace values must be unsigned decimal strings")
        }
      }
      out
    }
    _ => {
      fail(line, "expected trace value array")
      []
    }
  }
}

///|
/// Parse bounded schema v1. Call Model::replay before trusting the trace.
pub fn parse_trace(text : String) -> Result[Trace, Diagnostic] {
  try {
    if text.length() > 1000000 {
      fail(0, "trace JSON text budget exceeded")
    }
    let value = @json.parse(
      text[:],
      max_nesting_depth=8,
      reject_duplicate_keys=true,
    ) catch {
      _ => {
        fail(0, "invalid trace JSON")
        Json::null()
      }
    }
    match value {
      Object(root) => {
        if root.length() != 3 || root.get("version") != Some(Json::number(1.0)) {
          fail(0, "unsupported trace schema")
        }
        let bad_index = match root.get("bad_index") {
          Some(Number(x, ..)) => {
            if x < 0.0 || x > 10000.0 || x != x.to_int().to_double() {
              fail(0, "invalid bad property index")
            }
            x.to_int()
          }
          _ => {
            fail(0, "missing bad property index")
            0
          }
        }
        let raw = match root.get("frames") {
          Some(Array(a)) => a
          _ => {
            fail(0, "missing trace frames")
            []
          }
        }
        if raw.is_empty() || raw.length() > 65 {
          fail(0, "trace must have one to 65 frames")
        }
        let frames : Array[Frame] = []
        for i = 0; i < raw.length(); i = i + 1 {
          match raw[i] {
            Object(frame) => {
              if frame.length() != 2 {
                fail(i + 1, "unknown/missing frame field")
              }
              let state = match frame.get("state") {
                Some(v) => json_values(v, i + 1)
                None => {
                  fail(i + 1, "missing state values")
                  []
                }
              }
              let inputs = match frame.get("inputs") {
                Some(v) => json_values(v, i + 1)
                None => {
                  fail(i + 1, "missing input values")
                  []
                }
              }
              frames.push({ state, inputs, })
            }
            _ => fail(i + 1, "expected frame object")
          }
        }
        Ok({ frames, bad_index, })
      }
      _ => {
        fail(0, "expected trace object")
        Err({ line: 0, message: "invalid trace", })
      }
    }
  } catch {
    Problem(d) => Err(d)
  }
}
