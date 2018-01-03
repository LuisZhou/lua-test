-- tables have an identity (a self) that is independent of their values

local account = {balance = 0}
function account.withdraw (v)
  account.balance = account.balance - v
end

--the use of the global name Account
--inside the function is a horrible programming practice. First, this function will work only for this particular
--object. Second, even for this particular object, the function will work only as long as the object is stored
--in that particular global variable. If we change the object's name, withdraw does not work any more:
--a, Account = Account, nil
--a.withdraw(100.00) -- ERROR!

-- Such behavior violates the principle that objects have independent life cycles

-- careful the principle.

-- our method would need an extra parameter with the value of the receiver.

--This use of a self parameter is a central point in any object-oriented language. Most OO languages have
--this mechanism hidden from the programmer, so that she does not have to declare this parameter (although
--she still can use the name self or this inside a method). Lua also can hide this parameter, with the colon
--operator

--careful: this should match.
--The effect of the colon is to add an extra argument in a method call and to add an extra hidden parameter
--in a method definition.

function account:withdraw (v)
  self.balance = self.balance - v
end


account = { balance=0,
  withdraw = function (self, v)
    self.balance = self.balance - v
  end
}
function account:deposit (v)
  self.balance = self.balance + v
end
account.deposit(account, 200.00)
account:withdraw(100.00)

-- classes
-- class system, inheritance, and privacy

--we can emulate classes in Lua following the lead from prototype-based languages like Self. (Javascript also
--followed that path.) In these languages, objects have no classes. Instead, each object may have a prototype,
--which is a regular object where the first object looks up any operation that it does not know about. To
--represent a class in such languages, we simply create an object to be used exclusively as a prototype for
--other objects (its instances). Both classes and prototypes work as a place to put behavior to be shared by
--several objects.

-- setmetatable(A, {__index = B})

local mt = {__index = account}
--function account.new (o)
--  o = o or {}
--  -- create table if user does not provide one
--  setmetatable(o, mt)
--  return o
--end

function account:new (o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function account:withdraw (v)
  if v > self.balance then error"insufficient funds" end
  self.balance = self.balance - v
end

function account:getLimit ()
  return self.limit or 0
end

local a = account:new{balance = 0}
a:deposit(100.00)
-- getmetatable(a).__index.deposit(a, 100.00)
print(a.balance)

-- Inheritance


local specialAccount = account:new()

function specialAccount:withdraw (v)
  if v - self.balance >= self:getLimit() then
    error"insufficient funds"
  end
  self.balance = self.balance - v
end

function specialAccount:getLimit ()
  return self.limit or 0
end

--SpecialAccount inherits new from Account, like any other method. This time, however, when new
--executes, its self parameter will refer to SpecialAccount. Therefore, the metatable of s will be
--SpecialAccount, whose value at field __index is also SpecialAccount. So, s inherits from
--SpecialAccount, which inherits from Account.
local s = specialAccount:new{limit=1000.00}
s:deposit(100.00)
s:withdraw(1001.00)

--An interesting aspect of objects in Lua is that we do not need to create a new class to specify a new
--behavior. If only a single object needs a specific behavior, we can implement that behavior directly in
--the object.
--function s:getLimit ()
--  return self.balance * 0.10
--end

-- Multiple Inheritance

-- look up for 'k' in list of tables 'plist'
local function search (k, plist)
  for i = 1, #plist do
    local v = plist[i][k]
    -- try 'i'-th superclass
    if v then return v end
  end
end

local function createClass (...)
  local c = {}    -- proxy super class.
  -- new class
  local parents = {...}
  -- list of parents
  -- class searches for absent methods in its list of parents
  setmetatable(c, {__index = function (t, k)
        -- return search(k, parents)
        local v = search(k, parents)
        t[k] = v
        -- save for next access
        return v
      end})
  -- prepare 'c' to be the metatable of its instances
  c.__index = c
  -- define a new constructor for this new class
  function c:new (o)
    o = o or {}
    setmetatable(o, c)
    return o
  end
  return c
end

local named = {}
function named:getname ()
  return self.name
end
function named:setname (n)
  self.name = n
end

local NamedAccount = createClass(account, named)

local account1 = NamedAccount:new{name = "Paul"}
print(account1:getname()) --> Paul
print(account1:getLimit())

-- private

--The basic idea of this alternative design is to represent each object through two tables: one for its state
--and another for its operations, or its interface. We access the object itself through the second table, that
--is, through the operations that compose its interface. To avoid unauthorized access, the table representing
--the state of an object is not kept in a field of the other table; instead, it is kept only in the closure of the
--methods

--The key point here is that these
--methods do not get self as an extra parameter; instead, they access self directly

local function newAccount (initialBalance)
  local self = { balance = initialBalance, LIM = 10000.00, }
  -- private method
  local extra = function ()
    if self.balance > self.LIM then
      return self.balance * 0.10
    else
      return 0
    end
  end
  local withdraw = function (v)
    self.balance = self.balance - v
  end
  local deposit = function (v)
    self.balance = self.balance + v
  end
  local getBalance = function () 
    return self.balance + extra()
  end
  return {
    withdraw = withdraw,
    deposit = deposit,
    getBalance = getBalance
  }
end

local acc1 = newAccount(100.00)
acc1.withdraw(40.00)
print(acc1.getBalance()) --> 60

-- The Single-Method Approach
-- it is worth remembering iterators
-- like io.lines or string.gmatch. An iterator that keeps state internally is nothing more than a sin-
-- gle-method object

-- Each object uses one
-- single closure, which is usually cheaper than one table. There is no inheritance, but we have full privacy:
-- the only way to access an object state is through its sole method

local function newObject (value)
  return function (action, v)
    if action == "get" then return value
    elseif action == "set" then value = v
    else error("invalid action")
    end
  end
end

local d = newObject(0)
print(d("get"))
d("set", 10)
print(d("get"))

-- Dual Representation
-- Another interesting approach for privacy uses a dual representation.

--function Account.withdraw (self, v)
--balance[self] = balance[self] - v
--end

-- gain
-- Privacy

-- naivety
--Before we go on, I must discuss a big naivety of this implementation. Once we use an account as a key in
--the balance table, that account will never become garbage for the garbage collector. It will be anchored
--there until some code explicitly removes it from that table. That may not be a problem for bank accounts
--(as an account usually has to be formally closed before going away), but for other scenarios that could
--be a big drawback. In the section called “Object Attributes”, we will see how to solve this problem. For
--now, we will ignore it.

local balance = {}
local AccountDual = {}
function AccountDual:withdraw (v)
  balance[self] = balance[self] - v
end
function AccountDual:deposit (v)
  balance[self] = balance[self] + v
end
function AccountDual:balance ()
  return balance[self]
end
function AccountDual:new (o)
  o = o or {}
-- create table if user does not provide one
  setmetatable(o, self)
  self.__index = self
  balance[o] = 0
  -- initial balance
  return o
end

a = AccountDual:new{}
a:deposit(100.00)
print(a:balance())

--The access balance[self] can be slightly slower than self.balance, because the
--latter uses a local variable while the first uses an external variable. Usually this difference is negligible.
--As we will see later, it also demands some extra work from the garbage collector.