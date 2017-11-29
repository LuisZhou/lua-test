

local m1 = require('m')
m1.counter = 10
local m2 = require('m')
m2.counter = 11
-- means the same lua instance, require is import the unique module.
assert(m1.counter == 11)

--From the point of view of the user, a module is some code (either in Lua or in C) that can be loaded through
--the function require and that creates and returns a table. Everything that the module exports, such as
--functions and constants, it defines inside this table, which works as a kind of namespace.
-- example, m1 is a table, like a namespace.

-- import only a specific function
-- local f = require "mod".foo -- (require("mod")).foo

-- __The Function require__

-- great!

-- Despite its central role in the implementation of modules in Lua, require is a regular function, with
-- no special privileges.

-- some modules may choose to return other values or even to have side effects (e.g.,
-- by creating global variables

-- The first step of require is to check in the table package.loaded whether the module is already
-- loaded. If so, require returns its corresponding value. Therefore, once a module is loaded, other calls
-- requiring the same module simply return the same value, without running any code again.

-- the require use loadfile internal for lua file. The result is a function that we call a loader. (The loader is a function that, when
-- called, loads the module.)

-- use package.loadlib for c file, looking for a function called luaopen_modname. The
-- __loader__ in this case is the result of loadlib, which is the C function luaopen_modname represented
-- as a Lua function.

-- loader is a function.

--No matter whether the module was found in a Lua file or a C library, require now has a loader for
--it. To finally load the module, require calls the loader with two arguments: the module name and
--the name of the file where it got the loader.

-- To force require into loading the same module twice, we can erase the library entry from package.loaded
-- package.loaded.modname = nil

-- explicit function to set parameter
--local mod = require "mod"
--mod.init(0, 0)

-- init can return itself.

-- __Renaming a module__

--To allow for such renamings, require uses a small trick: if the module
--name contains a hyphen, require strips from the name its suffix after the hyphen when creating the
--luaopen_* function name. For instance, if a module is named mod-v3.4, require expects its open
--function to be named luaopen_mod, instead of luaopen_mod-v3.4 (which would not be a valid
--C name anyway). So, if we need to use two modules (or two versions of the same module) named mod,
--we can rename one of them to mod-v1, for instance. When we call m1 = require "mod-v1",
--require will find the renamed file mod-v1 and, inside this file, the function with the original name
--luaopen_mod.


-- __Path searching__

--ISO C (the abstract platform
--where Lua runs) does not have the concept of directories. Therefore, the path used by require is a list
--of templates, each of them specifying an alternative way to transform a module name (the argument to
--require) into a file name.

--For each template, require substitutes the module name for each question mark and
--checks whether there is a file with the resulting name; if not, it goes to the next template. The templates
--in a path are separated by semicolons, a character seldom used for file names in most operating systems.

-- ?;?.lua;c:\windows\?;/usr/local/lua/?/?.lua

-- package.path

--The path that require uses to search for Lua files is always the current value of the variable
--package.path. When the module package is initialized, it sets this variable with the value of the en-
--vironment variable LUA_PATH_5_3; if this environment variable is undefined, Lua tries the environment
--variable LUA_PATH. If both are unefined, Lua uses a compiled-defined default path. 2 When using the
--value of an environment variable, Lua substitutes the default path for any substring ";;". For instance, if
--we set LUA_PATH_5_3 to "mydir/?.lua;;", the final path will be the template "mydir/?.lua"
--followed by the default path.

print(package.path)
print(LUA_PATH_5_3) -- normal is nil
print(LUA_PATH)     -- normal is nil

-- no useful set here !
-- ;; means default path.
--LUA_PATH_5_3 = "mydir/?.lua;;"
-- print(package.path)

-- this variable gets its initial value from the
-- environment variables LUA_CPATH_5_3 or LUA_CPATH
-- package.cpath
print(package.cpath)

print(package.searchpath("17", package.path))

function search (modname, path)
  modname = string.gsub(modname, "%.", "/") -- substitute the directory separator
  local msg = {}
  for c in string.gmatch(path, "[^;]+") do
    local fname = string.gsub(c, "?", modname)
    local f = io.open(fname)
    if f then
      f:close()
      return fname
    else
      msg[#msg + 1] = string.format("\n\tno file '%s'", fname);
    end
  end
  return nil, table.concat(msg)
  -- not found
end

-- __Searchers__

-- A searcher is simply a
-- function that takes the module name and returns either a loader for that module or nil if it cannot find one.

-- a way to simple it.

-- print(package.searchers)

--The array package.searchers lists the searchers that require uses. When looking for a module,
--require calls each searcher in the list passing the module name, until one of them finds a loader for the
--module. If the list ends without a positive response, require raises an error.

-- both search lua and c 

for k, v in pairs(package.searchers) do
  print(k, v)
end  

-- greate!!!!

--The use of a list to drive the search for a module allows great flexibility to require. For instance, if we
--want to store modules compressed in zip files, we only need to provide a proper searcher function for that
--and add it to the list. In its default configuration, the searcher for Lua files and the searcher for C libraries
--that we described earlier are respectively the second and the third elements in the list. Before them, there
--is the preload searcher.

-- great!!!
--The preload searcher allows the definition of an arbitrary function to load a module. It uses a table, called
--package.preload, to map module names to loader functions. When searching for a module name, this
--searcher simply looks for the given name in the table. If it finds a function there, it returns this function
--as the module loader. Otherwise, it returns nil. This searcher provides a generic method to handle some
--non-conventional situations. For instance, a C library statically linked to Lua can register its luaopen_
--function into the preload table, so that it will be called only when (and if) the user requires that module.
--In this way, the program does not waste resources opening the module if it is not used.

-- anther way to define the module
local M = {}
--Remember that require calls the loader passing the module name as the first argument. So, the vararg
--expression ... in the table index results in that name. After this assignment, we do not need to return M
--at the end of the module: if a module does not return a value, require will return the current value of
--package.loaded[modname] (if it is not nil). Anyway, I find it clearer to write the final return. If we
--forget it, any trivial test with the module will detect the error.
--package.loaded[...] = M
package.loaded['ms'] = M

for k, v in pairs(package.loaded) do
  print(k, v)
end

-- __Submodules and Packages__
-- like m.subm 

--Lua allows module names to be hierarchical, using a dot to separate name levels. For instance, a module
--named mod.sub is a submodule of mod. A package is a complete tree of modules; it is the unit of dis-
--tribution in Lua.

--When we require a module called mod.sub, the function require will query first the ta-
--ble package.loaded and then the table package.preload, using the original module name
--"mod.sub" as the key. Here, the dot is just a character like any other in the module name.

--However, when searching for a file that defines that submodule, require translates the dot into another
--character, usually the system's directory separator (e.g., a slash for POSIX or a backslash for Windows).
--After the translation, require searches for the resulting name like any other name. For instance, assume
--the slash as the directory separator and the following path:


--The directory separator used by Lua is configured at compile time and can be any string (remember,
--Lua knows nothing about directories). For instance, systems without hierarchical directories can use an
--underscore as the “directory separator”, so that require "a.b" will search for a file a_b.lua.

--Names in C cannot contain dots, so a C library for submodule a.b cannot export a function
--luaopen_a.b. Here, require translates the dot into another character, an underscore. So, a C library
--named a.b should name its initialization function luaopen_a_b

--As an extra facility, require has one more searcher for loading C submodules. When it cannot find either
--a Lua file or a C file for a submodule, this last searcher searches again the C path, but this time looking
--for the package name. For example, if the program requires a submodule a.b.c this searcher will look
--for a. If it finds a C library for this name, then require looks into this library for an appropriate open
--function, luaopen_a_b_c in this example. This facility allows a distribution to put several submodules
--together, each with its own open function, into a single C library.
