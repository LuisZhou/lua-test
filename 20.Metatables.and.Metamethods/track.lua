local obj = {}

-- use the proxy concept.

-- Both __index and __newindex are relevant only when the index does not exist in the table.

function obj.track (t)
  -- If we want to monitor several tables, we do not need a different metatable for each one. Instead, we can
  -- somehow map each proxy to its original table and share a common metatable for all proxies.
  -- so just let it to local in this module.

  -- we can keep the original table in a proxy's field, using
  -- an exclusive key, or we can use a dual representation to map each proxy to its corresponding table.

  -- for instance: 
  -- proxy[t] = t

  local proxy = {}
  -- proxy table for 't'
  -- create metatable for the proxy
  local mt = {
    __index = function (_, k)
      print("*access to element " .. tostring(k))
      return t[k] -- access the original table      
    end,
    __newindex = function (_, k, v)
      print("*update of element " .. tostring(k) .. " to " .. tostring(v))
      t[k] = v  -- update original table      
    end,
    __pairs = function ()
      return function (_, k) -- iteration function        
        local nextkey, nextvalue = next(t, k)
        if nextkey ~= nil then
          -- avoid last value
          print("*traversing element " .. tostring(nextkey))
        end
        return nextkey, nextvalue
      end
    end,
    __len = function () return #t end
  }
  setmetatable(proxy, mt)
  return proxy
end

function obj.readOnly (t)
  local proxy = {}
  local mt = {
-- create metatable
    __index = t,
    __newindex = function (t, k, v)
      error("attempt to update a read-only table", 2)
    end
  }
  setmetatable(proxy, mt)
  return proxy
end

return obj