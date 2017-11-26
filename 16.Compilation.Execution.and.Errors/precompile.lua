-- step 1
-- luac -o prog.lc prog.lua

-- lua prog.lc

-- minimal luac
p = loadfile(arg[1])       -- must be a lua source file?
f = io.open(arg[2], "wb")
f:write(string.dump(p))
f:close()

-- luac -l in this dir

-- a Web search for "lua opcode" should give you relevant material

-- precompile code load fast.

-- Besides its required first argument, load has three more arguments, all of them optional. The second is a
-- name for the chunk, used only in error messages. The fourth argument is an environment, which we will
-- discuss in Chapter 22, The Environment. The third argument is the one we are interested here; it controls
-- what kinds of chunks can be loaded. If present, this argument must be a string: the string "t" allows
-- only textual (normal) chunks; "b" allows only binary (precompiled) chunks; "bt", the default, allows
-- both formats