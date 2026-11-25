///|
/// A verified BTOR2 SAT witness. Bad hits are (property, first frame).
/// The loop's closing transition leaves the last recorded frame.
pub(all) struct VerifiedWitness {
  frames : Array[TypedFrame]
  bad_hits : Array[(Int32, Int32)]
  justice : Array[Int32]
  loop_start : Int32?
} derive(Debug, Eq)

///|
pub extend VerifiedWitness with @debug.Debug::{to_repr}

///|
pub extend VerifiedWitness with Eq::{equal, not_equal}

///|
priv struct WitnessRow {
  line : Int32
  port : Int32
  index : String?
  bits : String
}

///|
priv struct WitnessFrame {
  states : Array[WitnessRow]
  inputs : Array[WitnessRow]
}

///|
priv struct WitnessText {
  bad : Array[Int32]
  justice : Array[Int32]
  frames : Array[WitnessFrame]
}

///|
fn witness_prefix(
  word : String,
  marker : UInt16,
  line : Int32,
) -> Int32 raise Failure {
  if word.length() < 2 || word[0] != marker {
    fail(line, "invalid witness marker")
  }
  natural(word[1:].to_owned(), line)
}

///|
fn witness_row(words : Array[String], line : Int32) -> WitnessRow raise Failure {
  if words.length() < 2 {
    fail(line, "missing witness assignment value")
  }
  let port = natural(words[0], line)
  let token = words[1]
  if token[0] == '[' {
    let n = token.length()
    if n < 3 || token[n - 1] != ']' || words.length() < 3 {
      fail(line, "invalid witness array assignment")
    }
    need(words, 3, line)
    { line, port, index: Some(token[1:n - 1].to_owned()), bits: words[2], }
  } else {
    need(words, 2, line)
    { line, port, index: None, bits: token, }
  }
}

///|
fn parse_witness_text(text : String) -> WitnessText raise Failure {
  if text.length() > 8000000 {
    fail(0, "witness text budget exceeded")
  }
  let bad = []
  let justice = []
  let frames = []
  let claims : Map[(Bool, Int32), Bool] = Map([])
  let mut pending : Array[WitnessRow] = []
  let mut rows : Array[WitnessRow] = []
  let mut mode = 0 // sat, claims, between sections, states, inputs, done
  let mut line = 0
  for raw in text.split("\n") {
    line += 1
    if line > 200000 || raw.length() > 16384 {
      fail(line, "witness line budget exceeded")
    }
    let words = tokens(raw.to_owned())
    if words.is_empty() {
      continue
    }
    let first = words[0]
    if mode == 0 {
      if first != "sat" || words.length() != 1 {
        fail(line, "expected a BTOR2 sat witness")
      }
      mode = 1
    } else if mode == 1 {
      for word in words {
        let kind = word[0]
        if kind != 'b' && kind != 'j' {
          fail(line, "expected b or j property ordinal")
        }
        let index = witness_prefix(word, kind, line)
        let key = (kind == 'j', index)
        if claims.get(key) is Some(_) {
          fail(line, "duplicate witness property")
        }
        claims[key] = true
        if kind == 'b' {
          bad.push(index)
        } else {
          justice.push(index)
        }
      }
      mode = 2
    } else if mode == 5 {
      fail(line, "trailing witness data")
    } else if first == "." {
      if mode != 4 || words.length() != 1 {
        fail(line, "witness must end after an input section")
      }
      mode = 5
    } else if first[0] == '#' || first[0] == '@' {
      let number = witness_prefix(first, first[0], line)
      if words.length() != 1 || number != frames.length() || number > 64 {
        fail(line, "invalid or non-consecutive witness frame")
      }
      if first[0] == '#' {
        if mode == 3 {
          fail(line, "duplicate state section")
        }
        pending = []
        rows = pending
        mode = 3
      } else {
        rows = []
        frames.push({ states: pending, inputs: rows, })
        pending = []
        mode = 4
      }
    } else if mode == 3 || mode == 4 {
      rows.push(witness_row(words, line))
    } else {
      fail(line, "witness assignment outside a frame section")
    }
  }
  if mode != 5 {
    fail(line, "missing witness frame or terminating dot")
  }
  { bad, justice, frames, }
}

///|
fn witness_binary(
  text : String,
  width : Int32,
  line : Int32,
) -> Array[Bool] raise Failure {
  if text.length() != width {
    fail(line, "witness assignment width does not match sort")
  }
  let bits = []
  for i = width - 1; i >= 0; i = i - 1 {
    let digit = text[i]
    if digit != '0' && digit != '1' {
      fail(line, "expected binary witness bits")
    }
    bits.push(digit == '1')
  }
  bits
}

///|
fn witness_array_widths(
  sort : ValueSort,
  line : Int32,
) -> (Int32, Int32) raise Failure {
  match sort.parts {
    Some((index, element)) =>
      match (index.bit_width(), element.bit_width()) {
        (Some(i), Some(e)) => (i, e)
        _ =>
          raise Problem({
            line,
            message: "BTOR2 witness records have no nested array syntax",
          })
      }
    None =>
      raise Problem({
        line,
        message: "array witness assignment on scalar port",
      })
  }
}

///|
fn Model::witness_assign(
  self : Model,
  rows : Array[WitnessRow],
  ports : Array[Int32],
  values : Array[Array[Bool]],
  locked : Array[Bool],
) -> Unit raise Failure {
  let seen : Map[(Int32, Int32), Bool] = Map([])
  let defaults : Map[Int32, Bool] = Map([])
  // A BtorMC [*] record is the array default, regardless of row order.
  for wildcard in [true, false] {
    for row in rows {
      if (row.index == Some("*")) != wildcard {
        continue
      }
      let p = row.port
      if p >= ports.length() {
        fail(row.line, "witness port ordinal out of range")
      }
      let n = self.nodes[ports[p]]
      let out = values[p]
      if wildcard {
        let (_, ew) = witness_array_widths(n.sort, row.line)
        let value = witness_binary(row.bits, ew, row.line)
        if defaults.get(p) is Some(_) {
          fail(row.line, "duplicate witness array default")
        }
        defaults[p] = true
        if !locked[p] {
          for bit = 0; bit < out.length(); bit = bit + 1 {
            out[bit] = value[bit % ew]
          }
        }
      } else {
        let (cell, width) = match row.index {
          Some(index) => {
            let (iw, ew) = witness_array_widths(n.sort, row.line)
            (concrete_number(witness_binary(index, iw, row.line)).to_int(), ew)
          }
          None => {
            if n.sort.parts is Some(_) {
              fail(row.line, "witness array assignment requires an index")
            }
            (0, n.width)
          }
        }
        let key = (p, cell)
        if seen.get(key) is Some(_) {
          fail(row.line, "duplicate witness assignment")
        }
        seen[key] = true
        let value = witness_binary(row.bits, width, row.line)
        for i = 0; i < width; i = i + 1 {
          let offset = cell * width + i
          if locked[p] && out[offset] != value[i] {
            fail(row.line, "witness state contradicts the model")
          }
          out[offset] = value[i]
        }
      }
    }
  }
  for row in rows {
    if row.index == Some("*") && locked[row.port] {
      let p = row.port
      let (_, ew) = witness_array_widths(self.nodes[ports[p]].sort, row.line)
      let value = witness_binary(row.bits, ew, row.line)
      for bit = 0; bit < values[p].length(); bit = bit + 1 {
        if values[p][bit] != value[bit % ew] && seen.get((p, bit / ew)) is None {
          fail(row.line, "witness array default contradicts the model")
        }
      }
    }
  }
}

///|
fn Model::witness_ports(
  self : Model,
  ports : Array[Int32],
) -> Array[Array[Bool]] raise Failure {
  let values = []
  for p in ports {
    values.push(Array::make(self.nodes[p].size(), false))
  }
  values
}

///|
/// Read a BTOR2 SAT witness and independently verify every property claim.
/// Omitted free values are completed with zero, not solved existentially.
pub fn Model::read_witness(
  self : Model,
  text : String,
) -> Result[VerifiedWitness, Diagnostic] {
  try {
    let parsed = parse_witness_text(text)
    let count = parsed.frames.length()
    let mut bits = 0
    self.check_work_budget(count)
    for n in self.nodes {
      bits += n.size()
      if bits > 1000000 / count {
        fail(0, "witness frame allocation budget exhausted")
      }
    }
    if parsed.bad.any(i => i >= self.bad.length()) ||
      parsed.justice.any(i => i >= self.justice.length()) {
      fail(0, "witness property ordinal out of range")
    }
    let start_sources : Map[Int32, Int32] = Map([])
    let next_sources : Map[Int32, Int32] = Map([])
    for (target, source) in self.initial {
      start_sources[target] = source
    }
    for (target, source) in self.updates {
      next_sources[target] = source
    }
    let frames = []
    let evaluations : Array[Array[Array[Bool]]] = []
    for t = 0; t < count; t = t + 1 {
      let frame : TypedFrame = {
        state: self.witness_ports(self.states),
        inputs: self.witness_ports(self.inputs),
      }
      let block = parsed.frames[t]
      for row in block.states {
        if row.port >= self.states.length() {
          fail(row.line, "witness port ordinal out of range")
        }
      }
      self.witness_assign(
        block.inputs,
        self.inputs,
        frame.inputs,
        Array::make(self.inputs.length(), false),
      )
      let sources = if t == 0 { start_sources } else { next_sources }
      let locked = self.states.map(p => sources.get(p) is Some(_))
      let values = if t == 0 {
        // Apply free assignments first; topological interpretation resolves init.
        let free_rows = block.states.filter(row => !locked[row.port])
        self.witness_assign(free_rows, self.states, frame.state, locked)
        let initial = self.typed_values(frame, initialize=true)
        for ordinal = 0; ordinal < self.states.length(); ordinal = ordinal + 1 {
          if locked[ordinal] {
            frame.state[ordinal] = initial[self.states[ordinal]].copy()
          }
        }
        self.witness_assign(
          block.states.filter(row => locked[row.port]),
          self.states,
          frame.state,
          locked,
        )
        initial
      } else {
        for ordinal = 0; ordinal < self.states.length(); ordinal = ordinal + 1 {
          if sources.get(self.states[ordinal]) is Some(source) {
            frame.state[ordinal] = evaluations[t - 1][source].copy()
          }
        }
        self.witness_assign(block.states, self.states, frame.state, locked)
        self.typed_values(frame)
      }
      if self.constraints.any(i => !values[i][0]) {
        fail(0, "constraint false in witness frame \{t}")
      }
      evaluations.push(values)
      frames.push(frame)
    }
    let bad_hits = []
    for property in parsed.bad {
      let node = self.bad[property]
      let mut hit = -1
      for t = 0; t < count; t = t + 1 {
        if evaluations[t][node][0] {
          hit = t
          break
        }
      }
      if hit < 0 {
        fail(0, "claimed bad property b\{property} was never reached")
      }
      bad_hits.push((property, hit))
    }
    let mut loop_start = None
    if !parsed.justice.is_empty() {
      let goals = self.fair.copy()
      for property in parsed.justice {
        for goal in self.justice[property] {
          goals.push(goal)
        }
      }
      let final_values = evaluations[count - 1]
      let mut last = count - 1
      for goal in goals {
        let mut seen = -1
        for t = count - 1; t >= 0; t = t - 1 {
          if evaluations[t][goal][0] {
            seen = t
            break
          }
        }
        if seen < last {
          last = seen
        }
      }
      for t = 0; t <= last; t = t + 1 {
        if self.updates.all(pair => {
            evaluations[t][pair.0] == final_values[pair.1]
          }) {
          loop_start = Some(t)
          break
        }
      }
      if loop_start is None {
        fail(
          0, "no closing loop satisfies the claimed justice and fairness properties",
        )
      }
    }
    Ok({ frames, bad_hits, justice: parsed.justice, loop_start, })
  } catch {
    Problem(d) => Err(d)
  }
}

///|
fn StringBuilder::witness_bits(
  self : StringBuilder,
  value : Array[Bool],
  offset : Int32,
  width : Int32,
) -> Unit {
  for i = offset + width - 1; i >= offset; i = i - 1 {
    self.write_char(if value[i] { '1' } else { '0' })
  }
}

///|
fn Model::write_witness_ports(
  self : Model,
  out : StringBuilder,
  ports : Array[Int32],
  values : Array[Array[Bool]],
  skip : Map[Int32, Bool],
  remaining : Ref[Int32],
) -> Unit raise Failure {
  for p = 0; p < ports.length(); p = p + 1 {
    if skip.get(ports[p]) is Some(_) {
      continue
    }
    let node = self.nodes[ports[p]]
    let value = values[p]
    let prefix = "\{p} "
    if node.sort.parts is None {
      remaining.val -= 1
      if remaining.val < 0 {
        fail(0, "witness output row budget exceeded")
      }
      out.write_string(prefix)
      out.witness_bits(value, 0, value.length())
      out.write_char('\n')
    } else {
      let (iw, ew) = witness_array_widths(node.sort, 0)
      let cells = value.length() / ew
      // Missing array cells in the common witness format default to zero.
      for cell = 0; cell < cells; cell = cell + 1 {
        let mut nonzero = false
        for b = 0; b < ew; b = b + 1 {
          if value[cell * ew + b] {
            nonzero = true
            break
          }
        }
        if nonzero {
          remaining.val -= 1
          if remaining.val < 0 {
            fail(0, "witness output row budget exceeded")
          }
          out.write_string(prefix)
          out.write_char('[')
          for b = iw - 1; b >= 0; b = b - 1 {
            out.write_char(if ((cell >> b) & 1) == 1 { '1' } else { '0' })
          }
          out.write_string("] ")
          out.witness_bits(value, cell * ew, ew)
          out.write_char('\n')
        }
      }
    }
  }
}

///|
/// Write a standard SAT witness for a replayable finite bad trace or a
/// justice lasso. The final duplicate frame of a lasso is not written.
pub fn Model::write_witness(
  self : Model,
  trace : TypedTrace,
) -> Result[String, Diagnostic] {
  try {
    let count = trace.frames.length()
    if count < 1 || count > 65 {
      fail(0, "invalid witness frame count")
    }
    self.check_work_budget(count)
    let mut bits = 0
    for n in self.nodes {
      bits += n.size()
      if bits > 1000000 / count {
        fail(0, "witness frame allocation budget exhausted")
      }
    }
    match self.replay_typed(trace) {
      Ok(_) => ()
      Err(d) => raise Problem(d)
    }
    let out = StringBuilder()
    out.write_string("sat\n")
    let limit = match trace.loop_start {
      None => {
        out.write_string("b\{trace.bad_index}\n")
        count
      }
      Some(_) =>
        match trace.justice_index {
          Some(j) => {
            out.write_string("j\{j}\n")
            count - 1
          }
          None =>
            raise Problem({
              line: 0,
              message: "witness requires a b or j claim; fairness alone has no property marker",
            })
        }
    }
    let start : Map[Int32, Bool] = Map([])
    let next : Map[Int32, Bool] = Map([])
    let none : Map[Int32, Bool] = Map([])
    for (target, _) in self.initial {
      start[target] = true
    }
    for (target, _) in self.updates {
      next[target] = true
    }
    let remaining = Ref(199800)
    for t = 0; t < limit; t = t + 1 {
      let frame = trace.frames[t]
      out.write_string("#\{t}\n")
      self.write_witness_ports(
        out,
        self.states,
        frame.state,
        if t == 0 {
          start
        } else {
          next
        },
        remaining,
      )
      out.write_string("@\{t}\n")
      self.write_witness_ports(out, self.inputs, frame.inputs, none, remaining)
    }
    out.write_string(".\n")
    let text = out.to_string()
    if text.length() > 8000000 {
      fail(0, "witness text budget exceeded")
    }
    Ok(text)
  } catch {
    Problem(d) => Err(d)
  }
}
