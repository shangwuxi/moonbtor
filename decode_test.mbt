///|
test "exact-frame query decodes only satisfying complete assignments" {
  let model = @moonbtor.parse(
    "1 sort bitvec 2\n2 sort bitvec 1\n3 input 1 in\n4 constd 1 2\n5 eq 2 3 4\n6 bad 5",
  ).unwrap()
  let query = model.query(0).unwrap()
  match query.formula().solve() {
    Satisfiable(bits) => {
      assert_eq(query.decode(bits).unwrap().frames[0].inputs, [2UL])
      assert_true(query.decode([]) is Err(_))
      bits[1] = false
      assert_true(query.decode(bits) is Err(_))
    }
    _ => fail("expected SAT")
  }
  assert_true(query.literals(-1, 3) is None)
  assert_true(query.literals(0, 999) is None)
  let copied = query.literals(0, 3).unwrap()
  copied[0] = 0
  assert_true(query.literals(0, 3).unwrap()[0] != 0)
}
