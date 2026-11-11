///|
fn satisfied(formula : Formula, bits : Array[Bool]) -> Bool {
  formula.clauses.all(c => c.any(l => if l > 0 { bits[l] } else { !bits[-l] }))
}

///|
test "Tseitin gates have exactly the expected truth tables" {
  for kind in ["and", "or", "xor", "mux"] {
    let e = Encoder::new(Limits::default())
    let a = e.fresh()
    let b = e.fresh()
    let c = e.fresh()
    let z = match kind {
      "and" => e.and_gate(a, b)
      "or" => e.or_gate(a, b)
      "xor" => e.xor_gate(a, b)
      _ => e.mux(c, a, b)
    }
    let f = e.finish()
    for n = 0; n < 1 << (f.variables - 1); n = n + 1 {
      let bits = Array::makei(f.variables + 1, i => {
        if i == 1 {
          true
        } else {
          ((n >> (i - 2)) & 1) != 0
        }
      })
      let expected = match kind {
        "and" => bits[a] && bits[b]
        "or" => bits[a] || bits[b]
        "xor" => bits[a] != bits[b]
        _ => if bits[c] { bits[a] } else { bits[b] }
      }
      let output = if z > 0 { bits[z] } else { !bits[-z] }
      assert_eq(satisfied(f, bits), output == expected)
    }
  }
}
