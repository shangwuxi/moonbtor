///|
fn counter() -> @moonbtor.Model {
  @moonbtor.parse(
    "1 sort bitvec 2\n2 sort bitvec 1\n3 state 1 count\n4 zero 1\n5 init 1 3 4\n6 inc 1 3\n7 next 1 3 6\n8 constd 1 3\n9 eq 2 3 8\n10 bad 9 overflow",
  ).unwrap()
}

///|
test "BMC finds shortest counterexample and respects finite bounds" {
  let model = counter()
  assert_eq(model.check(2).unwrap(), @moonbtor.BoundedSafe(2))
  match model.check(5).unwrap() {
    Counterexample(trace) => {
      assert_eq(trace.frames.map(f => f.state[0]), [0UL, 1UL, 2UL, 3UL])
      assert_true(model.replay(trace) is Ok(_))
    }
    _ => fail("expected counterexample")
  }
  assert_true(model.check(-1) is Err(_))
  assert_true(model.check(65) is Err(_))
  assert_true(model.check(1, bad_index=1) is Err(_))
}

///|
test "future constraints cannot mask an earlier bug" {
  let model = @moonbtor.parse(
    "1 sort bitvec 1\n2 state 1\n3 zero 1\n4 one 1\n5 init 1 2 3\n6 next 1 2 4\n7 not 1 2\n8 constraint 7\n9 bad 7",
  ).unwrap()
  assert_true(model.check(5).unwrap() is Counterexample(_))
  assert_true(model.query(1).unwrap().formula().solve() is Unsatisfiable)
}

///|
test "resource exhaustion is unknown rather than safe" {
  let model = counter()
  let tiny : @moonbtor.Limits = {
    max_variables: 1,
    max_clauses: 1,
    max_steps: 1,
    max_decisions: 0,
  }
  assert_true(model.check(3, limits=tiny).unwrap() is Unknown(_))
  let normal = @moonbtor.Limits::default()
  let low_work = { ..normal, max_steps: 1, }
  assert_true(model.check(3, limits=low_work).unwrap() is Unknown(_))
  assert_true(model.query(1, limits=tiny) is Err(_))
}

///|
test "every prefix constraint and simultaneous update are enforced" {
  let model = @moonbtor.parse(
    "1 sort bitvec 1\n2 state 1 a\n3 state 1 b\n4 zero 1\n5 one 1\n6 init 1 2 4\n7 init 1 3 5\n8 next 1 2 3\n9 next 1 3 2\n10 bad 2",
  ).unwrap()
  match model.check(2).unwrap() {
    Counterexample(t) =>
      assert_eq(t.frames.map(f => f.state), [[0UL, 1UL], [1UL, 0UL]])
    _ => fail("expected swap witness")
  }
}
