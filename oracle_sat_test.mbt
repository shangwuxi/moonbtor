// Generated independently by Python exhaustive truth assignments.

///|
test "independent SAT enumeration 0" {
  let f = @moonbtor.parse_dimacs("p cnf 5 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 1" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 8\n-3 -1 3 0\n1 -3 0\n1 2 2 3 0\n-2 -3 0\n 0\n-3 3 2 -3 0\n3 2 0\n1 -2 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 2" {
  let f = @moonbtor.parse_dimacs("p cnf 1 2\n1 -1 -1 0\n1 -1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 3" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 4" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 5" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 8\n-3 4 -5 0\n4 0\n5 0\n5 -3 0\n-1 3 -3 0\n-2 3 0\n-1 0\n3 4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 6" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 7\n-1 -2 -1 0\n1 -1 0\n-2 2 1 0\n-2 -1 0\n 0\n-1 -1 0\n-1 2 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 7" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 10\n 0\n-5 2 -4 -5 0\n 0\n4 3 0\n-5 5 5 0\n3 1 -1 2 0\n1 4 2 4 0\n-1 -5 4 0\n 0\n4 1 -3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 8" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 9" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 4\n-1 -1 0\n-1 -2 2 1 0\n-1 1 0\n1 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 10" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 9\n-1 -2 1 0\n-2 2 -2 2 0\n 0\n-1 2 1 0\n1 1 2 -2 0\n-2 0\n1 2 2 0\n 0\n1 -2 -2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 11" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 5\n-1 1 1 0\n 0\n-1 -1 -1 0\n-1 -1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 12" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 4\n 0\n3 -4 -6 -4 0\n3 -6 -4 -4 0\n5 -3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 13" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 14" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 6\n1 2 1 0\n1 -1 -3 -4 0\n-3 -4 2 0\n4 -4 1 -4 0\n3 -4 0\n3 -1 3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 15" {
  let f = @moonbtor.parse_dimacs("p cnf 5 1\n-4 -5 3 -1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 16" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 12\n2 -4 -4 -5 0\n3 6 0\n-1 0\n6 1 6 0\n5 3 4 0\n-3 3 0\n-2 0\n-1 0\n 0\n-2 -4 0\n6 3 -6 3 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 17" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 7\n5 -2 -3 -1 0\n 0\n2 5 -3 0\n-2 -3 3 0\n5 -1 0\n1 4 5 0\n-2 -2 3 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 18" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 7\n2 -1 -1 5 0\n 0\n-5 -3 -5 -2 0\n-1 3 -5 0\n 0\n 0\n-1 2 -2 3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 19" {
  let f = @moonbtor.parse_dimacs("p cnf 5 3\n 0\n3 0\n-1 2 2 -4 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 20" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 8\n 0\n4 0\n-4 0\n-2 4 0\n-4 -3 0\n5 -4 4 0\n6 3 0\n6 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 21" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 6\n-1 0\n-2 2 2 2 0\n2 -2 -1 2 0\n-1 0\n-2 -1 -1 0\n2 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 22" {
  let f = @moonbtor.parse_dimacs("p cnf 1 3\n 0\n 0\n1 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 23" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 9\n1 -2 3 0\n1 0\n-1 0\n1 1 -3 0\n 0\n1 2 -4 1 0\n 0\n4 4 0\n2 3 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 24" {
  let f = @moonbtor.parse_dimacs("p cnf 5 1\n1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 25" {
  let f = @moonbtor.parse_dimacs("p cnf 3 4\n-1 1 0\n3 1 0\n 0\n2 -3 3 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 26" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 12\n-1 -1 1 0\n1 -1 0\n-1 1 0\n-1 -1 0\n-1 -1 1 0\n1 0\n1 -1 1 1 0\n-1 -1 0\n1 1 1 1 0\n1 1 1 1 0\n-1 -1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 27" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 11\n3 -3 -2 -1 0\n 0\n 0\n 0\n-1 -3 0\n-2 -2 0\n1 0\n3 0\n-3 0\n-2 3 1 0\n-3 -3 3 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 28" {
  let f = @moonbtor.parse_dimacs("p cnf 2 2\n-1 0\n2 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 29" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 7\n 0\n-1 -1 0\n1 1 1 1 0\n1 0\n1 0\n 0\n1 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 30" {
  let f = @moonbtor.parse_dimacs("p cnf 1 4\n 0\n1 1 1 0\n1 0\n1 1 -1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 31" {
  let f = @moonbtor.parse_dimacs("p cnf 5 4\n 0\n5 2 0\n1 -4 -2 0\n3 -4 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 32" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 10\n-5 -1 1 0\n4 -3 -5 0\n-5 4 2 1 0\n-3 2 5 5 0\n2 -2 0\n-5 0\n-2 -1 5 0\n-2 1 5 -5 0\n2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 33" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 12\n2 2 0\n-2 0\n1 -2 1 -1 0\n1 0\n 0\n-2 -1 1 1 0\n1 -2 2 -2 0\n1 0\n2 0\n-1 0\n 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 34" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 35" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 8\n-6 -3 -1 -2 0\n 0\n1 0\n 0\n5 6 3 5 0\n-3 -6 -6 0\n-5 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 36" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 11\n2 0\n2 0\n1 0\n2 -2 0\n 0\n-1 -2 -2 -1 0\n 0\n 0\n2 0\n2 0\n2 1 2 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 37" {
  let f = @moonbtor.parse_dimacs("p cnf 5 4\n-1 5 0\n 0\n-1 0\n3 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 38" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 39" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 6\n-4 -4 1 1 0\n-2 -3 -2 0\n5 -3 -5 0\n5 -2 6 0\n4 1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 40" {
  let f = @moonbtor.parse_dimacs("p cnf 6 3\n4 -6 0\n-6 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 41" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 8\n6 2 6 3 0\n1 -3 -3 0\n 0\n2 0\n-4 6 -5 0\n-1 -4 4 0\n-3 4 0\n4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 42" {
  let f = @moonbtor.parse_dimacs("p cnf 6 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 43" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 10\n3 3 -2 0\n-1 0\n2 3 1 0\n2 0\n-1 -3 0\n2 0\n-1 -2 3 3 0\n2 -2 -1 -1 0\n3 3 1 3 0\n2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 44" {
  let f = @moonbtor.parse_dimacs("p cnf 3 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 45" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 10\n3 3 -2 0\n-2 1 2 0\n4 4 0\n-2 0\n2 4 0\n-2 3 2 0\n 0\n-4 -4 1 0\n-1 1 -2 0\n-1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 46" {
  let f = @moonbtor.parse_dimacs("p cnf 4 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 47" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 5\n-1 1 0\n-1 -1 -1 0\n-1 -1 0\n1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 48" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 11\n4 4 2 0\n-2 0\n6 -2 4 0\n-6 -1 -4 -1 0\n-4 -5 6 -4 0\n4 -5 0\n3 -6 3 0\n-1 0\n5 0\n3 -1 0\n6 -4 1 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 49" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 12\n1 -1 1 -1 0\n-1 -1 0\n-1 1 1 0\n1 0\n1 1 -1 0\n 0\n 0\n-1 0\n-1 -1 1 0\n1 -1 1 0\n1 -1 1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 50" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 5\n5 2 2 5 0\n5 0\n-3 -3 -3 -5 0\n-3 1 -4 4 0\n5 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 51" {
  let f = @moonbtor.parse_dimacs("p cnf 5 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 52" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 53" {
  let f = @moonbtor.parse_dimacs("p cnf 3 2\n3 0\n1 3 3 -3 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 54" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 6\n2 3 2 0\n-1 -1 1 -1 0\n-2 2 2 0\n-3 3 3 2 0\n-1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 55" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 11\n-2 2 -2 0\n-2 -1 2 0\n2 -1 -2 -2 0\n-1 2 -1 0\n-2 -2 1 1 0\n-1 2 0\n-2 -1 2 -2 0\n 0\n-2 1 2 -2 0\n-2 0\n1 1 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 56" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 6\n-1 0\n-2 4 3 0\n-3 0\n1 -1 0\n 0\n-1 -4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 57" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 10\n-3 0\n-1 1 -2 3 0\n3 3 2 2 0\n 0\n3 2 0\n 0\n3 0\n 0\n-2 -1 -2 2 0\n3 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 58" {
  let f = @moonbtor.parse_dimacs("p cnf 5 1\n4 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 59" {
  let f = @moonbtor.parse_dimacs("p cnf 5 4\n5 5 0\n-1 -1 0\n-1 0\n-2 -3 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 60" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 12\n-1 0\n1 0\n-1 1 0\n 0\n1 -4 0\n 0\n-1 -4 1 -3 0\n 0\n4 -3 -2 -2 0\n-4 -4 0\n4 -1 4 0\n-3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 61" {
  let f = @moonbtor.parse_dimacs("p cnf 2 1\n-1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 62" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 63" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 6\n2 -4 0\n-5 -3 1 -1 0\n-4 1 3 5 0\n-2 4 -3 -5 0\n-5 0\n5 3 -3 -5 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 64" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 65" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 9\n-1 3 0\n-3 3 2 0\n-3 -2 3 -1 0\n-3 -2 3 0\n-3 -1 0\n-2 1 0\n 0\n-3 0\n-1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 66" {
  let f = @moonbtor.parse_dimacs("p cnf 1 1\n1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 67" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 10\n1 1 2 -2 0\n 0\n 0\n-1 -2 0\n-1 -2 -1 -1 0\n-2 -1 -2 0\n-2 0\n-2 1 1 0\n1 -2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 68" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 12\n6 -3 -3 5 0\n-1 -3 -2 0\n-4 3 0\n-6 1 2 0\n6 -3 0\n-2 -3 -4 0\n-3 3 1 0\n-2 0\n-4 2 -2 -6 0\n3 -3 2 -3 0\n5 1 -1 -2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 69" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 6\n 0\n2 0\n 0\n-1 2 1 -2 0\n-2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 70" {
  let f = @moonbtor.parse_dimacs("p cnf 6 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 71" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 9\n 0\n 0\n 0\n-1 1 0\n 0\n1 1 -1 -1 0\n 0\n-1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 72" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 5\n6 2 -4 -4 0\n-2 -5 -4 -3 0\n3 0\n4 -5 6 6 0\n2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 73" {
  let f = @moonbtor.parse_dimacs("p cnf 4 1\n-4 -4 -1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 74" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 12\n1 -1 1 1 0\n1 -2 0\n1 0\n2 1 1 0\n1 1 0\n-2 0\n1 2 1 0\n 0\n-2 0\n-1 1 0\n2 -1 2 0\n-2 -1 1 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 75" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 8\n-1 0\n 0\n-1 0\n-2 1 2 2 0\n1 1 0\n-1 -1 1 0\n1 -2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 76" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 12\n6 2 -3 -6 0\n-3 -2 6 0\n-2 0\n-6 -6 1 0\n-4 0\n-3 6 0\n 0\n1 -4 -4 0\n 0\n 0\n6 5 0\n4 5 1 -4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 77" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 78" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 5\n-3 2 1 -3 0\n-3 -1 3 0\n1 -2 -4 0\n4 4 -2 0\n-2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 79" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 8\n4 0\n5 0\n2 4 -5 3 0\n-4 -1 0\n3 -1 2 0\n-2 2 -1 0\n4 4 5 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 80" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 4\n-4 -4 -2 0\n-6 -3 2 -3 0\n1 -5 -5 0\n-2 4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 81" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 9\n1 2 -3 1 0\n-1 2 2 2 0\n2 -2 -2 1 0\n 0\n-2 0\n-1 3 -1 0\n-3 -3 3 0\n1 3 0\n-1 -2 3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 82" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 10\n1 3 -1 0\n-2 3 -2 3 0\n1 0\n-1 0\n-2 0\n-3 -1 0\n-2 -1 -1 2 0\n-3 -1 -2 1 0\n1 1 2 0\n1 -2 3 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 83" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 84" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 5\n3 -3 1 3 0\n-1 3 0\n3 0\n2 0\n-4 -3 4 -2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 85" {
  let f = @moonbtor.parse_dimacs("p cnf 2 2\n 0\n-1 -1 -1 -2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 86" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 5\n 0\n3 2 0\n3 -1 1 0\n-4 -3 3 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 87" {
  let f = @moonbtor.parse_dimacs("p cnf 3 3\n-1 1 -1 0\n2 1 2 0\n2 1 -3 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 88" {
  let f = @moonbtor.parse_dimacs("p cnf 4 3\n4 -1 -1 3 0\n-4 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 89" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 90" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 6\n-1 1 -1 0\n-1 1 1 1 0\n1 -1 1 -1 0\n1 1 -1 0\n 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 91" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 10\n4 -2 3 4 0\n 0\n3 0\n-2 -3 4 -1 0\n-1 -1 0\n1 0\n-1 0\n-2 -2 -2 0\n-4 -3 0\n-3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 92" {
  let f = @moonbtor.parse_dimacs("p cnf 2 3\n1 -1 0\n-2 -2 -1 1 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 93" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 8\n1 0\n 0\n2 0\n2 1 2 1 0\n 0\n1 1 2 0\n-1 -2 2 0\n-2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 94" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 8\n-3 -4 -3 0\n3 4 -2 0\n1 2 -3 2 0\n 0\n2 -4 0\n-4 4 -4 -2 0\n 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 95" {
  let f = @moonbtor.parse_dimacs("p cnf 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 96" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 8\n3 0\n 0\n1 0\n 0\n-2 1 0\n-3 3 3 3 0\n 0\n-1 2 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 97" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 11\n-1 0\n2 0\n-2 2 -1 0\n-2 -1 -2 2 0\n2 0\n-2 2 -1 2 0\n 0\n 0\n-1 -1 1 -2 0\n2 2 -1 1 0\n1 1 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 98" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 12\n1 0\n 0\n-2 -3 0\n6 1 0\n 0\n-5 4 0\n2 2 -1 0\n-3 -2 -6 0\n3 5 0\n 0\n5 -5 5 -5 0\n-3 -4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 99" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 10\n-4 0\n1 6 0\n-4 3 2 -3 0\n-5 -6 0\n 0\n-5 -3 6 0\n-3 -5 -3 0\n 0\n-1 -5 -4 4 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 100" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 5\n3 0\n-1 1 -3 -1 0\n5 0\n 0\n3 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 101" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 7\n 0\n 0\n 0\n3 5 4 3 0\n-1 -1 0\n4 -1 -2 -5 0\n4 4 -4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 102" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 10\n-2 0\n 0\n 0\n1 2 0\n2 1 0\n 0\n-1 -2 0\n2 -1 -1 0\n1 0\n1 -1 2 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 103" {
  let f = @moonbtor.parse_dimacs("p cnf 1 3\n1 1 0\n1 -1 -1 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 104" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 105" {
  let f = @moonbtor.parse_dimacs("p cnf 5 3\n-4 4 0\n 0\n1 -4 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 106" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 107" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 108" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 10\n-3 1 -4 0\n 0\n3 -3 -2 0\n 0\n 0\n-4 3 4 -3 0\n3 -1 4 0\n-4 2 1 -3 0\n1 -3 3 0\n4 -2 4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 109" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 110" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 12\n2 -2 2 0\n-1 1 1 -2 0\n1 1 2 2 0\n1 0\n1 0\n1 -1 0\n-2 0\n-2 -2 0\n-1 0\n2 2 2 1 0\n 0\n2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 111" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 11\n-1 0\n-1 1 1 -1 0\n-1 0\n-1 -1 1 1 0\n1 -1 1 1 0\n 0\n-1 0\n-1 1 1 -1 0\n 0\n 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 112" {
  let f = @moonbtor.parse_dimacs("p cnf 2 1\n1 2 1 -2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 113" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 114" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 4\n1 3 3 0\n3 1 -3 2 0\n-1 2 3 0\n-3 -1 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 115" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 116" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 6\n-2 -1 0\n2 1 2 -2 0\n 0\n2 0\n1 2 2 0\n-2 2 1 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 117" {
  let f = @moonbtor.parse_dimacs("p cnf 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 118" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 5\n1 -2 -1 0\n2 -1 2 0\n 0\n-1 -2 -1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 119" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 6\n1 -1 -1 -1 0\n1 -1 -1 -1 0\n1 0\n-1 1 1 1 0\n 0\n-1 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 120" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 8\n-2 1 -3 0\n2 -5 -3 0\n4 2 1 0\n-3 5 -6 -3 0\n6 3 0\n-4 -5 5 0\n-5 -1 0\n-3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 121" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 6\n-2 -1 0\n 0\n 0\n 0\n2 1 2 0\n2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 122" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 6\n2 2 1 -2 0\n-2 2 2 0\n-1 0\n-2 0\n2 0\n-1 -2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 123" {
  let f = @moonbtor.parse_dimacs("p cnf 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 124" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 9\n-4 4 4 0\n4 1 4 -4 0\n-1 2 -3 2 0\n-4 -3 0\n-3 4 1 0\n 0\n3 0\n4 -1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 125" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 12\n-1 2 0\n-1 -1 2 2 0\n 0\n1 -1 0\n1 0\n 0\n2 -2 1 2 0\n1 2 0\n1 0\n 0\n-2 -2 -2 -2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 126" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 5\n-3 -4 0\n2 -3 4 0\n-4 0\n-4 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 127" {
  let f = @moonbtor.parse_dimacs("p cnf 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 128" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 9\n5 -4 3 0\n 0\n-1 -5 3 0\n 0\n1 2 0\n2 0\n-3 4 -3 0\n5 2 -3 5 0\n1 -1 -3 -3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 129" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 130" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 5\n-2 3 -3 0\n3 1 2 0\n-1 0\n-3 3 -2 3 0\n-1 -1 -1 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 131" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 7\n 0\n-1 3 -4 -1 0\n2 -1 -4 0\n 0\n3 0\n2 -3 0\n2 -3 -1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 132" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 4\n-1 1 -1 1 0\n2 -1 0\n-2 -2 2 0\n-2 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 133" {
  let f = @moonbtor.parse_dimacs("p cnf 1 4\n1 1 -1 0\n-1 -1 0\n 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 134" {
  let f = @moonbtor.parse_dimacs("p cnf 2 2\n-1 2 -2 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 135" {
  let f = @moonbtor.parse_dimacs("p cnf 4 3\n4 1 1 2 0\n1 1 3 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 136" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 137" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 11\n-2 0\n 0\n-1 -2 -2 0\n-1 1 0\n-2 2 0\n-1 -2 0\n-1 2 -1 0\n 0\n2 2 -2 2 0\n2 1 -1 1 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 138" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 3\n-3 -1 0\n1 -1 -2 -2 0\n-1 1 2 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 139" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 8\n 0\n3 0\n-2 0\n-4 2 0\n-3 6 -5 1 0\n1 6 -5 5 0\n5 5 -1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 140" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 9\n-2 -4 3 0\n1 4 4 -4 0\n3 3 -3 0\n4 4 2 0\n-5 -3 1 -2 0\n3 -2 -1 -1 0\n-5 -2 -1 0\n-5 0\n-3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 141" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 142" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 12\n-1 -2 -1 0\n-5 3 1 -3 0\n5 -1 4 0\n-2 0\n2 0\n-1 0\n-1 -1 4 0\n-1 3 0\n-3 -1 0\n 0\n-1 3 0\n-3 4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 143" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 12\n3 1 0\n 0\n5 -5 0\n-4 -4 5 -1 0\n 0\n-3 5 0\n5 4 -4 0\n 0\n-4 0\n 0\n2 0\n1 -2 -4 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 144" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 9\n-4 6 -6 -3 0\n-6 2 -1 1 0\n6 0\n-5 3 1 0\n-6 -5 3 0\n1 -4 -6 5 0\n2 3 -3 0\n1 -4 6 1 0\n4 -4 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 145" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 146" {
  let f = @moonbtor.parse_dimacs("p cnf 5 1\n1 1 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 147" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 148" {
  let f = @moonbtor.parse_dimacs("p cnf 2 2\n1 -2 0\n-1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 149" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 7\n 0\n3 0\n-5 -5 0\n 0\n-2 -6 -2 -1 0\n 0\n-6 -4 -1 -6 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 150" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 10\n1 0\n-6 -5 -4 0\n2 3 0\n-5 -1 1 4 0\n 0\n2 -3 -6 5 0\n-5 -2 0\n 0\n 0\n6 -6 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 151" {
  let f = @moonbtor.parse_dimacs("p cnf 2 3\n1 0\n 0\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 152" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 10\n1 3 0\n 0\n-4 -5 -1 0\n-1 1 0\n-6 2 2 0\n5 -2 0\n 0\n 0\n-4 2 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 153" {
  let f = @moonbtor.parse_dimacs("p cnf 2 1\n-2 2 2 -2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 154" {
  let f = @moonbtor.parse_dimacs("p cnf 1 1\n-1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 155" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 10\n 0\n-1 -1 0\n-1 -1 0\n1 -1 -1 -1 0\n1 -1 0\n 0\n 0\n-1 0\n-1 -1 1 1 0\n-1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 156" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 4\n-6 2 3 0\n4 0\n6 3 0\n4 -1 -5 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 157" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 9\n1 -3 1 0\n4 0\n1 -1 -3 0\n1 0\n4 -3 -3 0\n3 2 2 4 0\n-1 -3 3 0\n-2 0\n3 -1 3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 158" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 10\n-2 -2 0\n4 -1 2 0\n-5 0\n3 5 0\n5 0\n2 1 -3 0\n5 -4 0\n4 -2 -1 0\n5 -5 3 0\n3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 159" {
  let f = @moonbtor.parse_dimacs("p cnf 6 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 160" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 9\n-1 1 0\n-1 -1 -1 0\n 0\n 0\n-1 1 1 -1 0\n1 1 1 -1 0\n-1 -1 0\n-1 0\n1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 161" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 4 7\n 0\n1 4 4 1 0\n 0\n-2 2 2 0\n4 0\n-3 3 3 0\n 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 162" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 8\n3 5 1 0\n-1 -2 2 -1 0\n-4 0\n2 3 -4 -1 0\n 0\n1 2 0\n4 -4 0\n4 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 163" {
  let f = @moonbtor.parse_dimacs("p cnf 0 1\n 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 164" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 165" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 3 9\n3 -3 2 0\n-2 0\n1 0\n-2 3 2 0\n1 1 -1 0\n3 2 3 2 0\n-2 3 0\n 0\n2 1 2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 166" {
  let f = @moonbtor.parse_dimacs("p cnf 3 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 167" {
  let f = @moonbtor.parse_dimacs("p cnf 5 2\n 0\n2 -1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 168" {
  let f = @moonbtor.parse_dimacs("p cnf 4 2\n-2 0\n4 -4 -4 2 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 169" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 8\n3 3 0\n1 -3 -5 1 0\n1 -1 0\n5 4 0\n3 1 2 0\n 0\n2 0\n4 3 -2 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 170" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 6\n2 0\n2 1 0\n 0\n-4 1 2 -5 0\n 0\n-5 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 171" {
  let f = @moonbtor.parse_dimacs("p cnf 1 5\n 0\n1 0\n-1 -1 0\n 0\n-1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 172" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 2 9\n2 -1 1 0\n 0\n-1 0\n-1 0\n1 0\n-1 2 0\n-2 0\n 0\n-1 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 173" {
  let f = @moonbtor.parse_dimacs("p cnf 4 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 174" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 5 8\n-1 -2 0\n-3 0\n1 2 -2 4 0\n1 -5 0\n5 0\n5 2 0\n 0\n-1 -3 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 175" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 6 7\n1 -2 0\n-1 6 2 5 0\n2 3 -4 0\n-6 0\n1 0\n-4 3 0\n-6 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 176" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 177" {
  let f = @moonbtor.parse_dimacs(
    "p cnf 1 6\n1 0\n 0\n1 1 0\n1 -1 -1 1 0\n 0\n1 1 0\n",
  ).unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(false)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(true)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 178" {
  let f = @moonbtor.parse_dimacs("p cnf 0 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}

///|
test "independent SAT enumeration 179" {
  let f = @moonbtor.parse_dimacs("p cnf 1 0\n").unwrap()
  match f.solve() {
    Satisfiable(bits) => {
      assert_true(true)
      assert_true(f.accepts(bits))
    }
    Unsatisfiable => assert_true(false)
    Indeterminate(_) => fail("unexpected oracle resource exhaustion")
  }
}
