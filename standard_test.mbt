///|
fn word(n : UInt64, w : Int32) -> Array[Bool] {
  Array::makei(w, i => i < 64 && ((n >> i) & 1UL) != 0UL)
}

///|
fn memory_source() -> String {
  "1 sort bitvec 1\n2 sort bitvec 2\n3 sort array 2 2\n4 zero 2\n5 state 3 mem\n6 init 3 5 4\n7 input 2 addr\n8 input 2 data\n9 write 3 5 7 8\n10 next 3 5 9\n11 read 2 5 7\n12 neq 1 11 4\n13 bad 12\n14 output 11"
}

///|
test "array transition exact CNF decode independent replay and tamper rejection" {
  let m = @moonbtor.parse(memory_source()).unwrap()
  assert_true(m.query(0).unwrap().formula().solve() is Unsatisfiable)
  let q = m.query(1).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => {
      let trace = q.decode_typed(a).unwrap()
      assert_eq(trace.frames.length(), 2)
      assert_eq(trace.frames[0].state[0], word(0UL, 8))
      assert_true(m.replay_typed(trace) is Ok(_))
      assert_true(q.decode(a) is Err(_))
      trace.frames[1].state[0][0] = !trace.frames[1].state[0][0]
      assert_true(m.replay_typed(trace) is Err(_))
    }
    _ => fail("expected memory counterexample")
  }
  assert_true(m.check_typed(1).unwrap() is Counterexample(_))
  assert_true(m.observe({ state: [0UL], inputs: [0UL, 1UL], }) is Err(_))
}

///|
test "array addressing write alias and step preserve all other cells" {
  let m = @moonbtor.parse(memory_source()).unwrap()
  for address = 0; address < 4; address = address + 1 {
    for data = 0; data < 4; data = data + 1 {
      let frame : @moonbtor.TypedFrame = {
        state: [word(228UL, 8)],
        inputs: [word(address.to_uint64(), 2), word(data.to_uint64(), 2)],
      }
      let obs = m.observe_typed(frame).unwrap()
      assert_eq(obs.outputs, [word(address.to_uint64(), 2)])
      let next = m.step_typed(frame, frame.inputs, []).unwrap()
      let expected = word(228UL, 8)
      for bit = 0; bit < 2; bit = bit + 1 {
        expected[address * 2 + bit] = word(data.to_uint64(), 2)[bit]
      }
      assert_eq(next.state, [expected])
    }
  }
}

///|
test "array ite equality and read after write with symbolic alias" {
  let src = "1 sort bitvec 1\n2 sort bitvec 2\n3 sort array 2 2\n4 input 3 arr\n5 input 2 i\n6 input 2 v\n7 input 1 c\n8 write 3 4 5 6\n9 ite 3 7 8 4\n10 read 2 9 5\n11 eq 1 10 6\n12 eq 1 8 4\n13 output 11\n14 output 12\n15 bad 11"
  let m = @moonbtor.parse(src).unwrap()
  for contents = 0; contents < 256; contents = contents + 17 {
    for address = 0; address < 4; address = address + 1 {
      for value = 0; value < 4; value = value + 1 {
        for choice = 0; choice < 2; choice = choice + 1 {
          let equal = ((contents >> (address * 2)) & 3) == value
          let f : @moonbtor.TypedFrame = {
            state: [],
            inputs: [
              word(contents.to_uint64(), 8),
              word(address.to_uint64(), 2),
              word(value.to_uint64(), 2),
              word(choice.to_uint64(), 1),
            ],
          }
          assert_eq(m.observe_typed(f).unwrap().outputs, [
            [choice == 1 || equal],
            [equal],
          ])
        }
      }
    }
  }
  let q = m.query(0).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => ignore(q.decode_typed(a).unwrap())
    _ => fail("array formula")
  }
}

///|
test "wide words parse signed constants shift extension rotation and SAT" {
  let src = "1 sort bitvec 128\n2 sort bitvec 1\n3 input 1 x\n4 consth 1 80000000000000000000000000000001\n5 constd 1 64\n6 eq 2 3 4\n7 constraint 6\n8 rol 1 3 5\n9 consth 1 18000000000000000\n10 eq 2 8 9\n11 bad 10\n12 output 8"
  let m = @moonbtor.parse(src).unwrap()
  let x = Array::make(128, false)
  x[0] = true
  x[127] = true
  let expected = Array::make(128, false)
  expected[63] = true
  expected[64] = true
  assert_eq(m.observe_typed({ state: [], inputs: [x], }).unwrap().outputs, [
    expected,
  ])
  let q = m.query(0).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => ignore(q.decode_typed(a).unwrap())
    _ => fail("wide rotation")
  }
  assert_true(
    @moonbtor.parse(
      "1 sort bitvec 128\n2 constd 1 -170141183460469231731687303715884105728",
    )
    is Ok(_),
  )
  assert_true(
    @moonbtor.parse(
      "1 sort bitvec 128\n2 constd 1 -170141183460469231731687303715884105729",
    )
    is Err(_),
  )
  assert_true(
    @moonbtor.parse(
      "1 sort bitvec 128\n2 constd 1 340282366920938463463374607431768211456",
    )
    is Err(_),
  )
}

///|
test "wide inc and shift amount above 64 cannot wrap host shifts" {
  let src = "1 sort bitvec 128\n2 sort bitvec 1\n3 zero 1\n4 inc 1 3\n5 constd 1 80\n6 sll 1 4 5\n7 consth 1 100000000000000000000\n8 eq 2 6 7\n9 bad 8\n10 output 6"
  let m = @moonbtor.parse(src).unwrap()
  let expected = Array::make(128, false)
  expected[80] = true
  assert_eq(m.observe_typed({ state: [], inputs: [], }).unwrap().outputs, [
    expected,
  ])
  assert_true(m.query(0).unwrap().formula().solve() is Satisfiable(_))
}

///|
test "fair and justice require closed recurring obligations not finite safety" {
  let src = "1 sort bitvec 1\n2 zero 1\n3 state 1 s\n4 init 1 3 2\n5 not 1 3\n6 next 1 3 5\n7 fair 3\n8 justice 2 3 5\n9 bad 3"
  let m = @moonbtor.parse(src).unwrap()
  assert_true(m.query(1) is Err(_))
  assert_true(
    m.lasso_query(1, 0, justice_index=Some(0)).unwrap().formula().solve()
    is Unsatisfiable,
  )
  let q = m.lasso_query(2, 0, justice_index=Some(0)).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => {
      let trace = q.decode_typed(a).unwrap()
      assert_eq(trace.frames[0].state, trace.frames[2].state)
      assert_true(m.replay_typed(trace) is Ok(_))
      assert_true(m.replay_typed({ ..trace, loop_start: Some(1), }) is Err(_))
    }
    _ => fail("expected recurring lasso")
  }
}

///|
test "negative references work but array complements and invalid sort usage fail" {
  let m = @moonbtor.parse("1 sort bitvec 2\n2 one 1\n3 output -2").unwrap()
  assert_eq(m.observe({ state: [], inputs: [], }).unwrap().outputs, [2UL])
  for
    src in [
      "1 sort bitvec 2\n2 sort array 1 1\n3 input 2\n4 eq 1 -3 3", "1 sort bitvec 2\n2 sort array 1 1\n3 zero 2",
      "1 sort bitvec 2\n2 sort array 1 1\n3 state 1\n4 state 2\n5 init 2 4 3", "1 sort bitvec 2\n2 sort array 1 1\n3 input 2\n4 input 1\n5 read 2 3 4",
      "1 sort bitvec 2\n2 input 1\n3 justice 1 2",
    ] {
    assert_true(@moonbtor.parse(src) is Err(_))
  }
}

///|
test "array capacity exhaustion is unknown never bounded safe or truncation" {
  let src = "1 sort bitvec 24\n2 sort bitvec 1\n3 sort array 1 2\n4 input 3\n5 input 1\n6 read 2 4 5\n7 bad 6"
  let m = @moonbtor.parse(src).unwrap()
  assert_true(m.query(0) is Err(_))
  assert_true(m.check_typed(0).unwrap() is Unknown(_))
  assert_true(m.observe_typed({ state: [], inputs: [[], []], }) is Err(_))
}

///|
test "64 bit scalar JSON roundtrip and 4096 bit resource rejection" {
  let t : @moonbtor.Trace = {
    frames: [{ state: [], inputs: [18446744073709551615UL], }],
    bad_index: 0,
  }
  assert_eq(@moonbtor.parse_trace(t.to_json_string()).unwrap(), t)
  let m = @moonbtor.parse(
    "1 sort bitvec 4096\n2 sort bitvec 1\n3 input 1\n4 mul 1 3 3\n5 eq 2 3 4\n6 bad 5",
  ).unwrap()
  assert_true(m.query(0) is Err(_))
  assert_true(m.check_typed(0).unwrap() is Unknown(_))
}
