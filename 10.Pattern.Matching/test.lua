-- Pattern Matching

local function printSeperate()
  print('-------------------------------------------------------')
end

print('')

-- string.find
do
  local s = "hello world"
  local i, j = string.find(s, "hello") -- 1  5

-- print(string.find(s, "world")) --> 7 11
-- print(string.find(s, "l"))     --> 3 3 only find the first one.
-- print(string.find(s, "lll"))   -- nil

-- '[' is start of the pattern
-- string.find("a [word]", "[")
-- stdin:1: malformed pattern (missing ']')
-- print(string.find("a [word]", "[", 1, true))--> 3 3

end

do
  -- string.match("hello world", "hello") --> hello  
  local date = "Today is 17/7/1990"
  local d = string.match(date, "%d+/%d+/%d+")
  assert(d == '17/7/1990')
end

do
  local times
  local s = string.gsub("Lua is cute", "cute", "great")
  assert(s == "Lua is great")

  s, times = string.gsub('all lii', 'l', 'x')
  assert(s == 'axx xii' and times == 3)

  s, times = string.gsub('Lua is great', 'Sol', 'Sun')
  assert(s == 'Lua is great' and times == 0)
end

do
  local s = "some string"
  local words = {}
  for w in string.gmatch(s, "%a+") do
    words[#words + 1] = w
  end
  assert(words[1] == 'some' and words[2] == 'string')
end

do
-- Patterns
-- In general, any escaped alphanumeric character has some special meaning (e.g., '%a' matches any letter), 
-- while any escaped non-alphanumeric character represents itself (e.g., '%.' matches a dot)

-- local s = "Deadline is 30/05/1999, firm"
-- local date = "%d%d/%d%d/%d%d%d%d"
-- print(string.match(s, date)) --> 30/05/1999

-- .  all characters
-- %a letters
-- %c control characters
-- %d digits
-- %g printable characters except spaces (what's include)
-- %l lower-case letters
-- %p punctuation characters
-- %s space characters
-- %u upper-case letters
-- %w alphanumeric characters
-- %x hexadecimal digits
-- An upper-case version of any of these classes represents the complement of the class.

  -- (When printing the results of gsub, I am using extra parentheses to discard its second result, 
  -- which is the number of substitutions.)
  assert((string.gsub("hello, up-down!", "%A", ".")) == 'hello..up.down.')

  -- different between letter and alphanumeric characters, alphanumeric characters include letter and number.
  assert(string.match("Hello123, world", "%a+") == 'Hello')
  assert(string.match("Hello123, world", "%w+") == 'Hello123')
  assert(string.match("Hello123\n\1, world", ".+") == 'Hello123\n\1, world') -- . match all, include control characters.

-- magic characters
-- ( ) . % + - * ? [ ] ^ $

-- ( ) We specify a capture by writing the parts of the pattern that we want to capture between parentheses
-- . represent all character.
-- % use to escape.

-- four modifiers
-- + 1 or more repetitions
-- - 0 or more repetitions
-- * 0 or more lazy repetitions
-- ? optional (0 or 1 occurrence)

-- [] use to define the charset

-- ^ If a pattern begins with a caret, it will match only at the beginning of the subject string. means start with.
-- $ if itends with a dollar sign, it will match only at the end of the subject string.
-- We can use these marks both to restrict the matches that we find and to anchor patterns.

-- We can escape not only the magic characters, but also any non-alphanumeric character
end


do 
-- char-set: define your own class of character.
-- example: [%w_], [%[%]]
-- complement '[^0-7]' '[^\n]'
-- example: to match an empty parenthesis pair, such as () or ( ), we can use the pattern '%(%s*%)'
-- example: '[_%a][_%w]*'
-- difference: '[_%a][_%w]*', '[_%a][_%w]-', the latter, return as soon as it find one, the before, find as much as possible.
-- * and - : However, instead of matching the longest sequence, it matches the shortest one

  assert(string.match('_variate', '[_%a][_%w]-') == '_')
  assert(string.match('_variate%', '[_%a][_%w]-%%') == '_variate%')
  assert(string.match('_variate%', '[_%a][_%w]-%%') == '_variate%')
  -- wow!
  ret = 'int x; /* x */ int y; /* y */'
  assert((string.gsub(ret, "/%*.*%*/", "")) == 'int x; ')
  assert((string.gsub(ret, "/%*.-%*/", "")) == 'int x;  int y; ')  
end

-- in Lua we can apply a modifier only to a character class; there is no way to
-- group patterns under a modifier.

do
  --   
  --The caret and dollar signs are magic only when used in the beginning or end of the pattern. Otherwise,
  --they act as regular characters matching themselves.  

  local pattern 

  pattern = '^[+-]?%d+$'  
  assert(string.match('+1', pattern) == '+1')
  assert(string.match('-2', pattern) == '-2')
  assert(string.match('abc', pattern) == nil)
  assert(string.match('1', pattern) == '1')

  pattern = '^a[+-]?%d+b$'
  assert(string.match('a+1b', pattern) == 'a+1b')
  assert(string.match('a+1b 1', pattern) == nil)
  assert(string.match('-2', pattern) == nil)
  assert(string.match('abc', pattern) == nil)
  assert(string.match('a1b', pattern) == 'a1b')

  pattern = 'a[+-]?%d+b'
  assert(string.match('a+1b', pattern) == 'a+1b')
  assert(string.match('a+1b 1', pattern) == 'a+1b')
  assert(string.match('-2', pattern) == nil)
  assert(string.match('abc', pattern) == nil)
  assert(string.match('a1b2', pattern) == 'a1b')  
end

do
-- we can think it as a stash.
-- Typically, we use this pattern as '%b()', '%b[]', '%b{}', or '%b<>', but we can use any two distinct char-
-- acters as delimiters.

-- %b(.) make no sense.
  local s = "a (enclosed (in) parentheses) line"
  assert((string.gsub(s, "%b()", "1")) == 'a 1 line')
end

do
-- the item '%f[char-set]' represents a frontier pattern. It matches an empty string only if the
-- next character is in char-set but the previous one is not

-- The frontier pattern treats the positions before the first and after the last characters in the subject string as
-- if they had the null character (ASCII code zero).

  local s = "the anthem is the the"
  assert((string.gsub(s, "%f[%w]the%f[%W]", "one")) == 'one anthem is one one')
end

-- Captures

do
-- The capture mechanism allows a pattern to yank parts of the subject string that match parts of the pattern for further use.

--For instance, there is no pattern that matches an optional word (unless
--the word has only one letter). Usually, we can circumvent this limitation using some of the advanced
--techniques that we will see in the end of this chapter.

--pair = "name = Anna"
--key, value = string.match(pair, "(%a+)%s*=%s*(%a+)")
--print(key, value) --> name Anna

--date = "Today is 17/7/1990"
--d, m, y = string.match(date, "(%d+)/(%d+)/(%d+)")
--print(d, m, y) --> 17 7 1990

-- '%n' when appear in pattern, matches only a copy of the n-th capture.

-- this example just return: "	it's all right, 'why?' 
-- the 'why?' is not return, means that this is one loop search.
-- the loop like the eight-qreen. test every position posible, but when it find one, it will return as soon as posible.
-- you can also test [[then he said: "it's all right, 'why?' !]], miss the ending "
--s = [[then he said: "it's all right, 'why?' "!]]
--q, quotedPart = string.match(s, "([\"'])(.-)%1")
--print(quotedPart) --> it's all right
--print(q) --> "

--p = "%[(=*)%[(.-)%]%1%]"
--s = "a = [=[[[ something ]] ]==] ]=]; print(a)"
--print(string.match(s, p)) --> =[[ something ]] ]==]

-- %n can use in pattern and replace string.

-- two capture in the gsub.
  s = [[then he said: "it's all right, 'why?' "!]]
  result = string.gsub(s, "([\"'])(.-)%1", function(x, y)       
      return 'efg', 'abc' -- why will apply the first.
    end)
  assert(result == 'then he said: efg!') 

  result = string.gsub(s, '(%b"")', function(x, y)       
      return 'efg', 'abc' -- why will apply the first.
    end)
  assert(result == 'then he said: efg!')

-- the item "%0" becomes the whole match
-- print((string.gsub("hello Lua!", "%a", "%0-%0"))) --> h-he-el-ll-lo-o L-Lu-ua-a!

-- one loop
-- print((string.gsub("hello Lua", "(.)(.)", "%2%1"))) --> ehll ouLa

-- disallow nested command
  local s = [[the \quote{task} is to \em{change} that.]]
  s = string.gsub(s, "\\(%a+){(.-)}", "<%1>%2</%1>")
  assert(s == 'the <quote>task</quote> is to <em>change</em> that.')

  -- it also a one loop search.
  s = [[the \quote{task \em{change} } is to  that.]]
  s = string.gsub(s, "\\(%a+)(%b{})", "<%1>%2</%1>")  
  assert(s == 'the <quote>{task \\em{change} }</quote> is to  that.')
end

do
-- trim means only remove the begin and ending space for the target string.
  function trim (s)
    s = string.gsub(s, "^%s*(.-)%s*$", "-%1-")
--s = string.gsub(s, "%s+(.-)%s", "-%1-")  -- careful, not ending %s+, because the one loop search.
    return s
  end

  assert(trim ("what is't  the matter") == "-what is't  the matter-")
  assert(trim (" the efg ") == "-the efg-")
end

do
-- replacement, must use the catch
  function expand (s,t)
    return (string.gsub(s, "$(%w+)", t))
  end

--func version
--function expand (s)
--  return (string.gsub(s, "$(%w+)", function (n)
--        return tostring(_G[n])
--      end))
--end

  local t = {name = "Lua"; status = "great"}
  assert(expand("$name is $status, isn't it?", t) == "Lua is great, isn't it?")
end


do
  function toxml (s)
    s = string.gsub(s, "\\(%a+)(%b{})", function (tag, body)
        body = string.sub(body, 2, -2) -- remove the brackets
        body = toxml(body)
        -- handle nested commands
        return string.format("<%s>%s</%s>", tag, body, tag)
      end)
    return s
  end
  assert(toxml("\\title{The \\bold{big} example}") == '<title>The <bold>big</bold> example</title>') --> <title>The <bold>big</bold> example</title>
end


do
  local origin = "a+b = c"

  function escape (s)
    s = string.gsub(s, "([=+])", function (h)
        return string.format('%%%02X', string.byte(h)) -- must escape, because the % has specail meaning in the format.
      end)
    s = string.gsub(s, " ", "+") -- must not use %s*, we can't change the number of the origin spaces.
    return s
  end

  local intermedia = escape(origin)
  assert ("a%2Bb+%3D+c" == intermedia) -- %2B --> +   |    %3D --> =


  local function unescape (s)
    s = string.gsub(s, "+", " ")
    s = string.gsub(s, "%%(%x%x)", function (h)  -- if the origin plain text has someting %xx, it will convert to char also, but it is all right.
        return string.char(tonumber(h, 16))
      end)
    return s
  end

  assert (origin == unescape(intermedia))

  local cgi = {}
  local function decode (s)
    for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
      name = unescape(name)
      value = unescape(value)
      cgi[name] = value
    end
  end

  decode("a=b&c=d")

  assert(cgi['a'] == 'b')
  assert(cgi['c'] == 'd')


  function encode (t)
    local b = {}
    for k,v in pairs(t) do
      b[#b + 1] = (escape(k) .. "=" .. escape(v))
    end
-- concatenates all entries in 'b', separated by "&"
    return table.concat(b, "&")
  end
  local t = {name = "al", query = "a+b = c", q = "yes or no"}
  --print(encode(t)) --> q=yes+or+no&query=a%2Bb+%3D+c&name=al
  encode(t)

end

do
-- Tab expansion

-- second capture is after the match
-- print(string.match("hello", "()ll()")) --> 3 5

-- tab's meaning is: I want to let the netx char at the position which is times of const.
-- corr is total spaces to replace the tab, remove total number of tab
-- so (p - 1) is the position before the current tab
-- so (p - 1) + corr is total number of characters after before replacement.

-- corr is the addiction number of space expand by tab, (addition means remove the old tab one.)
  function expandTabs (s, tab)
    tab = tab or 8 -- tab "size" (default is 8)
    local corr = 0 -- correction
    s = string.gsub(s, "()\t", function (p)      
        local sp = tab - (p - 1 + corr)%tab -- tab meaning is every 8 a group.
        corr = corr - 1 + sp -- remove 1(\t), sp is now      
        return string.rep(" ", sp)
      end)
    return s
  end

  function myExpandTabs (s, tab)
    tab = tab or 8 -- tab "size" (default is 8)
    local counter = 0 -- correction
    local spaces = 0 
    s = string.gsub(s, "()\t", function (p)     
        local sp = tab - (p - 1 -counter + spaces)%tab
        counter = counter + 1
        spaces = spaces + sp
        return string.rep(" ", sp)
      end)
    return s
  end

--  print("book version:")
--  print(expandTabs("\t123\tabc"))
--  print("my version:")
--  print(myExpandTabs("\t1234\tabc"))

-- at every eighth character, we insert a mark in the string. Then, wherever the mark is preceded by spaces, we
-- replace the sequence spaces–mark by a tab
  function unexpandTabs (s, tab)
    tab = tab or 8
    s = expandTabs(s, tab)
    local pat = string.rep(".", tab)  -- every 8 char is a group
    s = string.gsub(s, pat, "%0\1")   -- insert \1 every 8 char
    s = string.gsub(s, "%s+\1", "\t")  -- replace space+\1 to \t. only places which have space replaced by tab.
    s = string.gsub(s, "\1", "")      -- remove \1
    return s
  end

-- use the for, search every 8 char. remove the space and head(only all space) and tail.
-- so bad!

--  print("expand:")
--  print(unexpandTabs("        abc     abc  aaa"))

-- print(unexpandTabs2("        a c     abc"))
--x = string.gsub("hello world", "%w+", "%1 abc")
--print(x)
end

-- try different with %0 and %1
--x = string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%0")
--print(x)

--s1 = "\t\2"
--s1 = string.gsub(s1, "(%W)", "%%%1")
--print(s1)

--s2 = "%1"
--s2 = string.gsub(s2, "%%", "%%%%")
--print(s2)

do
  -- convert control char to hex.
  local function escape_v2 (s)
    return (string.gsub(s, "(%W)", function (x)
          return string.format("\\%03d", string.byte(x))
        end))
  end

  assert(escape_v2("\t\2") == '\\009\\002') -- when you write must double \\


  function code (s)
    -- lua: test-10.lua:117: invalid escape sequence near '\('
    -- must use the double \\
    -- \ has meaning in string.
    return (string.gsub(s, "\\(.)", function (x)
          return string.format("\\%03d", string.byte(x))
        end))
  end

  assert(code("\\1abc") == '\\049abc')

  function decode (s)
    return (string.gsub(s, "\\(%d%d%d)", function (d)
          return "\\" .. string.char(tonumber(d))
        end))
  end

  s = [[follows a typical string: "This is \"great\"oh!".]]
  assert(string.gsub(s, '".-"', string.upper) == 'follows a typical string: "THIS IS \\"great\\"OH!".')
  assert(code(s) == 'follows a typical string: "This is \\034great\\034oh!".')

  assert(decode(string.gsub(s, '".-"', string.upper)) == 'follows a typical string: "THIS IS \\"great\\"OH!".') 
  assert(decode(string.gsub(code(s), '".-"', string.upper)) == 'follows a typical string: "THIS IS \\"GREAT\\"OH!".')

end