-- Lua has no clear concept of a program, having instead
-- pieces of code (chunks) called by the host application

-- for n in pairs(_G) do print(n) end

-- Global Variables with Dynamic Names
-- this code involves the creation and compilation of a new chunk, which is somewhat expensive
-- value = load("return " .. varname)()

-- value = _G[varname]

function getfield (f)
  local v = _G
  -- start with the table of globals
  for w in string.gmatch(f, "[%a_][%w_]*") do
    v = v[w]
  end
  return v
end

function setfield (f, v)
  local t = _G
  -- start with the table of globals
  for w, d in string.gmatch(f, "([%a_][%w_]*)(%.?)") do
    if d == "." then
      -- not last name?
      t[w] = t[w] or {}
      -- create table if absent
      t = t[w]
      -- get the table
    else
      -- last name
      t[w] = v
      -- do the assignment
    end
  end
end

local all_field = getfield("io.read")
assert(all_field == io.read)

a = 123
b = 'a'
assert(_G[b] == a)

setfield("t.x.y", 10)
print(t.x.y) --> 10
print(getfield("t.x.y")) --> 10

-- Global-Variable Declarations

-- must before the next statement, or this will not ok too.
-- because this declare a global function.
function declare (name, initval)
  rawset(_G, name, initval or false)
end

--function try_to_write_global_in_function()
--  x = 1
--end  

setmetatable(_G, {
    __newindex = function (_, n)
      local w = debug.getinfo(2, "S").what
      if w ~= "main" and w ~= "C" then
        error("attempt to write to undeclared variable " .. n, 2)
      end
      --error("attempt to write to undeclared variable " .. n, 2)
      rawset(t, n, v)
    end,
    __index = function (_, n)
      error("attempt to read undeclared variable " .. n, 2)
    end,
  })

-- print(z)
-- _G['z'] = 1

declare('z', 1)
z = 123
local y = 123

-- try_to_write_global_in_function()


if rawget(_G, 'x') == nil then
  print('x is nil')
-- 'var' is undeclared
--...
end