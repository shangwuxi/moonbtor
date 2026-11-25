///|
fn main raise {
  let source = "1 sort bitvec 2\n2 sort bitvec 1\n3 zero 1\n4 state 1 count\n5 init 1 4 3\n6 inc 1 4\n7 next 1 4 6\n8 constd 1 3\n9 eq 2 4 8\n10 bad 9 overflow"
  let model = @moonbtor.parse(source).unwrap()
  let input = "sat\nb0\n#0\n@0\n#1\n@1\n#2\n@2\n#3\n@3\n.\n"
  let verified = model.read_witness(input).unwrap()
  assert_eq(verified.bad_hits, [(0, 3)])
  let trace : @moonbtor.TypedTrace = {
    frames: verified.frames,
    bad_index: 0,
    loop_start: None,
    justice_index: None,
  }
  let output = model.write_witness(trace).unwrap()
  assert_eq(model.read_witness(output).unwrap(), verified)
  println(output)
  println("standard witness parsed, verified, written, and parsed again")
}
