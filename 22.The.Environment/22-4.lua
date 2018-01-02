-- Remember that Lua compiles any chunk as a variadic function.

local function loadwithprefix(prefix, load_string) 
  return load(prefix .. load_string())
end

local prefix = "_ENV = ...;"
local filename = 'config.lua'

f = loadwithprefix(prefix, io.lines('22-5.lua', "*L"))
--...
env1 = {}
f({ a = 4, _G = _G })
env2 = {}
f({ a = 5, _G = _G })
