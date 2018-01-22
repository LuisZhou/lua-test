--[[
-- A coroutine is similar to a thread (in the sense of multithreading): it is a line
of execution, with its own stack, its own local variables, and its own instruction
pointer; but it shares global variables and mostly anything else with other
coroutines
-- ¼ÙÏß³Ì
--
 - The main difference between threads and coroutines is that, conceptually
(or literally, in a multiprocessor machine), a program with threads runs
several threads in parallel. Coroutines, on the other hand, are collaborative:
at any given time, a program with coroutines is running only one of its coroutines,
and this running coroutine suspends its execution only when it explicitly
requests to be suspended.-
-- --]]

-- 9.1 Coroutine Basics
co = coroutine.create(function () print("hi") end)
print(co) --> thread: 0x8071d98
print(coroutine.status(co)) --> suspended  -- oh!
-- suspended, running, dead, and normal.
coroutine.resume(co) --> hi
print(coroutine.status(co)) --> dead

co = coroutine.create(function ()
    for i = 1, 10 do
        print("co", i)
        coroutine.yield()
    end
end)
coroutine.resume(co) --> co 1
print(coroutine.status(co)) --> suspended
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
coroutine.resume(co) --> co 1
print(coroutine.status(co)) --> dead
print(coroutine.resume(co)) --> false   cannot resume dead coroutine

-- Note that resume runs in protected mode. Therefore, if there is any error inside
-- a coroutine, Lua will not show the error message, but instead will return it to
-- the resume call