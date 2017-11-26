-- The function load is powerful; we should use it with care. It is also an expensive function (when compared
-- to some alternatives) and can result in incomprehensible code. Before you use it, make sure that there is
-- no simpler way to solve the problem at hand
f = load("i = i + 1")

i = 0
f(); assert(i == 1)
f(); assert(i == 2)

load("assert(true)")()   -- () is must.

-- never raise errors
-- However, if there is any syntax error, load will return nil and the final error message will be something like
-- nil	[string "print a.abc"]:1: syntax error near 'a'
-- print(load('print a.abc'))

-- For clearer error messages, it is better to use assert
-- assert(load('print a.abc'))()

--However, the second line is much faster, because Lua compiles the function together with its enclosing
--chunk. In the first line, the call to load involves a separate compilation.
local x = os.clock()
f = load("i = i + 1")
f()
x = os.clock() - x
--print('elapse x', x)

-- after load (compile), the run time is close to local exe, like y.
z = os.clock()
f()
z = os.clock() - z
--print('elapse z', z)

y = os.clock()
f = function () i = i + 1 end
f()
y = os.clock() - y
--print('elapse y', y)

assert(x > y)

-- Because load does not compile with lexical scoping, the two lines in the previous example may not be
-- truly equivalent.
i = 32
local i = 0
f = load("i = i + 1; return i")
assert(f() == 33)
g = function () i = i + 1; return i end
assert(g() == 1)

-- The most typical use of load is to run external code (that is, pieces of code that come from outside our
-- program) or dynamically-generated code. For instance, we may want to plot a function defined by the user;
-- the user enters the function code and then we use load to evaluate it. Note that load expects a chunk,
-- that is, statements. If we want to evaluate an expression, we can prefix the expression with return, so that
-- we get a statement that returns the value of the given expression.
--print "enter your expression:"
--local line = io.read()
--local func = assert(load("return " .. line))
--print("the value of your expression is " .. func())

--print "enter function to be plotted (with variable 'x'):"
--local line = io.read()
--local f = assert(load("return " .. line))
--for i = 1, 20 do
--  x = i
---- global 'x' (to be visible from the chunk)
--  print(string.rep("*", f()))
--end 

-- f = load(io.lines(filename, "*L"))
-- f = load(io.lines(filename, 1024))

-- load("a = 1") return the equivalent of the following expression
-- function (...) a = 1 end

--print "enter function to be plotted (with variable 'x'):"
-- local line = io.read()
-- local f = assert(load("local x = ...; return " .. line))
local f = assert(load("local x = ...; return x"))
for i = 1, 20 do
  print(string.rep("*", f(i)))
end


-- In a production-quality program that needs to run external code, we should handle any errors reported
-- when loading a chunk. Moreover, we may want to run the new chunk in a protected environment, to avoid
-- unpleasant side effects. We will discuss environments in detail in Chapter 22, The Environment.

-- file 'foo.lua'
--function foo (x)
-- print(x)
--end

f = loadfile("foo.lua")
print(foo) --> nil
f() -- run the chunk
foo("ok") --> ok
