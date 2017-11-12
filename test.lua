--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/9/4
-- Time: 22:38
-- To change this template use File | Settings | File Templates.
--

-- test 1
print("Hello World")

-- test 2
-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n-1)
    end
end
print("enter a number:")
a = io.read("*n") -- reads a number
print(fact(a))

-- Each piece of code that Lua executes, such as a file or a single line in interactive
-- mode, is called a chunk. A chunk is simply a sequence of commands (or
-- statements).

-- in interactive mode
-- ctrl-D in UNIX, ctrl-Z in Windows
-- or os.exit()

-- You can use the -i option to instruct Lua to start an interactive session after
-- running the given chunk:
-- % lua -i prog

function norm (x, y)
    return (x^2 + y^2)^0.5
end

function twice (x)
    return 2*x
end

-- suck as load a lib.
-- > dofile("lib1.lua") -- load your library
-- > n = norm(3.4, 1.0)
-- > print(twice(n)) --> 7.0880180586677

-- reload:
-- After
-- saving a modification in your program, you execute dofile("prog.lua") in the
-- Lua console to load the new code; then you can exercise the new code, calling its
-- functions and printing the results.

-- 1.2 Some Lexical Conventions
-- variate name is like c.

-- You should avoid identifiers starting with an underscore followed by one or more
-- upper-case letters (e.g., _VERSION); they are reserved for special uses in Lua.
-- Usually, I reserve the identifier _ (a single underscore) for dummy variables.

-- letter is only a-z A-Z

-- case-sensitive

--[[
print(10) -- no action (commented out)
--]]

-- 1.3 Global Variables

-- Global variables do not need declarations; you simply use them. It is not an
-- error to access a non-initialized variable; you just get the value nil as the result:

-- try：
--[[
print(b) --> nil
b = 10
print(b) --> 10
If you assign nil to a global variable, Lua behaves as if the variable had never
been used:
b = nil
print(b) --> nil
After this assignment, Lua can eventually reclaim the memory used by the
variable
--]]

-- wait, here is use by script of unix-like system.
#!/usr/local/bin/lua
#!/usr/bin/env lua

-- % lua -e "print(math.sin(12))" --> -0.53657291800043
-- In interactive mode, you can print the value of any expression by writing a
-- line that starts with an equal sign followed by the expression

-- The -l option loads a library. As we saw previously, -i enters interactive
-- mode after running the other arguments. Therefore, the next call will load the
-- lib library, then execute the assignment x=10, and finally present a prompt for
-- interaction.
-- % lua -i -llib -e "x = 10"

--[[
Before running its arguments, the interpreter looks for an environment variable
named LUA_INIT_5_2 or else, if there is no such variable, LUA_INIT. If there
is one of these variables and its content is @filename, then the interpreter runs
the given file. If LUA_INIT_5_2 (or LUA_INIT) is defined but it does not start
with ‘@’, then the interpreter assumes that it contains Lua code and runs it.
LUA_INIT gives us great power when configuring the stand-alone interpreter,
because we have the full power of Lua in the configuration. We can preload
packages, change the path, define our own functions, rename or delete functions,
and so on.
--]]

-- % lua -e "sin=math.sin" script a b
--[[
arg[-3] = "lua"
arg[-2] = "-e"
arg[-1] = "sin=math.sin"
arg[0] = "script"
arg[1] = "a"
arg[2] = "b"

Since Lua 5.1, a script can also retrieve its arguments through a vararg expression.
In the main body of a script, the expression ... (three dots) results in
the arguments to the script. (We will discuss vararg expressions in Section 5.2.)

--]]
