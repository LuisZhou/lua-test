-- The first representation: number of second since Jan 01, 1970, 0:00 UTC
-- The second representation: table, year, month, day, hour, min, sec, wday, yday, and isdst.


-- this isdst mean this is light time or night. true?
-- year a full year
-- month    1–12
-- day      1–31
-- hour     0–23
-- min      0–59
-- sec      0–60
-- wday     1–7 (the day of the week)
-- yday     1–366 (the day of the year)
-- isdst    is bool, true if current is daylight.
-- careful: hour, min, Seconds can go up to 60 to allow for leap seconds.)


local function printDate(t)
    print('year', 'month', 'day', 'yday', 'wday', 'hour', 'min', 'sec', 'isdst')
    print(t.year, t.month, t.day, t.yday, t.wday, t.hour, t.min, t.sec, t.isdst)
end

do
	-- The Function os.time
	local current_timestamp = os.time() -- return current timestamp.
	print('\nprint current timestamp:', current_timestamp)
	-- we can not know in which month ,because every month have different day, so we don't know how many second in one month.
	local date = current_timestamp
	local day2year = 365.242 -- days in a year
	local sec2hour = 60 * 60 -- seconds in an hour
	local sec2day = sec2hour * 24 -- seconds in a day
	local sec2year = sec2day * day2year -- seconds in a year
	print('year', date / sec2year + 1970)
	print('hour', date % sec2day / sec2hour) --> hour (in UTC)
	print('mins', date % sec2hour / 60) --> 45
	print('second', date % 60) --> 20
	-- with parameter
	print(os.time({year=2015, month=8, day=15, hour=12, min=45, sec=20})) --> 1439653520
	-- here not return the 0, because the system always think the table is base on current timezone.
	-- if provide hour but without min and sec, min and sec will be zero too.
	print(os.time({year=1970, month=1, day=1, hour=0})) --> -28800, is 8 hours, because here is china timezone.
	print(os.time({year=1970, month=1, day=1, hour=0, sec=1}))
	-- The hour, min, and sec fields default to noon (12:00:00) when not provided.
	print(os.time({year=1970, month=1, day=1})) --> 54000
end

-- number to table or strign using os.date, example: os.date("*t", 906000490)
-- To produce a date table, we use the format string "*t".
-- The second parameter is the numeric datetime; it defaults to the current date and time if not provided.
print('------------------------------------------------------------------')
print('We test the relationship of os.time and os.date:')
-- The Function os.date
-- something very simple.
-- the date table always show the content human readable base on the timezone. no matter you read or write to the table, it base on the timezone.
-- but the timestamp is always base on epoch.
do
  -- you can verify the timestamp on https://www.epochconverter.com/
	local current_time_table = os.date("*t") -- return current time. it return the value is base on system timezone.
	--printDate(current_time_table)
	local timestamp = os.time({year=current_time_table.year, month=current_time_table.month, day=current_time_table.day, hour=0})
	print('the first second of current day is ', timestamp)
end


print('------------------------------------------------------------------')
-- test the second of os.date. that's fine. no print.
do
  local t = os.date("*t", 906000490)
  --printDate(t, '\n')
end
-- Date tables do not encode a time zone. It is up to the program to interpret them correctly with respect to time zones.
-- this statement is ambiguity when 0 translate to table, it always interpret is base on the current timezone.
-- but 0 is always zero. it always base on the epoch. it is the program's business to interpret it.
do
  local t = os.date("*t", 0)
  -- printDate(t) -- it show that is 8 hour in 1970/1/1, so it is base on current timezone.
  local revert = os.time(t) 
  -- print(revert, '\n') -- it show zero, because the t first convert to utc timezone, then to zero.
  -- another test
  assert(os.time(os.date("*t", 906000490)) == 906000490) 
end

--%a abbreviated weekday name (e.g., Wed)
--%A full weekday name (e.g., Wednesday)
--%b abbreviated month name (e.g., Sep)
--%B full month name (e.g., September)
--%c date and time (e.g., 09/16/98 23:48:10)
--%d day of the month (16) [01–31]
--%H hour, using a 24-hour clock (23) [00–23]
--%I hour, using a 12-hour clock (11) [01–12]
--%j day of the year (259) [001–365]
--%m month (09) [01–12]
--%M minute (48) [00–59]
--%p either "am" or "pm" (pm)
--%S second (10) [00–60]
--%w weekday (3) [0–6 = Sunday–Saturday]
--%W week of the year (37) [00–53]
--%x date (e.g., 09/16/98)
--%X time (e.g., 23:48:10)
--%y two-digit year (98) [00–99]
--%Y full year (1998)
--%z timezone (e.g., -0300)
--%% a percent sign
do  
  -- great, this will use the current langange base on the locale of the system.
  -- Directives
  print('test the directives of convert timestamp to string')
  print(os.date("a %A in %B %z")) --> a Tuesday in May
  print(os.date("%d/%m/%Y %z", 906000490)) --> 16/
end



print('------------------------------------------------------------------')
do
  print('test ISO 8601 format')
  -- ISO 8601
  t = 906000490
  -- ISO 8601 date
  print(os.date("%Y-%m-%d", t)) --> 1998-09-16
  -- ISO 8601 combined date and time
  print(os.date("%Y-%m-%dT%H:%M:%S", t)) --> 1998-09-16T23:48:10
  -- ISO 8601 ordinal date
  print(os.date("%Y-%j", t)) --> 1998-259
end


print('------------------------------------------------------------------')
do
  print('test the diff between "%c" and "!%c"')
  -- careful!
  print(os.date("%c", 0))  --> Thu Jan  1 08:00:00 1970
  print(os.date("!%c", 0)) --> Thu Jan  1 00:00:00 1970
end

print('------------------------------------------------------------------')
do
  print('test the format %x %X and %c, and fix format %d/%m/%Y')
  -- Note that the representations for %x, %X, and %c change according to the locale and the system
  print(os.date("%x, %X, and %c"), os.date("%d/%m/%Y"))
  -- 10/16/17, 22:56:54, and Mon Oct 16 22:56:54 2017  
end

-- something nothing to change.
-- os.date("*t", os.time(t))          -- still return the table which value is same as t.
-- os.time(os.date("*t", timestamp))  -- still return the timestamp.

-- normalization method

-- careful: do not add second direct to the time table if the result second is more exceed 60.
-- such as, t.second = t.second + (60 * 3)
-- explain:
-- In most systems, we could also add or subtract 3456000 (40 days in seconds) to the numeric time. However,
-- the C standard does not guarantee the correctness of this operation, because it does not require numeric
-- times to denote seconds from some epoch. Moreover, if we want to add some months instead of days, the
-- direct manipulation of seconds becomes problematic, as different months have different durations. The
-- normalization method, on the other hand, has none of these problems

-- We have to be careful when manipulating dates. Normalization works in a somewhat obvious way, but it
-- may have some non-obvious consequences. For instance, if we compute one month after March 31, that
-- would give April 31, which is normalized to May 1 (one day after April 30). That sounds quite natural.
-- However, if we take one month back from that result (May 1), we arrive on April 1, not the original March
-- Note that this mismatch is a consequence of the way our calendar works; it has nothing to do with Lua.
print('------------------------------------------------------------------')
do
  print('test the normalization method')
  t = os.date("*t") -- get current time
  print(os.date("%Y/%m/%d", os.time(t))) --> 2015/08/18
  -- good example, because just add 40 day means after that date.
  t.day = t.day + 40
  print(os.date("%Y/%m/%d", os.time(t))) --> 2015/09/27
  t.day = t.day - 40
  print(os.date("%Y/%m/%d", os.time(t))) --> roll to before
  
  -- wow !
  t = {year = 2000, month = 1, day = 1, hour = 0}
  t.sec = 501336000
  -- not change.
  --printDate(t) -- it is still 2000/1/1
  -- but this change.
  local timestamp = os.date("%d/%m/%Y", os.time(t))
  --print(timestamp) -- but it change to 20/11/2015
end

print('------------------------------------------------------------------')
do
  print('test the os.difftime')
  local t5_3 = os.time({year=2015, month=1, day=12})
  local t5_2 = os.time({year=2011, month=12, day=16})
  local d = os.difftime(t5_3, t5_2)
  -- print(d // (24 * 3600)) --> 1123.0
  print('day between 2015/1/12 and 2011/12/16 is:', d / (24 * 3600)) --> 1123.0
  local myepoch = os.time{year = 2000, month = 1, day = 1, hour = 0}
  local now = os.time{year = 2000, month = 1, day = 1}
  print('second between 2000/1/1T0:0 and 2000/1/1T12:0 is ', os.difftime(now, myepoch))
end

print('------------------------------------------------------------------')
do
  print('test os.clock, using to get the elapsed of exe something in microsecond')
  --Unlike os.time, os.clock usually has sub-second precision, so its result is a float. The exact precision
  --depends on the platform; in POSIX systems, it is typically one microsecond
  local x = os.clock()
  print(string.format("start time: %.10f", os.clock() ))
  local s = 0
  for i = 1, 100000 do s = s + i end
  print(string.format("elapsed time: %.4f", os.clock() - x))
end

print('\n')