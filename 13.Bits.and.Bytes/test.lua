--Lua handles binary data similarly to text. A string in Lua can contain any bytes, and almost all library
--functions that handle strings can handle arbitrary bytes. We can even do pattern matching on binary data.
--On top of that, Lua 5.3 introduced extra facilities to manipulate binary data: besides integer numbers, it
--brought bitwise operators and functions to pack and unpack binary data. In this chapter, we will cover
--these and other facilities for handling binary data in Lua.

-- & |  ~ (bitwise exclusive-OR), >> (logical right shift), << (left shift), and the unary ~ (bitwise NOT)

assert(0xff & 0xabcd == 0xcd)
assert(0xff | 0xabcd == 0xabff)
assert(0xaaaa ~ -1 == 0xffffffffffff5555)
assert(-1 == (~0))
assert(-1 == 0xffffffffffffffff)
assert(-2 == 0xfffffffffffffffe)

--Both shift operators fill with zeros the vacant bits. This is usually called logical shifts. Lua does not offer
--an arithmetic right shift, which fills vacant bits with the signal bit. We can perform the equivalent to
--arithmetic shifts with a floor division by an appropriate power of two. (For instance, x // 16 is the
--same as an arithmetic shift by four.)

local x = 16
print(x / 4)

print(string.format("%x", 0xff << 12)) --> ff000
print(string.format("%x", 0xff >> -12)) --> ff000
print(string.format("%x", -1 << 80)) --> 0
print(string.format("%x", -1 << 64)) --> 0
print(string.format("%x", -1 << 63)) --> 8000000000000000

x = 13835058055282163712
print(x)  -- in current version, print 1.3835058055282e+19, but not -4611686018427387904
print(x * 2) -- not overflow 2.7670116110564e+19
--print(string.format("%u", x)) -- bad argument #2 to 'format' (number has no integer representation)
--print(string.format("0x%X", math.tointeger(x))) -- bad argument #2 to 'format' (number expected, got nil)
--print(string.format("0x%X", math.floor(x))) -- bad argument #2 to 'format' (number has no integer representation)

print(0x7fffffffffffffff < 0x8000000000000000) -- 0x8000000000000000 is negative.
print(math.ult(0x7fffffffffffffff, 0x8000000000000000)) -- math.ult (unsigned less than)

mask = 0x8000000000000000
print(string.format('%x', (0x7fffffffffffffff ~ mask)))

-- it is a bad example.
function udiv (n, d)
  if d < 0 then
    if math.ult(n, d) then return 0
    else return 1
    end
  end
  local q = ((n >> 1) // d) << 1
  local r = n - q * d
  if not math.ult(r, d) then q = q + 1 end
  return q
end

local function hex_dump (str)
  local len = string.len( str )
  local dump = ""
  local hex = ""
  local asc = ""

  for i = 1, len do
    if 1 == i % 8 then
      dump = dump .. hex .. asc .. "\n"
      hex = string.format( "%04x: ", i - 1 )
      asc = ""
    end

    local ord = string.byte( str, i )
    hex = hex .. string.format( "%02x ", ord )
    if ord >= 32 and ord <= 126 then
      asc = asc .. string.char( ord )
    else
      asc = asc .. "."
    end
  end

  return dump .. hex
  .. string.rep( "   ", 8 - len % 8 ) .. asc
end

print(udiv(-2, -2))
print(udiv(-2, -1))
print(udiv(-2, 1))
print(string.format('%x', ((-2 >> 1) // 1)<< 1 ) )

-- i integer, 4byte-size?
-- z option means a zero-terminated string
-- b one-byte size integer (native)
-- h short integer (native)
-- i interger (native)
-- l long (native)
-- j size of lua interger
-- suffix the i option with a number from one to 16, such as i7
-- Each integer option has an upper-case version corresponding to an unsigned integer of the same size

do
  local s = string.pack("iii", 3, -27, 450)
  local i1, i2, i3, offset = string.unpack("iii", s)
-- assert(size == 3) -- does has any size info
  assert(#s == 12)
  assert(i1 == 3)
  assert(i2 == -27)
  assert(i3 == 450)
  assert(offset == 13)
end

do
  -- lua size is 8 byte. (64-bit)
  local s = string.pack("jjj", 3, -27, 450)
  assert(#s == 24)
  --print(hex_dump(s))
  
  s = string.pack("i7i7i7", 3, -27, 450)
  assert(#s == 21)
  
  -- print(hex_dump(s))
end

do
--x = string.pack("i12", 2^61) -- yes, it is store the interger in 12-byte long space, but the real value is just 61-bit.so it can unpack.
--print(hex_dump(x))
--print(string.unpack("i12", x))

-- stdin:1: 12-byte integer does not fit into Lua Integer
-- x = "aaaaaaaaaaaa"
-- string.unpack("i12", x)

-- print(hex_dump(s))
end

do
  s = "\xFF"
  local s1 = string.unpack("b", s)  
  assert(s1 == -1)
  
  local s2 = string.unpack("B", s)
  assert(s2 == 255)
end

s = "hello\0Lua\0world\0"
local i = 1
local counter = 1
local t = { 'hello', 'Lua', 'world'}
while i <= #s do
  local res
  res, i = string.unpack("z", s, i)
  --print(i, #s, res)
  assert(t[counter] == res)
  counter = counter + 1
end

-- > s = "\xFF"
--> string.unpack("b", s)
--> string.unpack("B", s)
--> string.unpack("BT", s)  -- stdin:1: bad argument #2 to 'unpack' (data string too short)