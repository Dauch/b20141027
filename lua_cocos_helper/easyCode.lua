-------------------------------------
--  easy multi function call
-------------------------------------
local function func1()
end
local function func2()
end
action={"1":func1,"2":func2}
action["1"]()

-------------------------------------
--  easy access table member
-------------------------------------
GAME_IMAGE = {
    bg_mainscene = "img/bg_mainscene.jpg",
    spark_1      = "img/spark/spark_1.png",
    spark_2      = "img/spark/spark_2.png",
    spark_3      = "img/spark/spark_3.png",
    spark_4      = "img/spark/spark_4.png",
}

print(GAME_IMAGE.bg_mainscene)      -- "img/bg_mainscene.jpg"

for i = 1, 4 do
	print(GAME_IMAGE.["spark_" .. i])      -- all will be printed correctly
end

-------------------------------------
--  branches print a single string(if the string is too long)
-------------------------------------
local a = "123456789"
local n = string.len(a)
local t = ""
local tn = 1
-- fixd length
local fixLen = 2
if n > fixLen then
    repeat
        t = t .. "\n" .. string.sub(a, tn, tn + fixLen - 1)
        tn = tn + fixLen
    until tn > n
end
print(t)

-------------------------------------
--  将多项分2列排序（控制x， y）
-------------------------------------
-- 1    2
-- 3    4
-- 5
local itemCount = 5
for itemIndex = 1, itemCount do
    local itemPosX = w*0.5 + (i - math.ceil(itemCount/2)) * itemWidth
    local itemPosY = h*0.5 + itemHeight
end


-- 如果遇到很多类似下面的判断,而且then下面需要执行的逻辑有规律
if id == "pay1" then
elseif id == "pay2" then
elseif id == "pay3" then
elseif id == "pay4" then
elseif id == "pay5" then
elseif id == "pay6" then
end
-- 可使用下面的方法优雅的代替
local case = {"pay1", "pay2", "pay3", "pay4", "pay5", "pay6"}
for i = 1, #case do
    if id == case[i] then
        -- do
        break
    end
end

-------------------------------------
--  在quick中如何遍历子物体
-------------------------------------
-- 遍历子物体
local children = node:getChildren()
local len = children:count()
for i = 0, len-1, 1 do
    -- child 即是子物体
    local child = tolua.cast(children:objectAtIndex(i), "CCNode")
end