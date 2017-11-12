-- suspended, running, normal, and dead
co = coroutine.create(function () print("hi") end)
print(type(co)) --> thread

print(coroutine.status(co)) --> suspended

coroutine.resume(co) --> hi

print(coroutine.status(co)) --> dead

print("-------------------------------------------------------") --> dead

-- yield, which allows a running coroutine to suspend its own execution so that it can be resumed later

co = coroutine.create(function ()
    for i = 1, 10 do
        print("co", i)
        coroutine.yield()
    end
end)

coroutine.resume(co) --> co 1

print(coroutine.status(co)) --> suspended

-- just like a call to other function.

-- From the coroutine's point of view, all activity that happens while it is suspended is happening inside
-- its call to yield. When we resume the coroutine, this call to yield finally returns and the coroutine
-- continues its execution until the next yield or until its end

coroutine.resume(co) --> co 2
coroutine.resume(co) --> co 3
coroutine.resume(co) --> co 4
coroutine.resume(co) --> co 5
coroutine.resume(co) --> co 6
coroutine.resume(co) --> co 7
coroutine.resume(co) --> co 8
coroutine.resume(co) --> co 9
coroutine.resume(co) --> co 10
coroutine.resume(co) -- prints nothing
print(coroutine.resume(co)) -- prints nothing

print("-------------------------------------------------------")

-- protect mode !

-- Note that resume runs in protected mode, like pcall. Therefore, if there is any error inside a coroutine,
-- Lua will not show the error message, but instead will return it to the resume call.

-- 对resume来说，coroutine是不是也是一种闭包？有什么都会返回回来。

co = coroutine.create(function ()
    -- call a not exist function.
    foo()
end)

--> false   test-24-test.lua:53: attempt to call global 'foo' (a nil value)
print(coroutine.resume(co))

-- When a coroutine resumes another, it is not suspended; after all, we cannot resume it. However, it is not
-- running either, because the running coroutine is the other one. So, its own status is what we call the normal
-- state.

print("-------------------------------------------------------")

co = coroutine.create(function (a, b, c)
    print("co", a, b, c + 2)
end)
coroutine.resume(co, 1, 2, 3) --> co 1 2 5

print("-------------------------------------------------------")

co = coroutine.create(function (a,b)
    coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10)) --> true 30 10

print("-------------------------------------------------------")

co = coroutine.create (function (x)
    print("co1", x)
    print("co2", coroutine.yield())
    return "coroutine return"
end)
coroutine.resume(co, "hi") --> co1 hi --> careful, this no print.
print(coroutine.resume(co, 4, 5)) --> co2 4 5  --> the second resume is not pass parameter to coroutine,
-- but, the parameter to resume is pass as the return of the before yield.

-- the first return must the bool, indicate the return status of the cotoutine.

print("-------------------------------------------------------")

-- asymmetric coroutines -- semi-coroutines
-- symmetric coroutines

-- great!

-- 这种也不叫多线程，只是轮流执行，但还有这种限制。

-- Some people call asymmetric coroutines semi-coroutines. However, other people use the same term semi-
-- coroutine to denote a restricted implementation of coroutines, where a coroutine can suspend its execution
-- only when it is not calling any function, that is, when it has no pending calls in its control stack. In
-- other words, only the main body of such semi-coroutines can yield. (A generator in Python is an example
-- of this meaning of semi-coroutines.)

-- generators (as presented in Python)

-- something simple:
-- one product, one consume.

-- The problem here is how to match send with receive,
-- 一个发，另外一个才接收，像golang的chan一样

-- “who-has-the-main-loop”
-- 两个都是主动的循环结构，也可以改成被动的

function receive (prod)
    local status, value = coroutine.resume(prod)  -- resume other and wait the result
    return value
end
function send (x)
    coroutine.yield(x) -- yield control and return the value to the one which resume me
end
function producer ()
    return coroutine.create(function ()
        while true do
            local x = io.read() -- produce new value
            send(x)
        end
    end)
end
function filter (prod)
    return coroutine.create(function ()
        for line = 1, math.huge do
            local x = receive(prod) -- get new value
            x = string.format("%5d %s", line, x)
            send(x) -- send it to consumer
        end
    end)
end
local time = 1;
function consumer (prod)
    while true do
        local x = receive(prod) -- get new value
        io.write(x, "\n") -- consume new value
        time = time + 1
        if time == 3 then
            break;
        end
    end
end
consumer(filter(producer()))

-- After all, coroutines are a kind of (non-preemptive) multithreading
-- 只能等别人释放

-- 对比posix pipes
-- 性能的对比

print("-------------------------------------------------------")

-- the key feature is their ability to turn inside
-- out the relationship between caller and callee. With this feature, we can write iterators without worrying
-- about how to keep state between successive calls.

function permgen (a, n)
    n = n or #a -- default for 'n' is size of 'a'
    if n <= 1 then -- nothing to change?
        printResult(a)
    else
        for i = 1, n do
            -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]
            -- generate all permutations of the other elements
            permgen(a, n - 1)
            -- restore i-th element
            a[n], a[i] = a[i], a[n]
        end
    end
end

function printResult (a)
    for i = 1, #a do io.write(a[i], " ") end
    io.write("\n")
end
permgen ({1,2,3,4})