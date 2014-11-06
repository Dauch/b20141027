-- Lua Test
--===========================================
local t1 = {2, 4, {6}, language="Lua", version="5", 8, 10, 12, web="hello lua"}
table.foreachi(t1, function(i, v) print (i, v) end)  --等价于foreachi(t1, print)
print("------------- ")
table.foreach(t1, function(i, v) print (i, v) end)
print("------------- " .. table.getn(t1)) -- 6
print("------------- " .. #t1) -- 6

-- [LUA-print] 1   2
-- [LUA-print] 2   4
-- [LUA-print] 3   table
-- [LUA-print] 4   8
-- [LUA-print] 5   10
-- [LUA-print] 6   12
-- [LUA-print] -------------
-- [LUA-print] 1   2
-- [LUA-print] 2   4
-- [LUA-print] 3   table
-- [LUA-print] 4   8
-- [LUA-print] 5   10
-- [LUA-print] 6   12
-- [LUA-print] web hello lua
-- [LUA-print] version 5
-- [LUA-print] language    Lua
-- [LUA-print] ------------- 6
-- [LUA-print] ------------- 6
--===========================================
