///|
test "parser budgets comments CRLF and width limits are enforced" {
  let limits = @moonbtor.ParseLimits::default()
  assert_true(
    @moonbtor.parse(
      "; comment\r\n1 sort bitvec 1\r\n2 one 1 ; comment\r\n3 bad 2",
    )
    .unwrap()
    .check(0)
    .unwrap()
    is Counterexample(_),
  )
  assert_true(
    @moonbtor.parse("1 sort bitvec 1\n2 one 1", limits={
      ..limits,
      max_nodes: 0,
    })
    is Err(_),
  )
  assert_true(
    @moonbtor.parse("1 sort bitvec 1\n2 one 1", limits={
      ..limits,
      max_lines: 1,
    })
    is Err(_),
  )
  assert_true(
    @moonbtor.parse("1 sort bitvec 1\n2 one 1", limits={
      ..limits,
      max_line_length: 3,
    })
    is Err(_),
  )
  for
    source in [
      "1 sort array 1 2", "2147483648 sort bitvec 1", "1 sort bitvec -1", "1 sort bitvec 1\n2 one 1\n3 add 1 2",
      "1 sort bitvec 1\n2 state 1\n3 init 1 2 2\n4 init 1 2 2", "1 sort bitvec 2\n2 input 1\n3 slice 1 2 4 0",
    ] {
    assert_true(@moonbtor.parse(source) is Err(_))
  }
}

///|
test "replay rejects tampered inputs constraints and JSON numeric forms" {
  let m = @moonbtor.parse("1 sort bitvec 1\n2 input 1\n3 constraint 2\n4 bad 2").unwrap()
  assert_true(
    m.replay({ frames: [{ state: [], inputs: [0UL], }], bad_index: 0, })
    is Err(_),
  )
  for value in ["-1", "4294967296", "1x", ""] {
    let text = "{\"version\":1,\"bad_index\":0,\"frames\":[{\"state\":[],\"inputs\":[\"\{value}\"]}]}"
    assert_true(@moonbtor.parse_trace(text) is Err(_))
  }
  assert_true(
    @moonbtor.parse_trace(
      "{\"version\":1,\"bad_index\":0,\"frames\":[{\"state\":[],\"inputs\":[1]}]}",
    )
    is Err(_),
  )
}

///|
test "solver never mistakes decision-depth exhaustion for UNSAT" {
  let f = @moonbtor.parse_dimacs("p cnf 2 1\n1 2 0").unwrap()
  let normal = @moonbtor.Limits::default()
  assert_true(
    f.solve(limits={ ..normal, max_decisions: 0, }) is Indeterminate(_),
  )
  assert_true(f.solve() is Satisfiable(_))
}
