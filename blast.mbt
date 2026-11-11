///|
/// Translate one validated instruction into little-endian Boolean literals.
fn Encoder::blast(
  self : Encoder,
  node : Node,
  values : Array[Array[Int32]],
) -> Array[Int32] raise Failure {
  if node.op == "state" || node.op == "input" {
    return self.word(node.width)
  }
  if node.args.is_empty() {
    return constant_word(node.value, node.width)
  }
  let a = values[node.args[0]]
  let b = if node.args.length() > 1 { values[node.args[1]] } else { [] }
  match node.op {
    "not" => a.map(x => -x)
    "neg" => self.neg_word(a)
    "inc" => self.add_word(a, constant_word(1UL, a.length()), -1)
    "dec" => self.add_word(a, constant_word(mask(a.length()), a.length()), -1)
    "add" => self.add_word(a, b, -1)
    "sub" => self.add_word(a, b.map(x => -x), 1)
    "mul" => self.multiply(a, b)
    "ite" => self.mux_word(a[0], b, values[node.args[2]])
    "eq" | "iff" => [self.equal_word(a, b)]
    "neq" => [-self.equal_word(a, b)]
    "implies" => [self.or_gate(-a[0], b[0])]
    "ult" => [self.less_word(a, b)]
    "ulte" => [-self.less_word(b, a)]
    "ugt" => [self.less_word(b, a)]
    "ugte" => [-self.less_word(a, b)]
    "slt" => [self.signed_less(a, b)]
    "slte" => [-self.signed_less(b, a)]
    "sgt" => [self.signed_less(b, a)]
    "sgte" => [-self.signed_less(a, b)]
    "sll" | "srl" | "sra" => self.shift_word(a, b, node.op)
    "slice" => Array::makei(node.width, i => a[i + node.params[1]])
    "concat" => {
      let out = b.copy()
      for bit in a {
        out.push(bit)
      }
      out
    }
    "uext" | "sext" => {
      let out = a.copy()
      let fill = if node.op == "sext" { a[a.length() - 1] } else { -1 }
      for i = a.length(); i < node.width; i = i + 1 {
        out.push(fill)
      }
      out
    }
    "redand" | "redor" | "redxor" => {
      let mut result = if node.op == "redand" { 1 } else { -1 }
      for bit in a {
        result = match node.op {
          "redand" => self.and_gate(result, bit)
          "redor" => self.or_gate(result, bit)
          _ => self.xor_gate(result, bit)
        }
      }
      [result]
    }
    _ => {
      let out = []
      for i = 0; i < a.length(); i = i + 1 {
        let bit = match node.op {
          "and" => self.and_gate(a[i], b[i])
          "or" => self.or_gate(a[i], b[i])
          "xor" => self.xor_gate(a[i], b[i])
          "nand" => -self.and_gate(a[i], b[i])
          "nor" => -self.or_gate(a[i], b[i])
          "xnor" => -self.xor_gate(a[i], b[i])
          _ => {
            fail(0, "internal unsupported bit-blast instruction")
            -1
          }
        }
        out.push(bit)
      }
      out
    }
  }
}
