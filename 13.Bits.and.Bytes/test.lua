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

-- interget option
-- i integer, 4byte-size?
-- b one-byte size integer (native)
-- h short integer (native)
-- i interger (native)
-- l long (native)
-- j size of lua interger
-- suffix the i option with a number from one to 16, such as i7
-- Each integer option has an upper-case version corresponding to an unsigned integer of the same size
-- Moreover, unsigned integers have an extra option T for size_t. (The size_t type in ISO C is an unsigned integer larger enough to hold the size of any object.)

-- string option
-- z:   zero-terminated string, when pack, it will add zero after the string. when unpack, it will find the zero as the delimiter.
-- cn:  fixed-length strings, where n is the number of bytes in the packed string
-- sn:  strings with explicit length, where n is the size of the unsigned integer used to store the length, the length is in the string. 
--      (Lua raises an error if the length does not fit into the given size.)

-- s: Lua raises an error if the length does not fit into the given size. We can also use a pure ___s___ as the option;
-- in that case, the length is stored as a size_t, which is large enough to hold __the length__ of any string.
-- (In 64-bit machines, size_t usually is an eight-byte unsigned integer, which may be a waste of space
-- for small strings.)

-- endian > < =
-- !n align
-- x means one byte of padding

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

-- any size is just 64-bit
--s = string.pack("TTT", 3, -27, 450)
--print(hex_dump(s))

-- (string longer than given size)
--s = string.pack("c1", 'hello world')
-- 12 is one size longer than the origin.
s = string.pack("c12", 'hello world')
print(hex_dump(s))


s = string.pack("s1", 'hello world')
print(hex_dump(s))

-- bug of dump, add zero as padding.
s = string.pack("z", 'hello world 123')
print(hex_dump(s))

-- bad argument #2 to 'pack' (string longer than given size)
--s = string.pack("c5", 'hello world 123')
--print(hex_dump(s))

-- padding zero if size of parameter is larger than the length of string.
s = string.pack("c12", 'hello world')
print(hex_dump(s))


-- > s = "\xFF"
--> string.unpack("b", s)
--> string.unpack("B", s)
--> string.unpack("BT", s)  -- stdin:1: bad argument #2 to 'unpack' (data string too short)

-- another kink of dump
--s = string.pack("s1", "hello")
--for i = 1, #s do print((string.unpack("B", s, i))) end

s = string.pack(">i4", 0x12345)
print(hex_dump(s))

s = string.pack("<i2>i2", 0xf4, 0x18)
print(hex_dump(s))

s = string.pack("!4i2i2", 0xf4, 0x18)
print(hex_dump(s))

-- index multi of 4
s = string.pack("!4i8i8", 0xf4, 0x18)
print(hex_dump(s))

-- why the size is 23: the last one is not padding zero to size 8, because there is no require
-- Alignment only works for powers of two: if we set the alignment to four and try to manipulate a three-
-- byte integer, Lua will raise an error.
s = string.pack("!4i7i7i7", 0xf4, 0x18, 0x12)
print(hex_dump(s))
print(#s)

print('align')


for i = 1, 1 do 
  print(string.unpack("!4i7i7i7", s, i)) 
end

-- always error result!, don't support single unpack.
for i = 1, 3 do 
  print(string.unpack("!4i7", s, i)) 
end

s = string.pack("!4i8i8i8", 0xf4, 0x18, 0x12)
print(hex_dump(s))

s = string.pack("i8i8i8", 0xf4, 0x18, 0x12)

print(string.unpack("i8i8i8",s)) -- this ok.
for i = 1, 3 do print(string.unpack("<i8", s, i)) end -- this not ok.

-- well, support only banlance parameter string of pack and unpack?

--for i = 1, #s do print((string.unpack("B", s, i))) end

s = string.pack("i8i8i8xxx", 0xf4, 0x18, 0x12)
print(hex_dump(s))

-- binary file
