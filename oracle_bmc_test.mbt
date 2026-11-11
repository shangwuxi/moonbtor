// Python reachable-set exploration; no SAT or MoonBit evaluator used.

///|
test "Python reachability init0 target0 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 0\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 1)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target0 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 0\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 1)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target1 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 1\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 2)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target1 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 1\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 2)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target2 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 2\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 3)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target2 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 2\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 3)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target3 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 3\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 4)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target3 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 3\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 4)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target4 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 4\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 5)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target4 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 4\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init0 target5 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 5\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 6)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init0 target5 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 5\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init0 target6 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 6\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init0 target6 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 6\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init0 target7 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 7\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init0 target7 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 0\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 7\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target0 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 0\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 6)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target0 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 0\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target1 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 1\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target1 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 1\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target2 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 2\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target2 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 2\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target3 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 3\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 1)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target3 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 3\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 1)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target4 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 4\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 2)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target4 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 4\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target5 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 5\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 3)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target5 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 5\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target6 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 6\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 4)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target6 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 6\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}

///|
test "Python reachability init3 target7 forbidden-1" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 7\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13",
  ).unwrap()
  let result = model.check(5).unwrap()
  match result {
    Counterexample(t) => {
      assert_eq(t.frames.length(), 5)
      assert_true(model.replay(t) is Ok(_))
    }
    _ => fail("expected reachable bad state")
  }
}

///|
test "Python reachability init3 target7 forbidden4" {
  let model = @moonbtor.parse(
    "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 u\n4 constd 1 3\n5 state 1 x\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 7\n10 eq 2 5 9\n11 bad 10\n12 constd 1 1\n13 ulte 2 3 12\n14 constraint 13\n15 constd 1 4\n16 neq 2 5 15\n17 constraint 16",
  ).unwrap()
  let result = model.check(5).unwrap()
  assert_eq(result, @moonbtor.BoundedSafe(5))
}
