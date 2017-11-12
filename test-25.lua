--[[
It keeps all its state in
the dynamic structure lua_State; all functions inside Lua receive a pointer to
this structure as an argument. This implementation makes Lua reentrant and
ready to be used in multithreaded code.]]


