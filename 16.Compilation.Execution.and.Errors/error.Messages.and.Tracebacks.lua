function foo (str)
  if type(str) ~= "string" then
    error("string expected", 2) -- trace back level.
  end
  regular code
end

-- xpcall
-- debug.debug
-- debug.traceback

--Frequently, when an error happens, we want more debug information than only the location where the error
--occurred. At least, we want a traceback, showing the complete stack of calls leading to the error. When
--pcall returns its error message, it destroys part of the stack (the part that goes from it to the error point).
--Consequently, if we want a traceback, we must build it before pcall returns. To do this, Lua provides the
--function xpcall. It works like pcall, but its second argument is a message handler function. In case of
--error, Lua calls this message handler before the stack unwinds, so that it can use the debug library to gather
--any extra information it wants about the error. Two common message handlers are debug.debug, which
--gives us a Lua prompt so that we can inspect by ourselves what was going on when the error happened;
--and debug.traceback, which builds an extended error message with a traceback. The latter is the
--function that the stand-alone interpreter uses to build its error messages.