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
fn signed(value : UInt64, width : Int32) -> Int64 {
  if (value & (1UL << (width - 1))) != 0UL {
    value.to_int64() - (1L << width)
  } else {
    value.to_int64()
  }
}

///|
/// All arithmetic is modulo 2^width, never host-signed arithmetic.
fn eval_node(
  node : Node,
  values : Array[UInt64],
  nodes : Array[Node],
) -> UInt64 {
  if node.args.is_empty() {
    return node.value
  }
  let a = values[node.args[0]]
  let aw = nodes[node.args[0]].width
  let b = if node.args.length() > 1 { values[node.args[1]] } else { 0UL }
  let bit = fn(x : Bool) { if x { 1UL } else { 0UL } }
  let result = match node.op {
    "not" => a.lnot()
    "neg" => 0UL - a
    "inc" => a + 1UL
    "dec" => a - 1UL
    "redand" => bit(a == mask(aw))
    "redor" => bit(a != 0UL)
    "redxor" => {
      let mut parity = 0UL
      for i = 0; i < aw; i = i + 1 {
        parity = parity ^ ((a >> i) & 1UL)
      }
      parity
    }
    "and" => a & b
    "or" => a | b
    "xor" => a ^ b
    "nand" => (a & b).lnot()
    "nor" => (a | b).lnot()
    "xnor" => (a ^ b).lnot()
    "iff" | "eq" => bit(a == b)
    "implies" => bit(a == 0UL || b != 0UL)
    "neq" => bit(a != b)
    "add" => a + b
    "sub" => a - b
    "mul" => a * b
    "ult" => bit(a < b)
    "ulte" => bit(a <= b)
    "ugt" => bit(a > b)
    "ugte" => bit(a >= b)
    "slt" => bit(signed(a, aw) < signed(b, aw))
    "slte" => bit(signed(a, aw) <= signed(b, aw))
    "sgt" => bit(signed(a, aw) > signed(b, aw))
    "sgte" => bit(signed(a, aw) >= signed(b, aw))
    "sll" => if b >= aw.to_uint64() { 0UL } else { a << b.to_int() }
    "srl" => if b >= aw.to_uint64() { 0UL } else { a >> b.to_int() }
    "sra" =>
      if b >= aw.to_uint64() {
        if signed(a, aw) < 0L {
          mask(aw)
        } else {
          0UL
        }
      } else {
        (signed(a, aw) >> b.to_int()).to_uint64()
      }
    "slice" => a >> node.params[1]
    "uext" => a
    "sext" => signed(a, aw).to_uint64()
    "concat" => (a << nodes[node.args[1]].width) | b
    "ite" => if a != 0UL { b } else { values[node.args[2]] }
    _ => node.value
  }
  result & mask(node.width)
}

///|
fn Model::values(self : Model, frame : Frame) -> Array[UInt64] raise Failure {
  if frame.state.length() != self.states.length() ||
    frame.inputs.length() != self.inputs.length() {
    fail(0, "state/input assignment count mismatch")
  }
  let result = Array::make(self.nodes.length(), 0UL)
  for i = 0; i < self.states.length(); i = i + 1 {
    let n = self.states[i]
    if frame.state[i] > mask(self.nodes[n].width) {
      fail(0, "state value exceeds width")
    }
    result[n] = frame.state[i]
  }
  for i = 0; i < self.inputs.length(); i = i + 1 {
    let n = self.inputs[i]
    if frame.inputs[i] > mask(self.nodes[n].width) {
      fail(0, "input value exceeds width")
    }
    result[n] = frame.inputs[i]
  }
  for i = 0; i < self.nodes.length(); i = i + 1 {
    let node = self.nodes[i]
    if node.op != "state" && node.op != "input" {
      result[i] = eval_node(node, result, self.nodes)
    }
  }
  result
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
