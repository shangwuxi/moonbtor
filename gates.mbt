///|
/// Literal 1 is true, -1 false. Negation is a sign flip without a new variable.
fn Encoder::and_gate(
  self : Encoder,
  a : Int32,
  b : Int32,
) -> Int32 raise Failure {
  if a == -1 || b == -1 || a == -b {
    return -1
  }
  if a == 1 {
    return b
  }
  if b == 1 || a == b {
    return a
  }
  let z = self.fresh()
  self.add_clause([-z, a])
  self.add_clause([-z, b])
  self.add_clause([z, -a, -b])
  z
}

///|
fn Encoder::or_gate(
  self : Encoder,
  a : Int32,
  b : Int32,
) -> Int32 raise Failure {
  -self.and_gate(-a, -b)
}

///|
fn Encoder::xor_gate(
  self : Encoder,
  a : Int32,
  b : Int32,
) -> Int32 raise Failure {
  if a == b {
    return -1
  }
  if a == -b {
    return 1
  }
  if a == -1 {
    return b
  }
  if b == -1 {
    return a
  }
  if a == 1 {
    return -b
  }
  if b == 1 {
    return -a
  }
  let z = self.fresh()
  self.add_clause([-a, -b, -z])
  self.add_clause([a, b, -z])
  self.add_clause([a, -b, z])
  self.add_clause([-a, b, z])
  z
}

///|
fn Encoder::mux(
  self : Encoder,
  c : Int32,
  a : Int32,
  b : Int32,
) -> Int32 raise Failure {
  if a == b {
    return a
  }
  if c == 1 {
    return a
  }
  if c == -1 {
    return b
  }
  if a == 1 && b == -1 {
    return c
  }
  if a == -1 && b == 1 {
    return -c
  }
  let z = self.fresh()
  self.add_clause([-c, -a, z])
  self.add_clause([-c, a, -z])
  self.add_clause([c, -b, z])
  self.add_clause([c, b, -z])
  z
}

///|
fn Encoder::equal_word(
  self : Encoder,
  a : Array[Int32],
  b : Array[Int32],
) -> Int32 raise Failure {
  let mut equal = 1
  for i = 0; i < a.length(); i = i + 1 {
    equal = self.and_gate(equal, -self.xor_gate(a[i], b[i]))
  }
  equal
}

///|
fn Encoder::mux_word(
  self : Encoder,
  c : Int32,
  a : Array[Int32],
  b : Array[Int32],
) -> Array[Int32] raise Failure {
  let out = []
  for i = 0; i < a.length(); i = i + 1 {
    out.push(self.mux(c, a[i], b[i]))
  }
  out
}
