--An iterator is any construction that allows us to iterate over the elements of a collection. In Lua, we
--typically represent iterators by functions: each time we call the function, it returns the “next” element from
--the collection.


local function values (t)
  local i = 0
  return function () 
    i = i + 1; 
    return t[i]
  end
end

t = {10, 20, 30}
for element in values(t) do
  print(element)
end

print('')

t = {10, 20, 30}
iter = values(t)
-- creates the iterator
while true do
  local element = iter()
  -- calls the iterator
  if element == nil then break end
  print(element)
end

-- good.
function allwords ()  
  local line = io.read() -- current line
  local pos = 1
  -- current position in the line
  return function ()
    -- iterator function
    while line do
      -- repeat while there are lines
      local w, e = string.match(line, "(%w+)()", pos)
      if w then
        -- found a word?
        pos = e
        -- next position is after this word
        return w
        -- return the word
      else
        line = io.read() -- word not found; try next line
        pos = 1
        -- restart from first position
      end
    end
    return nil
    -- no more lines: end of traversal
  end
end

--for word in allwords() do
--  print(word)
--end

-- __The Semantics of the Generic for__

print(pairs({1,2,3}))

local _, t, _ = pairs({4,5,6})

--for k,v in pairs(t) do
--  print(k, v) -- t is just  {4,5,6}
--end  

do
  local test = {4,5,6}
  local _f, _s, _var = pairs(test)  -- return ther iterator, invariant state and the control variable
  
  --print(test)
  
--  for k, v in pairs(_s) do 
--    print('test', k, v)
--  end
  
  while true do
    local var_1, var_2 , var_n = _f(_s, _var) -- the invariant state and the control variable
    _var = var_1  -- turn to this guy.
    if _var == nil then break end
    print('code block ', _s, _var, var_2, var_n)
  end
end

--We call the first (or only) variable in the list the control variable. Its value is never nil during the loop,
--because when it becomes nil the loop ends.

-- Stateless Iterators

--a = {"one", "two", "three"}
--for i, v in ipairs(a) do
--  print(i, v)
--end

--a = {"one", "two", "three"}
--for i, v in pairs(a) do
--  print(i, v)
--end

