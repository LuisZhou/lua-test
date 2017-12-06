--We can also explicitly raise an error
--calling the function error, with an error message as an argument. Usually, this function is the appropriate
--way to signal errors in our code:

--print "enter a number:"
--n = io.read("n")
--if not n then error("invalid input") end

-- araise the error, not handle a error.

--print "enter a number:"
--n = assert(io.read("*n"), "invalid input")  -- second parameter.

--n = io.read()
--assert(tonumber(n), "invalid input: " .. n .. " is not a number")

--local file, msg
--repeat
--  print "enter a file name:"
--  local name = io.read()
--  if not name then return end
---- no input
--  file, msg = io.open(name, "r")
--  if not file then print(msg) end
--until file

--file = assert(io.open(name, "r")) --> stdin:1: no-file: No such file or directory

--When a function finds an unexpected situation (an exception), it can assume two basic behaviors: it can
--return an error code (typically nil or false) or it can raise an error, calling error. There are no fixed
--rules for choosing between these two options, but I use the following guideline: an exception that is easily
--avoided should raise an error; otherwise, it should return an error code.

-- These mechanisms provide all we need to do exception handling in Lua. We throw an exception with
-- error and catch it with pcall. The error message identifies the kind of error.

--local status, err = pcall(function () error({code=121}) end)
--print(err.code) --> 121

