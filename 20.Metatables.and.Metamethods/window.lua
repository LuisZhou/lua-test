local obj = {}

-- create the prototype with default values
local prototype = {x = 0, y = 0, width = 100, height = 100}

local mt = {}

-- create a metatable
-- declare the constructor function
function obj.new (o)
  setmetatable(o, mt)
  return o
end

--mt.__index = function (_, key)
--  return prototype[key]
--end

mt.__index = prototype

--The use of a table as an __index metamethod provides a fast and simple way of implementing single
--inheritance. A function, although more expensive, provides more flexibility: we can implement multiple
--inheritance, caching, and several other variations. We will discuss these forms of inheritance in Chapter 21,
--Object-Oriented Programming, when we will cover object-oriented programming.

--When we want to access a table without invoking its __index metamethod, we use the function rawget.
--The call rawget(t, i) does a raw access to table t, that is, a primitive access without considering
--metatables. Doing a raw access will not speed up our code (the overhead of a function call kills any gain
--we could have), but sometimes we need it, as we will see later.

return obj