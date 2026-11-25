///|
fn witness_counter() -> @moonbtor.Model {
  let result = @moonbtor.parse(
    (
      #|1 sort bitvec 2
      #|2 sort bitvec 1
      #|3 one 1
      #|4 state 1 count
      #|5 init 1 4 3
      #|6 inc 1 4
      #|7 next 1 4 6
      #|8 constd 1 2
      #|9 eq 2 4 8
      #|10 bad 9
      #|11 one 2
      #|12 bad 11
    ),
  )
  result.unwrap()
}

///|
test "witness uses zero-based property and model declaration ordinals" {
  let m = witness_counter()
  let w = m
    .read_witness(
      "; sample\r\nsat\r\nb1 b0\r\n#0\r\n0 01 count\r\n@0\r\n@1\r\n@2\r\n.\r\n",
    )
    .unwrap()
  assert_eq(w.bad_hits, [(1, 0), (0, 1)])
  assert_eq(w.frames[1].state, [word(2UL, 2)])
  assert_eq(w.frames[2].state, [word(3UL, 2)])
  assert_eq(w.loop_start, None)
}

///|
test "witness reports structural errors and rejects false claims and contradictions" {
  let m = witness_counter()
  for
    text in [
      "unsat\nb1\n@0\n.\n", "sat\n\n@0\n.\n", "sat\nb0\n@0\n.\n", "sat\nb2\n@0\n.\n",
      "sat\nb1 b1\n@0\n.\n", "sat\nb1\n#0\n0 00\n@0\n.\n", "sat\nb1\n@0\n#1\n0 01\n@1\n.\n",
      "sat\nb1\n@1\n.\n", "sat\nb1\n#0\n#0\n@0\n.\n", "sat\nb1\n#0\n0 01\n0 01\n@0\n.\n",
      "sat\nb1\n#0\n0 1\n@0\n.\n", "sat\nb1\n#0\n0 0x\n@0\n.\n", "sat\nb1\n#0\n0 [0] 1\n@0\n.\n",
      "sat\nb1\n#0\n1 01\n@0\n.\n", "sat\nb1\n#0\n0 01 count extra\n@0\n.\n", "sat\nb1\n@0\n#1\n1 01\n@1\n.\n",
      "sat\nb1\n@0\n0 1\n.\n", "sat\nb1\n@0\n", "sat\nb1\n@0\n.\nextra",
    ] {
    assert_true(m.read_witness(text) is Err(_), msg=text)
  }
}

///|
test "witness uses the initialized value through chains and rejects a contradictory next" {
  let m = @moonbtor.parse(
    "1 sort bitvec 1\n2 state 1 seed\n3 state 1 first\n4 init 1 3 -2\n5 not 1 3\n6 state 1 second\n7 init 1 6 5\n8 next 1 6 3\n9 bad 6",
  ).unwrap()
  let text = "sat\nb0\n#0\n0 1 seed#0\n@0\n#1\n2 0 second#1\n@1\n.\n"
  let w = m.read_witness(text).unwrap()
  assert_eq(w.frames[0].state, [[true], [false], [true]])
  assert_true(
    m.read_witness(text.replace(old="2 0 second#1", new="2 1 second#1"))
    is Err(_),
  )
}

///|
test "witness init follows source state and next follows synchronous transition" {
  let m = @moonbtor.parse(
    "1 sort bitvec 1\n2 state 1 free\n3 state 1 derived\n4 init 1 3 -2\n5 next 1 3 2\n6 bad 3",
  ).unwrap()
  let w = m.read_witness("sat\nb0\n#0\n0 1\n@0\n#1\n0 0\n@1\n.\n").unwrap()
  assert_eq(w.frames[0].state, [[true], [false]])
  assert_eq(w.frames[1].state, [[false], [true]])
  assert_eq(w.bad_hits, [(0, 1)])
}

///|
test "sparse and wildcard array witness values are validated and can round trip" {
  let m = @moonbtor.parse(memory_source()).unwrap()
  let text = "sat\nb0\n#0\n0 [*] 00\n@0\n0 10 addr\n1 11 data\n#1\n0 [10] 11\n0 [*] 00\n@1\n0 10 addr\n.\n"
  let w = m.read_witness(text).unwrap()
  assert_eq(w.bad_hits, [(0, 1)])
  assert_eq(w.frames[1].state, [word(48UL, 8)])
  let trace : @moonbtor.TypedTrace = {
    frames: w.frames,
    bad_index: 0,
    loop_start: None,
    justice_index: None,
  }
  assert_eq(m.read_witness(m.write_witness(trace).unwrap()).unwrap(), w)
  assert_true(
    m.read_witness(text.replace(old="[10] 11", new="[10] 10")) is Err(_),
  )
  assert_true(
    m.read_witness(text.replace(old="0 [10] 11", new="0 [10] 11\n0 [10] 11"))
    is Err(_),
  )
  assert_true(
    m.read_witness(text.replace(old="0 [10] 11", new="0 [1] 11")) is Err(_),
  )
  assert_true(m.write_witness({ ..trace, bad_index: 1, }) is Err(_))
}

///|
test "witness sparse array inputs and free state values round trip" {
  let m = @moonbtor.parse(
    "1 sort bitvec 1\n2 sort array 1 1\n3 state 2 s\n4 input 2 x\n5 eq 1 3 4\n6 bad 5\n7 constraint 5",
  ).unwrap()
  let t = "sat\nb0\n#0\n0 [*] 1\n0 [0] 0\n@0\n0 [1] 1\n.\n"
  let w = m.read_witness(t).unwrap()
  assert_eq(w.frames[0].inputs, [[false, true]])
  let trace : @moonbtor.TypedTrace = {
    frames: w.frames,
    bad_index: 0,
    loop_start: None,
    justice_index: None,
  }
  assert_eq(m.read_witness(m.write_witness(trace).unwrap()).unwrap(), w)
  assert_true(m.read_witness(t.replace(old="[1] 1", new="[0] 1")) is Err(_))
}

///|
test "justice witness includes a closing transition and all recurrence obligations" {
  let src = "1 sort bitvec 1\n2 zero 1\n3 state 1 s\n4 init 1 3 2\n5 not 1 3\n6 next 1 3 5\n7 fair 3\n8 justice 2 3 5\n9 justice 1 2\n10 bad 3"
  let m = @moonbtor.parse(src).unwrap()
  let text = "sat\nj0 b0\n@0\n@1\n.\n"
  let w = m.read_witness(text).unwrap()
  assert_eq(w.loop_start, Some(0))
  assert_eq(w.justice, [0])
  assert_eq(w.bad_hits, [(0, 1)])
  assert_true(m.read_witness("sat\nj0\n@0\n.\n") is Err(_))
  assert_true(m.read_witness(text.replace(old="j0 b0", new="j0 j1")) is Err(_))
  let q = m.lasso_query(2, 0, justice_index=Some(0)).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => {
      let trace = q.decode_typed(a).unwrap()
      let restored = m.read_witness(m.write_witness(trace).unwrap()).unwrap()
      assert_eq(restored.loop_start, Some(0))
      assert_eq(restored.frames, w.frames)
    }
    _ => fail("expected a justice loop")
  }
}

///|
test "finite and mixed witness claims may hit bad before the last frame" {
  let source = "1 sort bitvec 1\n2 zero 1\n3 one 1\n4 state 1 s\n5 init 1 4 2\n6 next 1 4 3\n7 bad -4\n8 bad 4\n9 justice 1 4"
  let m = @moonbtor.parse(source).unwrap()
  let w = m.read_witness("sat\nb0 j0 b1\n@0\n@1\n.\n").unwrap()
  assert_eq(w.bad_hits, [(0, 0), (1, 1)])
  assert_eq(w.loop_start, Some(1))
  assert_eq(m.read_witness("sat\nb0\n@0\n@1\n.\n").unwrap().bad_hits, [(0, 0)])
  let unfair = @moonbtor.parse(source + "\n10 fair -4").unwrap()
  assert_true(unfair.read_witness("sat\nj0\n@0\n@1\n.\n") is Err(_))
}

///|
test "standard witness can derive nested state but cannot encode a nested port row" {
  let m = @moonbtor.parse(
    "1 sort bitvec 1\n2 sort array 1 1\n3 sort array 1 2\n4 state 3\n5 one 1\n6 bad 5",
  ).unwrap()
  let w = m.read_witness("sat\nb0\n@0\n.\n").unwrap()
  assert_eq(w.frames[0].state, [[false, false, false, false]])
  assert_true(m.read_witness("sat\nb0\n#0\n0 [0] 00\n@0\n.\n") is Err(_))
  let trace : @moonbtor.TypedTrace = {
    frames: w.frames,
    bad_index: 0,
    loop_start: None,
    justice_index: None,
  }
  assert_true(m.write_witness(trace) is Err(_))
}
