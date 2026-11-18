///|
fn Encoder::unsigned_divide(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
) -> (Array[Int32], Array[Int32]) raise Failure {
  let w = a.length()
  let q = Array::make(w, -1)
  let divisor = Array::makei(w + 1, i => if i < w { b[i] } else { -1 })
  let mut remainder = Array::make(w + 1, -1)
  for i = w - 1; i >= 0; i = i - 1 {
    let shifted = Array::makei(w + 1, j => {
      if j == 0 {
        a[i]
      } else {
        remainder[j - 1]
      }
    })
    q[i] = -self.less_word(shifted, divisor)
    let difference = self.add_word(shifted, divisor.map(x => -x), 1)
    remainder = self.mux_word(q[i], difference, shifted)
  }
  (q, Array::makei(w, i => remainder[i]))
}

///|
fn Encoder::divide_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
  op : String,
) -> Array[Int32] raise Failure {
  if op == "udiv" || op == "urem" {
    let (q, r) = self.unsigned_divide(a, b)
    return if op == "udiv" { q } else { r }
  }
  let sa = a[a.length() - 1]
  let sb = b[b.length() - 1]
  let aa = self.mux_word(sa, self.neg_word(a), a)
  let bb = self.mux_word(sb, self.neg_word(b), b)
  let (q, r) = self.unsigned_divide(aa, bb)
  if op == "sdiv" {
    return self.mux_word(self.xor_gate(sa, sb), self.neg_word(q), q)
  }
  let signed_r = self.mux_word(sa, self.neg_word(r), r)
  if op == "srem" {
    return signed_r
  }
  let nonzero = -self.equal_word(r, Array::make(r.length(), -1))
  let adjust = self.and_gate(nonzero, self.xor_gate(sa, sb))
  self.mux_word(adjust, self.add_word(signed_r, b, -1), signed_r)
}

///|
fn Encoder::rotate_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
  op : String,
) -> Array[Int32] raise Failure {
  let w = a.length()
  let mut distance = 1 % w
  let mut result = a.copy()
  for bit in b {
    let shifted = Array::makei(w, i => {
      result[(if op == "rol" { i - distance + w } else { i + distance }) % w]
    })
    result = self.mux_word(bit, shifted, result)
    distance = distance * 2 % w
  }
  result
}

///|
fn Encoder::overflow_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
  op : String,
) -> Int32 raise Failure {
  let w = a.length()
  let sa = a[w - 1]
  let sb = b[w - 1]
  match op {
    "uaddo" => self.less_word(self.add_word(a, b, -1), a)
    "usubo" => self.less_word(a, b)
    "saddo" =>
      self.and_gate(
        -self.xor_gate(sa, sb),
        self.xor_gate(sa, self.add_word(a, b, -1)[w - 1]),
      )
    "ssubo" =>
      self.and_gate(
        self.xor_gate(sa, sb),
        self.xor_gate(sa, self.add_word(a, b.map(x => -x), 1)[w - 1]),
      )
    "sdivo" => {
      let min = Array::makei(w, i => if i == w - 1 { 1 } else { -1 })
      self.and_gate(
        self.equal_word(a, min),
        self.equal_word(b, Array::make(w, 1)),
      )
    }
    _ => {
      let signed = op == "smulo"
      let aa = Array::makei(w * 2, i => {
        if i < w {
          a[i]
        } else if signed {
          sa
        } else {
          -1
        }
      })
      let bb = Array::makei(w * 2, i => {
        if i < w {
          b[i]
        } else if signed {
          sb
        } else {
          -1
        }
      })
      let product = self.multiply(aa, bb)
      let fill = if signed { product[w - 1] } else { -1 }
      let mut overflow = -1
      for i = w; i < w * 2; i = i + 1 {
        overflow = self.or_gate(overflow, self.xor_gate(product[i], fill))
      }
      overflow
    }
  }
}
