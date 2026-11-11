///|
test "concrete fixed width arithmetic and simultaneous update" {
  let m = @moonbtor.parse(
    "1 sort bitvec 3\n2 state 1 s\n3 one 1\n4 add 1 2 3\n5 next 1 2 4\n6 output 4",
  ).unwrap()
  let o = m.observe({ state: [7UL], inputs: [], }).unwrap()
  assert_eq(o.outputs, [0UL])
  assert_eq(o.next_state, [Some(0UL)])
  assert_true(m.observe({ state: [8UL], inputs: [], }) is Err(_))
}

///|
test "signed comparison extension and overshift" {
  let m = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 const 1 111\n4 one 1\n5 slt 2 3 4\n6 sra 1 3 3\n7 output 5\n8 output 6",
  ).unwrap()
  assert_eq(m.observe({ state: [], inputs: [], }).unwrap().outputs, [1UL, 7UL])
}
