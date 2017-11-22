-- data file

-- reason
-- compile the data file is more security.
-- lua compile fast, run fast. 

-- thinking: how to do the benchmark to prove that.

-- The technique is to write our data file as Lua code that, when run, rebuilds the data into the program.

-- we represent each data record as a Lua constructor

local count = 0
function Entry (entry) 
  count = count + 1 
end
dofile("data1")
print("number of entries: " .. count)

-- Note the event-driven approach in these program fragments: the function Entry acts as a callback func-
-- tion, which is called during the dofile for each entry in the data file.

local authors = {}
-- a set to collect authors
function Entry (b) 
  authors[b.author or "unknown"] = true
end
dofile("data2")
for name in pairs(authors) do print(name) end

-- We might be tempted to use the simpler pattern ']=*]', which does not use a frontier pattern for the
-- second square bracket, but there is a subtlety here. Suppose the subject is "]=]==]". The first match is
-- "]=]". After it, what is left in the string is "==]", and so there is no other match; in the end of the loop,
-- n would be one instead of two. The frontier pattern does not consume the bracket, so that it remains in
-- the subject for the following matches.

function quote (s)
-- find maximum length of sequences of equals signs
  local n = -1
  for w in string.gmatch(s, "]=*%f[%]]") do
    n = math.max(n, #w - 1)
-- -1 to remove the ']'
  end
-- produce a string with 'n' plus one equals signs
  local eq = string.rep("=", n + 1)
-- build quoted string
  return string.format(" [%s[\n%s]%s] ", eq, s, eq)
end