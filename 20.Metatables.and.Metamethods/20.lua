-- predefine the operation.

--Whenever Lua tries to add two tables, it checks whether either of them has a 
--metatable and whether this metatable has an __add  field. If Lua finds this field, 
--it calls the corresponding value —the so-called metamethod , which should be a 
--function to compute the sum.

--Like classes, metatables define the behavior of its instances.

--However, metatables are more restricted than classes,
--because they can only give behavior to a predefined set of operations; also, metatables do not have in-
--heritance.

--Tables and userdata have individual metatables; values of other types share one single metatable 
--for all values of that type.

local t = 1
print(getmetatable(t))

--From Lua, we can set the metatables only of tables; to manipulate the metatables of values of other types we
--must use C code or the debug library.
--bad argument #1 to 'setmetatable' (table expected, got number)
--t1 = {}
--setmetatable(t, t1) 
--print(getmetatable(t) == t1) --> true

print(getmetatable("hi"))
print(getmetatable("world"))
assert(getmetatable("hi") == getmetatable("world")) -- oh, this work.

local Set = require("set")

-- Arithmetic Metamethods
local s1 = Set.new{10, 20, 30, 50}
local s2 = Set.new{30, 1}
print(getmetatable(s1))
print(getmetatable(s2))

local s3 = s1 + s2
print(Set.tostring(s3)) --> {1, 10, 20, 30, 50}

s3 = s1 + s2
print(Set.tostring((s1 + {30, 1})*s1))
print(Set.tostring(({30, 1} + s1)*s1))

s1 = Set.new{2, 4}
s2 = Set.new{4, 10, 2}
print(s1 <= s2)
--> true
print(s1 < s2)
--> true
print(s1 >= s1)
--> true
print(s1 > s1)
--> false
print(s1 == s2 * s1) --> true

--So, it is a common practice for libraries to
--define and use their own fields in metatables
s1 = Set.new{}
print(getmetatable(s1)) --> not your business
setmetatable(s1, {})

local track = require"track"

t = {}
-- an arbitrary table
t = track.track(t)
t[2] = "hello" --> *update of element 2 to hello
print(t[2])

t = track.track({10, 20})
print(#t) --> 2
for k, v in pairs(t) do print(k, v) end
--> *traversing element 1
--> 1 10
--> *traversing element 2
--> 2 20

days = track.readOnly{"Sunday", "Monday", "Tuesday", "Wednesday",
"Thursday", "Friday", "Saturday"}
print(days[1])
--> Sunday
local status, message = pcall(function() 
    days[2] = "Noday" 
  end) 

print(status, message)