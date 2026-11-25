///|
fn nested_model() -> String {
  (
    #|1 sort bitvec 1 flag
    #|2 sort bitvec 2 octet
    #|3 sort array 1 2 row
    #|4 sort array 1 3 matrix
    #|5 sort bitvec 1
    #|6 sort array 5 2
    #|7 zero 2
    #|8 state 3 blank
    #|9 init 6 8 7
    #|10 state 4 grid
    #|11 input 1 x
    #|12 input 1 y
    #|13 input 2 value
    #|14 read 6 10 11
    #|15 write 3 14 12 13
    #|16 write 4 10 11 15
    #|17 next 4 10 16
    #|18 read 3 16 11
    #|19 read 2 18 12
    #|20 output 19
    #|21 neq 1 15 14
    #|22 ite 4 21 16 10
    #|23 eq 1 22 16
    #|24 constraint 23
    #|25 neq 1 19 13
    #|26 bad 25
    #|27 bad 21
  )
}

///|
test "nested elements use structural sort identity and update only one leaf" {
  let model = @moonbtor.parse(nested_model()).unwrap()
  let ty = model.state_sort(1).unwrap()
  let (index, element) = ty.array_parts().unwrap()
  assert_eq(ty.flattened_width(), Some(8))
  assert_eq(index.bit_width(), Some(1))
  assert_eq(element.bit_width(), None)
  assert_eq(element.flattened_width(), Some(4))
  for x = 0; x < 2; x = x + 1 {
    for y = 0; y < 2; y = y + 1 {
      for v = 0; v < 4; v = v + 1 {
        let f : @moonbtor.TypedFrame = {
          state: [word(0UL, 4), word(228UL, 8)],
          inputs: [
            word(x.to_uint64(), 1),
            word(y.to_uint64(), 1),
            word(v.to_uint64(), 2),
          ],
        }
        let obs = model.observe_typed(f).unwrap()
        let offset = (x * 2 + y) * 2
        let expected = (228 & (3 << offset).lnot()) | (v << offset)
        assert_eq(obs.outputs, [f.inputs[2]])
        assert_eq(obs.next_state, [None, Some(word(expected.to_uint64(), 8))])
      }
    }
  }
  let q0 = model.query(0).unwrap()
  let limits = { ..@moonbtor.Limits::default(), max_steps: 20000000, }
  assert_eq(q0.formula().solve(limits~), @moonbtor.Unsatisfiable)
  let q = model.query(1, bad_index=1).unwrap()
  match q.formula().solve() {
    Satisfiable(a) =>
      assert_true(model.replay_typed(q.decode_typed(a).unwrap()) is Ok(_))
    _ => fail("expected a changed row")
  }
}

///|
test "array indices themselves have a finite structural domain" {
  let source =
    #|1 sort bitvec 1
    #|2 sort array 1 1
    #|3 sort array 2 1
    #|4 input 3 data
    #|5 input 2 key
    #|6 input 1 value
    #|7 read 1 4 5
    #|8 output 7
    #|9 write 3 4 5 6
    #|10 read 1 9 5
    #|11 neq 1 10 6
    #|12 bad 11
  let m = @moonbtor.parse(source).unwrap()
  for key = 0; key < 4; key = key + 1 {
    let f : @moonbtor.TypedFrame = {
      state: [],
      inputs: [word(10UL, 4), word(key.to_uint64(), 2), [true]],
    }
    assert_eq(m.observe_typed(f).unwrap().outputs, [[(10 & (1 << key)) != 0]])
  }
  assert_true(m.query(0).unwrap().formula().solve() is Unsatisfiable)
}

///|
test "a matching flattened bit count cannot substitute for a structural sort" {
  let header = "1 sort bitvec 1\n2 sort bitvec 2\n3 sort array 1 1\n4 sort array 2 1\n5 sort array 1 3\n6 input 4\n7 input 5\n8 input 2\n9 input 1\n"
  for
    row in [
      "10 eq 1 6 7", "10 read 2 7 9", "10 read 3 6 8", "10 write 5 7 9 8", "10 ite 4 9 6 7",
    ] {
    assert_true(@moonbtor.parse(header + row) is Err(_))
  }
}

///|
test "nested init references an earlier value with the same structural sort" {
  let source = "1 sort bitvec 1\n2 sort array 1 1\n3 sort array 1 2\n4 state 3 prior\n5 state 3 current\n6 init 3 5 4\n7 next 3 5 4\n8 neq 1 4 5\n9 bad 8"
  let m = @moonbtor.parse(source).unwrap()
  assert_true(m.query(0).unwrap().formula().solve() is Unsatisfiable)
  assert_true(m.query(1).unwrap().formula().solve() is Satisfiable(_))
  assert_true(
    @moonbtor.parse(
      "1 sort bitvec 1\n2 sort array 1 1\n3 sort array 1 2\n4 zero 1\n5 state 3\n6 init 3 5 4",
    )
    is Err(_),
  )
}

///|
test "array-index domain beyond the exact budget parses but does not approximate" {
  let source = "1 sort bitvec 1\n2 sort bitvec 5\n3 sort array 2 1\n4 sort array 3 1\n5 state 4\n6 one 1\n7 bad 6"
  let m = @moonbtor.parse(source).unwrap()
  assert_eq(m.state_sort(0).unwrap().flattened_width(), None)
  assert_true(m.query(0) is Err(_))
  assert_true(m.check_typed(0).unwrap() is Unknown(_))
}
