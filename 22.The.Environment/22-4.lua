-- Remember that Lua compiles any chunk as a variadic function.

local function loadwithprefix(prefix, load_string) 
  return load(prefix .. load_string())   -- return a function.
end

local prefix = "_ENV = ...;" -- flexibility.
local filename = 'config.lua'

f = loadwithprefix(prefix, io.lines('22-5.lua', "*L"))  -- is a function.

env1 = {}
f({ a = 4, _G = _G } --[[ parameter for the function return by load ]] ) 
env2 = {}
f({ a = 5, _G = _G })
