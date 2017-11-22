-- binary file

-- It cannot use the standard I/O streams (stdin/stdout), because these streams are open in text mode.
local inp = assert(io.open(arg[1], "rb"))
local out = assert(io.open(arg[2], "wb"))
local data = inp:read("a")
data = string.gsub(data, "\r\n", "\n")
out:write(data)
assert(out:close())
