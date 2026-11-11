///|
test "BTOR2 init expression precedes state and is independent of inputs" {
  assert_true(
    @moonbtor.parse(
      "1 sort bitvec 1\n2 zero 1\n3 state 1\n4 init 1 3 2\n5 bad 3",
    )
    is Ok(_),
  )
  for
    source in [
      "1 sort bitvec 1\n2 state 1\n3 zero 1\n4 init 1 2 3", "1 sort bitvec 1\n2 input 1\n3 not 1 2\n4 state 1\n5 init 1 4 3",
      "1 sort bitvec 1\n2 input 1\n3 state 1\n4 init 1 3 2", "1 sort bitvec 1\n2 state 1\n3 init 1 2 2",
    ] {
    assert_true(@moonbtor.parse(source) is Err(_))
  }
}
