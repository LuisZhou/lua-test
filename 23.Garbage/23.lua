-- dangling pointers and memory leaks

--The value of this field, when
--present, should be a string: if this string is "k", the keys in the table are weak; if this string is "v", the
--values in the table are weak; if this string is "kv", both keys and values are weak. The following example,
--although artificial, illustrates the basic behavior of weak tables

a = {}
mt = {__mode = "kv"}
setmetatable(a, mt)
-- now 'a' has weak keys
key = {} -- creates first key
a[key] = 1
key = {} -- creates second key
a[key] = 2

local key_num1 = 1 -- this will not garbaged. Of course, if the value corresponding to a numeric key is collected in a table
-- with weak values, then the whole entry is removed from the table.
a[key_num1] = {}

local key_num2 = {}-- this will be garbaged
a[key_num2] = 1

a[key_num1] = nil

key_num1 = nil
key_num2 = nil

local key_string1 = 'abc'
a[key_string1] = function() end  -- closure, something return by load or loadfile.

key_string1 = nil

collectgarbage() -- forces a garbage collection cycle
for k, v in pairs(a) do print(v) end --> 2

-- like a number or a Boolean, a string key is not removed from a weak table unless its associated
-- value is collected.

-- Memorize Functions : use the weak table to memorize.

-- Object Attributes

-- one table, one default value. we don't keep the default value in the origin table.


-- table dispear, the default dispear
local defaults = {}
setmetatable(defaults, {__mode = "k"}) -- if the key is garbage, the value will release.
local mt = {__index = function (t) return defaults[t] end}
function setDefault (t, d)
  defaults[t] = d
  setmetatable(t, mt)
end

-- default value here, the meta here.
local metas = {}
setmetatable(metas, {__mode = "v"})
function setDefault (t, d)
  local mt = metas[d]
  if mt == nil then
    mt = {__index = function () return d end}
    metas[d] = mt
-- memorize
  end
  setmetatable(t, mt)
end

-- Ephemeron Tables

print()

mt = {__gc = function (o) print(o[1]) end}

list = nil
for i = 1, 3 do
  list = setmetatable({i, link = list}, mt)
end
list = nil -- must: because 3 link to 2, 2 link to 1
collectgarbage()

-- io.read() -- try this.

A = {x = "this is A"}
B = {f = A, x = "this is B"}
setmetatable(B, {__gc = function (o) print(o.x) end})  -- this is a weak reference.
setmetatable(A, {__gc = function (o) print(o.x) end})
A, B = nil
collectgarbage() --> this is A -- once is just ok, first A, next B. 
--collectgarbage() --> this is A

--io.read() -- try this.


local t = {__gc = function ()
    -- your 'atexit' code comes here
    -- we can do some clean in here.
    print("finishing Lua program")
  end}
setmetatable(t, t)
-- All we have to do is to create a table with a finalizer and
-- anchor it somewhere, for instance in a global variable
_G["*AA*"] = t

-- io.read() -- try this.

do
  local mt = {__gc = function (o)
      -- whatever you want to do
      print("new cycle")
      -- creates new object for next cycle
      setmetatable({}, getmetatable(o))
    end}
  -- creates first object
  setmetatable({}, mt)
end
collectgarbage()--> new cycle
collectgarbage()--> new cycle
collectgarbage()--> new cycle