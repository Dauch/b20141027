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