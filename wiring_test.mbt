///|
test "slice concat zero and sign extension preserve bit significance" {
  for a = 0; a < 8; a = a + 1 {
    for b = 0; b < 4; b = b + 1 {
      let source = "1 sort bitvec 3\n2 sort bitvec 2\n3 sort bitvec 5\n4 sort bitvec 1\n5 input 1\n6 input 2\n7 concat 3 5 6\n8 slice 1 7 4 2\n9 slice 2 7 1 0\n10 uext 3 5 2\n11 sext 3 5 2\n12 eq 4 8 5\n13 eq 4 9 6\n14 and 4 12 13\n15 bad 14\n16 output 7\n17 output 10\n18 output 11"
      let m = @moonbtor.parse(source).unwrap()
      let observed = m
        .observe({ state: [], inputs: [a.to_uint64(), b.to_uint64()], })
        .unwrap()
      let signed_ext = if a >= 4 { (a + 24).to_uint64() } else { a.to_uint64() }
      assert_eq(observed.outputs, [
        (a * 4 + b).to_uint64(),
        a.to_uint64(),
        signed_ext,
      ])
      // The property is universally true; negating it must be UNSAT.
      let negated = @moonbtor.parse(
        source.replace_all(old="14 and", new="14 nand"),
      ).unwrap()
      assert_true(negated.query(0).unwrap().formula().solve() is Unsatisfiable)
    }
  }
}

///|
test "ite selects each branch and symbolic bit-blast agrees" {
  let source = "1 sort bitvec 1\n2 sort bitvec 3\n3 input 1 cond\n4 input 2 a\n5 input 2 b\n6 ite 2 3 4 5\n7 output 6\n8 eq 1 6 4\n9 bad 8\n10 constraint 3"
  let m = @moonbtor.parse(source).unwrap()
  for c = 0; c < 2; c = c + 1 {
    assert_eq(
      m.observe({ state: [], inputs: [c.to_uint64(), 7UL, 2UL], }).unwrap().outputs,
      [if c == 0 { 2UL } else { 7UL }],
    )
  }
  let wrong = @moonbtor.parse(source.replace_all(old="8 eq", new="8 neq")).unwrap()
  assert_true(wrong.query(0).unwrap().formula().solve() is Unsatisfiable)
}
