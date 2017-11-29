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