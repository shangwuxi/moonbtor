///|
test "replay validates init transitions final property and constraints" {
  let model = @moonbtor.parse(
    "1 sort bitvec 2\n2 sort bitvec 1\n3 zero 1\n4 state 1\n5 init 1 4 3\n6 inc 1 4\n7 next 1 4 6\n8 constd 1 2\n9 eq 2 4 8\n10 bad 9",
  ).unwrap()
  let frames : Array[@moonbtor.Frame] = [
    { state: [0UL], inputs: [], },
    { state: [1UL], inputs: [], },
    { state: [2UL], inputs: [], },
  ]
  assert_true(model.replay({ frames, bad_index: 0, }) is Ok(_))
  assert_true(
    model.replay({
      frames: [{ state: [1UL], inputs: [], }, { state: [2UL], inputs: [], }],
      bad_index: 0,
    })
    is Err(_),
  )
  assert_true(
    model.replay({ frames: [frames[0], frames[2]], bad_index: 0, }) is Err(_),
  )
  assert_true(model.replay({ frames: [frames[0]], bad_index: 0, }) is Err(_))
  assert_eq(model.step(frames[0], [], []).unwrap(), frames[1])
}

///|
test "nondeterminism is explicit and synchronous updates are simultaneous" {
  let model = @moonbtor.parse(
    "1 sort bitvec 1\n2 state 1\n3 state 1\n4 next 1 2 3\n5 bad 2",
  ).unwrap()
  let start : @moonbtor.Frame = { state: [0UL, 1UL], inputs: [], }
  assert_eq(model.step(start, [], [0UL]).unwrap().state, [1UL, 0UL])
  assert_true(model.step(start, [], []) is Err(_))
  assert_true(
    model.replay({
      frames: [start, { state: [1UL, 0UL], inputs: [], }],
      bad_index: 0,
    })
    is Ok(_),
  )
}
