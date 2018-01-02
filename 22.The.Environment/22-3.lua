--The configuration file has no way
--to affect anything else, even by mistake. Even malicious code cannot do much damage. It can do a denial
--of service (DoS) attack, by wasting CPU time and memory, but nothing else.

env = {}
loadfile("config.lua", "t", env)()

for _, v in pairs(env) do
  print(v)
end  


-- other options

f = load("b = 10; return a") -- change the upvalue
local env = { a = 20 }
debug.setupvalue(f, 1, env) -- set the upvalue of function f to env
print(f()) --> 20
print(env.b) --> 10

local config_lines = io.lines('config.lua', "*L")
print(config_lines())
print(config_lines())

--for k in (config_lines) do
--  print(k)
--end  