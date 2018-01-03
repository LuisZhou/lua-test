-- Non-Global Environments

-- free name is a name that is not bound to an explicit declaration, that is, 
-- it does not occur inside the scope of a corresponding local variable.

-- The Lua compiler translates any free name x in the chunk to _ENV.x

-- __Lua has no global variables__

--local z = 10
--x = y + z

--local z = 10
--_ENV.x = _ENV.y + z

-- __I already mentioned that Lua treats any chunk as an anonymous function.__

-- Lua compiles our original chunk as the following code:
--local _ENV = some value
--return function (...)
--local z = 10
--_ENV.x = _ENV.y + z
--end

-- Lua compiles any chunk in the presence of a predefined upvalue (an external local variable) called _ENV
-- So, any variable is either local, if it is a bounded name, or a field in _ENV, which itself is a local
-- variable (an upvalue).

-- summary: compile pack external to one local variable, named _ENV.

--The initial value for _ENV can be any table. (Actually, it does not need to be a table; more about that later.)
--Any such table is called an environment. To preserve the illusion of global variables, Lua keeps internally a
--table that it uses as a global environment. Usually, when we load a chunk, the function load initializes this
--predefined upvalue with that global environment. So, our original chunk becomes equivalent to this one:
--local _ENV = the global environment
--return function (...)
--  local z = 10
--  _ENV.x = _ENV.y + z
--end

for k, v in pairs(_ENV) do
  print(k, v) -- has one key to refer to _G, _G means _ENV._G
end

--print('\n')

--for k, v in pairs(_G) do
--  print(k, v)
--end

assert(_ENV == _G)

--• The compiler creates a local variable _ENV outside any chunk that it compiles.
--• The compiler translates any free name var to _ENV.var.
--• The function load (or loadfile) initializes the first upvalue of a chunk with the global environment,
--  which is a regular table kept internally by Lua.

-- Using _ENV

-- To run a piece of code as a single chunk, we can either run it from a file or enclose it in a do--end block.

do
--local print, sin = print, math.sin
--_ENV = nil
--print(13) --> 13
--print(sin(13)) --> 0.42016703682664
--print(math.cos(13)) -- error!
--A = 1 -- error!
end

do
  a = 13 -- global
  local a = 12
  print(a)  --> 12
  print(_ENV.a) --> 13
end

-- a = 1
--_G = nil
--print(_G.a)

--_ENV = {}
--a = 1
---- create a field in _ENV
--_G.print(a) -- still error

--a = 15 -- create a global variable
--_ENV = {g = _G} -- change current environment
--a = 1  -- create a field in _ENV 
--g.print(_ENV.a, g.a) --> 1 15

--a = 15  -- create a global variable
--_ENV = {_G = _G}  -- change current environment -- new table, only one key
--a = 1  -- create a field in _ENV
--_G.print(_ENV.a, _G.a) --> 1 15

-- we only can lost refer of global table, but the global table is always there.

do
  a = 1
  local newgt = {} -- create new environment
  setmetatable(newgt, {__index = _G})
  _ENV = newgt -- set it
  print(a) --> 1

  a = 10
  print(a, _G.a) --> 10, 1 -- because the new enviroment.
  _G.a = 20
  print(_G.a) --> 20

  _ENV = {_G = _G}
  local function foo ()
    _G.print(a) -- compiled as '_ENV._G.print(_ENV.a)'
  end
  a = 10
  foo() --> 10
  _ENV = {_G = _G, a = 20}
  foo() --> 20
end

_G.print('\n')

a = 2
do
  local _ENV = { print = _G.print, a = 14 }
  print(a) --> 14
end
_G.print(a) --> 2 (back to the original _ENV) -- oh, great!


function factory (_ENV)
  return function () return a end
end
f1 = factory{a = 6}
f2 = factory{a = 7}
_G.print(f1()) --> 6
_G.print(f2()) --> 7

-- Using the usual scoping rules, we can manipulate environments in several other ways. For instance, we
-- may have several functions sharing a common environment, or a function that changes the environment
-- that it shares with other functions.

-- Environments and Modules

-- example:
--local M = {}
--_ENV = M
--function add (c1, c2)   -- no need to add local now! Moreover, we can call other functions from the same module without any prefix.
--  return new(c1.r + c2.r, c1.i + c2.i)
--end

-- do some work can isolate the global enviroment.

