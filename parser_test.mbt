///|
test "typed sorts constants and located errors" {
  assert_eq(
    @moonbtor.parse("1 sort bitvec 3\n2 const 1 101\n3 output 2")
    .unwrap()
    .node_count(),
    1,
  )
  assert_true(@moonbtor.parse("1 sort bitvec 0") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 33") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 const 1 111") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 constd 1 4") is Err(_))
  assert_eq(
    @moonbtor.parse("1 sort bitvec 2\n2 constd 1 -2").unwrap().node_count(),
    1,
  )
}

///|
test "references instruction tags and arity are checked" {
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 not 1 4") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 input 1\n2 zero 1") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 read 1 1 1") is Err(_))
  assert_true(@moonbtor.parse("1 sort bitvec 2\n2 input 1\n3 bad 2") is Err(_))
}
