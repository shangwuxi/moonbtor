///|
/// Strip comments before splitting ASCII grammar whitespace.
fn tokens(line : String) -> Array[String] {
  let result : Array[String] = []
  let mut word = StringBuilder::new()
  for c in line {
    if c == ';' {
      break
    }
    if c == ' ' || c == '\t' || c == '\r' {
      if word.to_string().length() > 0 {
        result.push(word.to_string())
        word = StringBuilder::new()
      }
    } else {
      word.write_char(c)
    }
  }
  if word.to_string().length() > 0 {
    result.push(word.to_string())
  }
  result
}

///|
fn natural(text : String, line : Int32) -> Int32 raise Failure {
  if text.length() == 0 {
    fail(line, "empty integer")
  }
  let mut n = 0
  for c in text {
    let d = c.to_int() - 48
    if d < 0 || d > 9 || n > (2147483647 - d) / 10 {
      fail(line, "invalid or overflowing nonnegative integer")
    }
    n = n * 10 + d
  }
  n
}

///|
/// Parse constants without platform signed overflow or silent truncation.
fn constant(
  text : String,
  base : Int32,
  width : Int32,
  line : Int32,
) -> UInt64 raise Failure {
  let mut negative = false
  let mut start = 0
  if text.length() > 0 && text[0] == '-' {
    if base != 10 {
      fail(line, "only decimal constants may be negative")
    }
    negative = true
    start = 1
  }
  if start == text.length() {
    fail(line, "empty constant")
  }
  let mut value = 0UL
  for i = start; i < text.length(); i = i + 1 {
    let c = text[i].to_int()
    let digit = if c >= 48 && c <= 57 {
      c - 48
    } else if c >= 65 && c <= 70 {
      c - 55
    } else if c >= 97 && c <= 102 {
      c - 87
    } else {
      -1
    }
    if digit < 0 || digit >= base {
      fail(line, "invalid constant digit")
    }
    let d = digit.to_uint64()
    let b = base.to_uint64()
    let limit = if negative { 1UL << (width - 1) } else { mask(width) }
    if d > limit || value > (limit - d) / b {
      fail(line, "constant does not fit declared width")
    }
    value = value * b + d
  }
  if negative {
    (0UL - value) & mask(width)
  } else {
    value
  }
}

///|
fn need(
  words : Array[String],
  count : Int32,
  line : Int32,
) -> Unit raise Failure {
  if words.length() != count && words.length() != count + 1 {
    fail(line, "wrong field count (at most one symbol is allowed)")
  }
}

///|
fn lookup(
  table : Map[Int32, Int32],
  id : Int32,
  line : Int32,
) -> Int32 raise Failure {
  match table.get(id) {
    Some(index) => index
    None => {
      fail(line, "unknown or forward node reference")
      0
    }
  }
}
