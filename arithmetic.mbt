///|
/// Ripple carry addition returns the low width bits, matching modular BTOR2 add.
fn Encoder::add_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
  carry_in : Int32,
) -> Array[Int32] raise Failure {
  let result = []
  let mut carry = carry_in
  for i = 0; i < a.length(); i = i + 1 {
    let both = self.and_gate(a[i], b[i])
    let either = self.xor_gate(a[i], b[i])
    result.push(self.xor_gate(either, carry))
    carry = self.or_gate(both, self.and_gate(either, carry))
  }
  result
}

///|
fn Encoder::neg_word(
  self : Encoder,
  a : Array[Int32],
) -> Array[Int32] raise Failure {
  self.add_word(a.map(x => -x), constant_word(0UL, a.length()), 1)
}

///|
/// Schoolbook multiplication drops high partial products before constructing gates.
fn Encoder::multiply(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
) -> Array[Int32] raise Failure {
  let width = a.length()
  let mut result = constant_word(0UL, width)
  for j = 0; j < width; j = j + 1 {
    let partial = []
    for i = 0; i < width; i = i + 1 {
      partial.push(if i < j { -1 } else { self.and_gate(a[i - j], b[j]) })
    }
    result = self.add_word(result, partial, -1)
  }
  result
}

///|
/// Unsigned lexicographic comparison over little-endian words.
fn Encoder::less_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
) -> Int32 raise Failure {
  let mut less = -1
  for i = 0; i < a.length(); i = i + 1 {
    let different = self.xor_gate(a[i], b[i])
    less = self.mux(different, b[i], less)
  }
  less
}

///|
fn Encoder::signed_less(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
) -> Int32 raise Failure {
  let top = a.length() - 1
  let sign_differs = self.xor_gate(a[top], b[top])
  self.mux(sign_differs, a[top], self.less_word(a, b))
}

///|
/// Logarithmic barrel shifts also handle oversized amounts through sign/zero fill.
fn Encoder::shift_word(
  self : Encoder,
  a : Array[Int32],
  amount : Array[Int32],
  op : String,
) -> Array[Int32] raise Failure {
  let width = a.length()
  let fill = if op == "sra" { a[width - 1] } else { -1 }
  let mut result = a.copy()
  for j = 0; j < amount.length(); j = j + 1 {
    let distance = if j < 6 { 1 << j } else { 64 }
    let shifted = []
    for i = 0; i < width; i = i + 1 {
      let source = if op == "sll" { i - distance } else { i + distance }
      shifted.push(
        if source < 0 || source >= width {
          fill
        } else {
          result[source]
        },
      )
    }
    result = self.mux_word(amount[j], shifted, result)
  }
  result
}
