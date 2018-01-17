-- background: if we use table as key or value of another table(say, index_table), these table will never release, if it is
-- referenced by 'index_table'

-- dangling pointers and memory leaks

--The value of this field, when
--present, should be a string: if this string is "k", the keys in the table are weak; if this string is "v", the
--values in the table are weak; if this string is "kv", both keys and values are weak. The following example,
--although artificial, illustrates the basic behavior of weak tables

function table.nums(t)
  local count = 0
  for k, v in pairs(t) do
    count = count + 1
  end
  return count
end

local a = {}
local mt = {__mode = "kv"}
setmetatable(a, mt)

do  
  -- now 'a' has weak keys
  local key = {} -- creates first key
  a[key] = 1
  key = {} -- creates second key, the before table is lost reference by key.
  a[key] = 2  
  collectgarbage()  
  assert(table.nums(a) == 1)
end

do
  -- like a number or a Boolean, a string key is not removed from a weak table unless its associated
  -- value is collected.
  
  -- 1
  -- this will not garbaged. Of course, if the value corresponding to a numeric key is collected in a table
  -- with weak values, then the whole entry is removed from the table.
  local key_num1 = 1 
  -- no else is refer to this table now beside the weak table.
  -- if you use a variate to refer to it, this will not realease too.
  -- like this:
  -- local key_val1 = {} 
  -- a[key_num1] = key_val1   
  a[key_num1] = {}   
  -- 2
  -- key_num1 = nil  -- 1 is garbaged. but the table now is not.
  --a[key_num1] = nil  
  local key_num2 = {}-- this will be garbaged
  a[key_num2] = 1
  key_num2 = nil
  -- 3
  local key_string1 = 'abc'
  a[key_string1] = function() end  -- closure, something return by load or loadfile.
  -- key_string1 = nil -- abc is garbaged. we don't need this, because below function is not refered by others.
  collectgarbage() -- forces a garbage collection cycle  
  assert(table.nums(a) == 0)
end


-- Memorize Functions : use the weak table to memorize.

-- Object Attributes

-- one table, one default value. we don't keep the default value in the origin table. why?
-- table dispear, the default dispear
local defaults = {}
setmetatable(defaults, {__mode = "k"}) -- map the table to value.
local mt = {__index = function (t) return defaults[t] end} -- careful, the second parameter is miss.
local function setDefault (t, d)
  defaults[t] = d 
  setmetatable(t, mt)
end

local t1 = {}
setDefault (t1, 123)
assert(t1[1] == 123)
assert(t1['1'] == 123)
assert(t1['1'] == t1[1])
t1 = nil
collectgarbage()
assert(table.nums(defaults) == 0)

-- default value here, the meta here.
local metas = {}
setmetatable(metas, {__mode = "v"})  -- map the default value to metatable, table is share the default value, share the meta too.
function setDefault (t, d)
  local mt = metas[d]
  if mt == nil then
    mt = {__index = function () return d end}
    metas[d] = mt -- memorize    
  end
  setmetatable(t, mt)
end

local t2 = {}
setDefault (t2, 124)
assert(t2[1] == 124)
assert(t2['1'] == 124)
assert(t2['1'] == t2[1])
t2 = nil -- t2 is only guy use the meta, so if it is released, meta release too.
-- add another.
local t3 = {}
setDefault (t3, 124) -- share the meta.
collectgarbage()
assert(table.nums(metas) == 1)

-- Ephemeron Tables

mt = {__gc = function (o) print(o[1]) end}
local list = nil
for i = 1, 3 do
  list = setmetatable({i, link = list}, mt)
end
-- 3 first release, then no one link to 2.
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

--local A = {x = "this is A"}
--local B = {f = A}
--setmetatable(B, {__gc = function (o) print(o.f.x) end})
--setmetatable(A, {__gc = function (o) print("I'm A") end})
--A, B = nil
--collectgarbage() --> A is first released.  

