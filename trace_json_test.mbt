///|
test "versioned trace JSON roundtrips and rejects corrupt schema" {
  let t : @moonbtor.Trace = {
    frames: [{ state: [4294967295UL], inputs: [0UL], }],
    bad_index: 2,
  }
  assert_eq(@moonbtor.parse_trace(t.to_json_string()).unwrap(), t)
  for
    bad in [
      "{}", "{\"version\":1,\"bad_index\":0,\"frames\":[]}", "{\"version\":1,\"version\":1,\"bad_index\":0,\"frames\":[{\"state\":[],\"inputs\":[]}]}",
      "{\"version\":1,\"bad_index\":0.5,\"frames\":[{}]}",
    ] {
    assert_true(@moonbtor.parse_trace(bad) is Err(_))
  }
}
