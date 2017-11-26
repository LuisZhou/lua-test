--The function pcall calls its first argument in protected mode, so that it catches any errors while the
--function is running. The function pcall never raises any error, no matter what. If there are no errors,
--pcall returns true, plus any values returned by the call. Otherwise, it returns false, plus the error message.


--Despite its name, the error message does not have to be a string; a better name is error object, because
--pcall will return any Lua value that we pass to error
local ok, msg = pcall(function ()
    --some code
    if true then error("what's up?") end -- also can error(-1)
    --some code
    print(a[i])
    -- potential error: 'a' may not be a table
    --some code
  end)
if ok then
  -- no errors while running protected code
  --regular code
else
-- protected code raised an error: take appropriate action
  assert(msg == "error.Handling.and.Exceptions.lua:3: what's up?")
end

local ok, msg = pcall(function ()
    return 'ok'
  end)

if ok then  
  assert(msg == 'ok')
end

