-- array, set, record, package, object.
-- what is associative array. all kind of value can be the index of the array.
-- tables are objects.

--[[
Note the last line: like global variables, table fields evaluate to nil when not initialized. Also like global
variables, we can assign nil to a table field to delete it. This is not a coincidence: Lua stores global variables
in ordinary tables]]

-- a.name as syntactic sugar for a["name"]

--[[
More specifically, when used as a key, any float value that can be converted to an integer is converted.
For instance, when Lua executes a[2.0] = 10, it converts the key 2.0 to 2. Float values that cannot
be converted to integers remain unaltered.]]

days = {"Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday"}  -- is faster, because Lua creates the table already with the right size.

a = {x = 10, y = 20 }

w = {x = 0, y = 0, label = "console"}
x = {math.sin(0), math.sin(1), math.sin(2)}
w[1] = "another field" -- add key 1 to table 'w'
x.f = w -- add key "f" to table 'x'
print(w["x"]) --> 0
print(w[1]) --> another field
print(x.f[1]) --> another field
w.x = nil -- remove field "x"

polyline = {color="blue",
    thickness=2,
    npoints=4,
    {x=0, y=0}, -- polyline[1]
    {x=-10, y=0}, -- polyline[2]
    {x=-10, y=1}, -- polyline[3]
    {x=0, y=1} -- polyline[4]
}

opnames = {["+"] = "add", ["-"] = "sub",
    ["*"] = "mul", ["/"] = "div" }

i = 20; s = "-"
a = {[i+0] = s, [i+1] = s..s, [i+2] = s..s..s}
print(opnames[s]) --> sub
print(a[22]) --> ---

--[[> a = {}
> a[1] = 1
        > a[2] = nil
        > a[3] = 1
        > a[4] = 1
        > print(#a)
4
> a[1000] = 1
        > print(#a)
4
> ]]

t = {10, print, x = 12, k = "hi"}
for k, v in pairs(t) do
    print(k, v)
end
--> 1 10
--> k hi
--> 2 function: 0x420610
--> x 12

t = {10, print, 12, "hi"}
for k = 1, #t do
    print(k, t[k])
end
--> 1 10
--> 2 function: 0x420610
--> 3 12
--> 4 hi

-- table.insert inserts an element in a given position of a sequence£¬ moving up other
-- elements to open space

--t = {}
--for line in io.lines() do
--    table.insert(t, line)
--end
--print(#t) --> (number of lines read)

-- The function table.remove removes and returns an element from the given position in a sequence,
-- moving subsequent elements down to fill the gap. When called without a position, it removes the last
-- element of the sequence.

--[[With these two functions, it is straightforward to implement stacks, queues, and double queues. We can
initialize such structures as t = {}. A push operation is equivalent to table.insert(t, x); a pop
operation is equivalent to table.remove(t). The call table.insert(t, 1, x) inserts at the
other end of the structure (its beginning, actually), and table.remove(t, 1) removes from this end.
The last two operations are not particularly efficient, as they must move elements up and down. However,
because the table library implements these functions in C, these loops are not too expensive, so that this
implementation is good enough for small arrays (up to a few hundred elements, say).]]

print(table.concat({1, 2, 3}, ','))

--table.move(a, 1, #a, 2)
--a[1] = newElement
--for k, v in pairs(t) do
--    print(k, v)
--end

-- no table move now!
