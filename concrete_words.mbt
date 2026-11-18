///|
fn concrete_word(value : UInt64, width : Int32) -> Array[Bool] {
  Array::makei(width, i => i < 64 && ((value >> i) & 1UL) != 0UL)
}

///|
fn concrete_number(bits : Array[Bool]) -> UInt64 {
  let mut n = 0UL
  for i = 0; i < bits.length() && i < 64; i = i + 1 {
    if bits[i] {
      n = n | (1UL << i)
    }
  }
  n
}

///|
fn concrete_add(
  a : Array[Bool],
  b : Array[Bool],
  carry_in~ : Bool = false,
) -> Array[Bool] {
  let mut carry = carry_in
  Array::makei(a.length(), i => {
    let n = (if a[i] { 1 } else { 0 }) +
      (if b[i] { 1 } else { 0 }) +
      (if carry { 1 } else { 0 })
    carry = n >= 2
    n % 2 == 1
  })
}

///|
fn concrete_neg(a : Array[Bool]) -> Array[Bool] {
  concrete_add(a.map(x => !x), Array::make(a.length(), false), carry_in=true)
}

///|
fn concrete_less(a : Array[Bool], b : Array[Bool]) -> Bool {
  for i = a.length() - 1; i >= 0; i = i - 1 {
    if a[i] != b[i] {
      return b[i]
    }
  }
  false
}

///|
fn concrete_mul(a : Array[Bool], b : Array[Bool]) -> Array[Bool] {
  let mut out = Array::make(a.length(), false)
  for j = 0; j < b.length(); j = j + 1 {
    if b[j] {
      out = concrete_add(out, Array::makei(a.length(), i => i >= j && a[i - j]))
    }
  }
  out
}

///|
/// Restoring unsigned division defines x/0 = all ones and x%0 = x.
fn concrete_div(a : Array[Bool], b : Array[Bool]) -> (Array[Bool], Array[Bool]) {
  let width = a.length()
  let q = Array::make(width, false)
  let mut r = Array::make(width + 1, false)
  let divisor = Array::makei(width + 1, i => i < width && b[i])
  for i = width - 1; i >= 0; i = i - 1 {
    r = Array::makei(width + 1, j => if j == 0 { a[i] } else { r[j - 1] })
    if !concrete_less(r, divisor) {
      r = concrete_add(r, concrete_neg(divisor))
      q[i] = true
    }
  }
  (q, Array::makei(width, i => r[i]))
}

///|
fn concrete_extend(
  a : Array[Bool],
  width : Int32,
  signed~ : Bool = false,
) -> Array[Bool] {
  Array::makei(width, i => {
    if i < a.length() {
      a[i]
    } else {
      signed && a[a.length() - 1]
    }
  })
}

///|
fn concrete_operation(node : Node, values : Array[Array[Bool]]) -> Array[Bool] {
  if node.args.is_empty() {
    return node.value_bits.copy()
  }
  let a = values[node.args[0]]
  let w = a.length()
  let b = if node.args.length() > 1 { values[node.args[1]] } else { [] }
  let sa = a[w - 1]
  let sb = if b.is_empty() { false } else { b[b.length() - 1] }
  match node.op {
    "not" => a.map(x => !x)
    "neg" => concrete_neg(a)
    "inc" => concrete_add(a, concrete_word(1UL, w))
    "dec" => concrete_add(a, Array::make(w, true))
    "add" => concrete_add(a, b)
    "sub" => concrete_add(a, concrete_neg(b))
    "mul" => concrete_mul(a, b)
    "and" => Array::makei(w, i => a[i] && b[i])
    "or" => Array::makei(w, i => a[i] || b[i])
    "xor" => Array::makei(w, i => a[i] != b[i])
    "nand" => Array::makei(w, i => !(a[i] && b[i]))
    "nor" => Array::makei(w, i => !(a[i] || b[i]))
    "xnor" => Array::makei(w, i => a[i] == b[i])
    "eq" | "iff" => [a == b]
    "neq" => [a != b]
    "implies" => [!a[0] || b[0]]
    "redand" => [a.all(x => x)]
    "redor" => [a.any(x => x)]
    "redxor" => {
      let mut p = false
      for bit in a {
        p = p != bit
      }
      [p]
    }
    "ult" => [concrete_less(a, b)]
    "ulte" => [!concrete_less(b, a)]
    "ugt" => [concrete_less(b, a)]
    "ugte" => [!concrete_less(a, b)]
    "slt" => [if sa != sb { sa } else { concrete_less(a, b) }]
    "slte" => [if sa != sb { sa } else { !concrete_less(b, a) }]
    "sgt" => [if sa != sb { sb } else { concrete_less(b, a) }]
    "sgte" => [if sa != sb { sb } else { !concrete_less(a, b) }]
    "udiv" | "urem" => {
      let (q, r) = concrete_div(a, b)
      if node.op == "udiv" {
        q
      } else {
        r
      }
    }
    "sdiv" | "srem" | "smod" => {
      let (q, r) = concrete_div(
        if sa {
          concrete_neg(a)
        } else {
          a
        },
        if sb {
          concrete_neg(b)
        } else {
          b
        },
      )
      if node.op == "sdiv" {
        if sa != sb {
          concrete_neg(q)
        } else {
          q
        }
      } else {
        let r = if sa { concrete_neg(r) } else { r }
        if node.op == "smod" && sa != sb && r.any(x => x) {
          concrete_add(r, b)
        } else {
          r
        }
      }
    }
    "sll" | "srl" | "sra" | "rol" | "ror" => {
      let rotate = node.op == "rol" || node.op == "ror"
      let mut amount = 0
      for j = b.length() - 1; j >= 0; j = j - 1 {
        amount = amount * 2 + (if b[j] { 1 } else { 0 })
        amount = if rotate {
          amount % w
        } else if amount < w {
          amount
        } else {
          w
        }
      }
      Array::makei(w, i => {
        let k = if node.op == "sll" || node.op == "rol" {
          i - amount
        } else {
          i + amount
        }
        if rotate {
          a[(k + w) % w]
        } else if k < 0 || k >= w {
          node.op == "sra" && sa
        } else {
          a[k]
        }
      })
    }
    "slice" => Array::makei(node.width, i => a[i + node.params[1]])
    "uext" | "sext" => concrete_extend(a, node.width, signed=node.op == "sext")
    "concat" =>
      Array::makei(node.width, i => {
        if i < b.length() {
          b[i]
        } else {
          a[i - b.length()]
        }
      })
    "ite" => (if a[0] { b } else { values[node.args[2]] }).copy()
    "read" => {
      let offset = concrete_number(b).to_int() * node.width
      Array::makei(node.width, i => a[offset + i])
    }
    "write" => {
      let offset = concrete_number(b).to_int() * node.width
      let c = values[node.args[2]]
      Array::makei(w, i => {
        if i >= offset && i < offset + node.width {
          c[i - offset]
        } else {
          a[i]
        }
      })
    }
    "uaddo" => [concrete_less(concrete_add(a, b), a)]
    "usubo" => [concrete_less(a, b)]
    "saddo" => [sa == sb && concrete_add(a, b)[w - 1] != sa]
    "ssubo" => [sa != sb && concrete_add(a, concrete_neg(b))[w - 1] != sa]
    "sdivo" => [sa && !a.iter().take(w - 1).any(x => x) && b.all(x => x)]
    "umulo" | "smulo" => {
      let s = node.op == "smulo"
      let product = concrete_mul(
        concrete_extend(a, w * 2, signed=s),
        concrete_extend(b, w * 2, signed=s),
      )
      [
        Array::makei(w, i => product[i + w] != (s && product[w - 1])).any(x => x),
      ]
    }
    _ => [] // Only reached on an internal bug: parser validates the full tag set.
  }
}
