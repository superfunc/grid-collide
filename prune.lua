-- Copyright 2019 (c) superfunc
-- See LICENSE file for conditions of usage.
--
-- This file provides a simple prune function (with basic perf tests below)
-- for fast removal from an array, when order doesn't matter

-- Since order of elements doesn't matter to us, we can efficiently
-- remove by using heap-style deletion. We swap 'dead' entites with the
-- end element (which is cheap, its just a few numbers), and then trim
-- the end element off with table:remove, avoiding sliding all elements down.

function prune(t, shouldPrune)
  local i = 1
  while i < #t do
    if shouldPrune(t[i]) then
      t[i], t[#t] = t[#t], t[i]
      table.remove(t,#t)
    else
      i = i + 1
    end
  end
end

ts1 = {}
ts2 = {}

local N = 10000
print("Testing for array of size N: " .. N)

for i=1,N do
  k = math.random(10)
  ts1[i] = k
  ts2[i] = k
end

t0 = os.clock()
local i = 1
while i < #ts1 do
  if ts1[i] < 5 then
    table.remove(ts1, i)
  else
    i = i + 1
  end
end
t1 = os.clock()
print("traditional removal: ", (t1-t0))

t0 = os.clock()
prune(ts2, function (n) return n < 5 end)
t1 = os.clock()
print("prune removal: ", (t1-t0))

print("length: " .. #ts2)
assert(#ts1==#ts2)
