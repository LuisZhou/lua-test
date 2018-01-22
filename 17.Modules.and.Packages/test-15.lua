-- require is always require once.

-- package.loaded.<modname> = nil  can reset the loaded mod, can require can load mod again.

--[[ If require cannot find a Lua file with the module name, it searches for
a C library with the module name. If it finds a C library, it loads it with
package.loadlib (which we discussed in Section 8.3), looking for a function
called luaopen_modname.1 The loader in this case is the result of loadlib, that
is, the function luaopen_modname represented as a Lua function.
--]]

-- Renaming a module don't understand.

-- ?;?.lua;c:\windows\?;/usr/local/lua/?/?.lua

--[[
sql
sql.lua
c:\windows\sql
/usr/local/lua/sql/sql.lua
-- --]]

-- default path is presented ;;
-- ;; means package.path: When Lua starts, it initializes this variable with the
-- value of the environment variable
-- LUA_PATH_5_2 | LUA_PATH | compiled-defined default path -> package.path

-- package.cpath
-- LUA_CPATH_5_2 or LUA_CPATH
-- ./?.so;/usr/local/lib/lua/5.2/?.so
-- .\?.dll;C:\Program Files\Lua502\dll\?.dll

-- package.searchpath
--[[
--  Function package.searchpath encodes all those rules for searching libraries.
It receives a module name and a path, and looks for a file following the rules
described here. It returns either the name of the first file that exists or nil plus
an error message describing all files it unsuccessfully tried to open, as in the
next example:
> path = ".\\?.dll;C:\\Program Files\\Lua502\\dll\\?.dll"
> print(package.searchpath("X", path))
nil
no file '.\X.dll'
no file 'C:\Program Files\Lua502\dll\X.dll'
--
-- --]]

--[[
-- package.searchers
-- package.preload
-- search for lua
-- search for c
-- fourth function
-- --]]

-- package.preload to map module names to loaderfunctions

local M = {}
function M.new (r, i) return {r=r, i=i} end
-- defines constant 'i'
M.i = M.new(0, 1)
function M.add (c1, c2)
    return M.new(c1.r + c2.r, c1.i + c2.i)
end
function M.sub (c1, c2)
    return M.new(c1.r - c2.r, c1.i - c2.i)
end
function M.mul (c1, c2)
    return M.new(c1.r*c2.r - c1.i*c2.i, c1.r*c2.i + c1.i*c2.r)
end
local function inv (c)
    local n = c.r^2 + c.i^2
    return M.new(c.r/n, -c.i/n)
end
function M.div (c1, c2)
    return M.mul(c1, inv(c2))
end
function M.tostring (c)
    return "(" .. c.r .. "," .. c.i .. ")"
end
return M

--[[-
local M = {}
_ENV = M
function add (c1, c2)
return new(c1.r + c2.r, c1.i + c2.i)
end
-- -]]




--local function utf8_from(t)
--local bytearr = {}
--for _, v in ipairs(t) do
--local utf8byte = v < 0 and (0xff + v + 1) or v
--table.insert(bytearr, string.char(utf8byte))
--end
--return table.concat(bytearr)
--end


--for c in data['name']:gmatch("[\0-\x7F\xC2-\xF4][\x80-\xBF]*") do
--skynet.error(c:byte(1, -1))
--end
