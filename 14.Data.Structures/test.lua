-- Array

local a = {}
for i = -5, 5 do
  a[i] = 0
end

assert( #a == 5 )

-- try: data-description files with constructors with a few million elements

-- Matrices and Multi-Dimensional Arrays

-- jagged arrays

local M = 2
local N = 2

local mt = {}
for i = 1, N do
  local row = {}
  mt[i] = row
  for j = 1, M do   -- each may have differece size.
    row[j] = 0
  end
end

-- flatten it.

local mt = {}
-- create the matrix
for i = 1, N do
  local aux = (i - 1) * M
  for j = 1, M do
    mt[aux + j] = 0
  end
end

-- we need space only for the non-nil elements

local a = { 
  {2, 1},
  {5, 2},
}
local  b = { 
  {1, 4},
  {3, 6},
}

-- great!
-- https://www.khanacademy.org/math/precalculus/precalc-matrices/multiplying-matrices-by-matrices/a/multiplying-matrices
-- the algorithm is: the k column of is always multi with all the element of row k of b. the result index is decided by 
-- a row index and b column index.
function mult (a, b)
  local c = {}
  -- resulting matrix
  for i = 1, #a do
    local resultline = {}
    -- will be 'c[i]'
    for k, va in pairs(a[i]) do -- 'va' is a[i][k]
      for j, vb in pairs(b[k]) do -- 'vb' is b[k][j]

        print(i, k, j, va, vb)

        local res = (resultline[j] or 0) + va * vb
        resultline[j] = (res ~= 0) and res or nil       

      end
    end
    c[i] = resultline

    for k, v in pairs(resultline) do
      print(k, v)
    end  
  end
  return c
end

local c = mult(a, b)
print(c[1][1], c[1][2])
print(c[2][1], c[2][2])

-- Linked Lists

local list = nil
list = {next = list, value = v}
local l = list
while l do
  -- l.value
  l = l.next
end

-- Queues and Double-Ended Queues

-- great!

-- take advantage of the negative position,
-- even in positive-index array can simulate this.

function listNew ()
  return {first = 0, last = -1}
end
function pushFirst (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end
function pushLast (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end
function popFirst (list)
  local first = list.first
  if first > list.last then error("list is empty") end -- good.
  local value = list[first]
  list[first] = nil
  -- to allow garbage collection
  list.first = first + 1
  return value
end
function popLast (list)
  local last = list.last
  if list.first > last then error("list is empty") end
  local value = list[last]
  list[last] = nil
-- to allow garbage collection
  list.last = last - 1
  return value
end