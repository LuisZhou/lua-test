local Set = {}
local mt = {} -- metatable for sets

-- create a new set with the values of a given list
function Set.new (l)
  local set = {}
  setmetatable(set, mt)
  for _, v in ipairs(l) do set[v] = true end
  return set
end
function Set.union (a, b)
--  if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
--    error("attempt to 'add' a set with a non-set value", 2)
--  end
  local res = Set.new{}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end
function Set.intersection (a, b)
  local res = Set.new{}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end
-- presents a set as a string
function Set.tostring (set)
  local l = {}
-- list to put all elements from the set
  for e in pairs(set) do
    l[#l + 1] = tostring(e)
  end
  return "{" .. table.concat(l, ", ") .. "}"
end

--subtraction (__sub)
--float division (__div)
--floor division (__idiv)
--negation (__unm)
--modulo (__mod)
--exponentiation (__pow)

--bitwise AND (__band), 
--OR (__bor), 
--exclusive OR (__bxor), 
--NOT (__bnot),
--left shift (__shl), 
--right shift (__shr)

--concatenation operator __concat

--__eq (equal to)
--__lt (less than)
--__le (less than or equal to)

--There are no separate metamethods for the other three relational operators
--Lua translates a ~= b to not (a == b), a > b to b < a, and a >= b to b <= a

mt.__add = Set.union
mt.__mul = Set.intersection

--In older versions, Lua translated all order operators to a single one, by translating a <= b to not (b
--< a). However, this translation is incorrect when we have a partial order, that is, when not all elements
--in our type are properly ordered. For instance, most machines do not have a total order for floating-point
--numbers, because of the value Not a Number (NaN). According to the IEEE 754 standard, NaN represents
--undefined values, such as the result of 0/0. The standard specifies that any comparison that involves NaN
--should result in false. This means that NaN <= x is always false, but x < NaN is also false. It also
--means that the translation from a <= b to not (b < a) is not valid in this case.

mt.__le = function (a, b)
  -- subset
  for k in pairs(a) do
    if not b[k] then return false end
  end
  return true
end

mt.__lt = function (a, b)
  -- proper subset
  return a <= b and not (b <= a)
end

mt.__eq = function (a, b)
--The equality comparison has some restrictions. If two objects have different basic types, the equality
--operation results in false, without even calling any metamethod. So, a set will always be different from a
--number, no matter what its metamethod says.
  return a <= b and b <= a
end

--If we set a __metatable field in the metatable, getmetatable will return the value of this field, whereas
--setmetatable will raise an error:
--mt.__metatable = "not your business"

return Set