--Lua handles binary data similarly to text. A string in Lua can contain any bytes, and almost all library
--functions that handle strings can handle arbitrary bytes. We can even do pattern matching on binary data.
--On top of that, Lua 5.3 introduced extra facilities to manipulate binary data: besides integer numbers, it
--brought bitwise operators and functions to pack and unpack binary data. In this chapter, we will cover
--these and other facilities for handling binary data in Lua.

-- & |  ~ (bitwise exclusive-OR), >> (logical right shift), << (left shift), and the unary ~ (bitwise NOT)

local str = string.format("%x", 0xff & 0xabcd) --> cd
print(str)

str = string.format("%x", 0xff | 0xabcd) --> abff
print(str)

str = string.format("%x", 0xaaaa ~ -1) --> ffffffffffff5555
print(str)

str = string.format("%x", ~0) --> ffffffffffffffff
print(str)

-- 64 bits
-- why ffffffffffffffff?
str = string.format("%x", -1) --> ffffffffffffffff
print(str)

str = string.format("%x", -2) --> ffffffffffffffff
print(str)

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