
-- --------------------------------------------------------------------
-- 全局 run 一个动作，如果再次运行这个动作，先停止该动作（不管是否允许完成）

cc.Director:getInstance():getRunningScene():stopActionByTag(-1127367)
performWithDelay(cc.Director:getInstance():getRunningScene(), function()
	-- do some action( file save or something else)
end, 5):setTag(-1127367)

-- --------------------------------------------------------------------
-- 判断给到的参数为字符串且不为空
assert(type(name) == "string" and name ~= "", ("need %s to be a string and not \"\""):format(name))


-- --------------------------------------------------------------------
-- 在 game/skill 文件夹下 存在文件 SkillZhiliao
-- 这个文件下都类似这样的（当然包括其他的方法）

	-- file start

	SkillJianyu = class("SkillJianyu")

	SkillJianyu.__create = function(parm1, parm2)

	end

	-- file end

-- 可以这样调用, 这样就获得了 cls 这个实体
local className = "SkillJianyu"
require("game.skill." .. className)
local cls = _G[className].new("parm1", "parm2")

-- --------------------------------------------------------------------
-- 确保在表t中获得的特定的字段
-- t and t.cfg_ and t.cfg_.typeName 查看
self:delegateFilter(parm1, parm2, t and t.cfg_ and t.cfg_.typeName)

-- --------------------------------------------------------------------
-- 在release的包中打印的方法(已经生成为release版的so文件也可以打印到logcat中)：
release_print("xxx")


-- --------------------------------------------------------------------
-- 如果要赋值的一个函数调用可能会出错，
-- 1. 可使用 pcall ，如果出错将不继续往下运行
	-- pcall接收一个函数和要传递个后者的参数，并执行，执行结果：有错误、无错误；返回值true或者或false, errorinfo
	-- 经验证，countingTime:getString() 在debug模式下可以运行没问题，在release模式下会出错，程序停止运行
local intTime
local isSucc, result = pcall(function()	return tonumber(countingTime:getString()) end)
if isSucc then intTime = result else SCHEDULER:unscheduleScriptEntry(handle) return end

-- 2. 添加一个额外的变量做调用检测
countingTime.__existsTest = true
local function onTimeClick()
    if not countingTime.__existsTest then
        SCHEDULER:unscheduleScriptEntry(handle)
        return
    end
    local intTime = tonumber(countingTime:getString())
    -- the rest of code
end
handle = SCHEDULER:scheduleScriptFunc(onTimeClick, 1, false)

-- --------------------------------------------------------------------
-- cc.CallFunc:create 的传参方法

-- 1. 使用表传参
gRootScene:runAction(cc.CallFunc:create(function(node, tb)
    print(node)  -- 该node即是动作调用者gRootScene
    print(tb)  　-- 该tb即是后面所跟随的{int2 = 543}这个自定义表，必须要求是table类型
end, {int2 = 543}))

-- 2. 使用尾调传参
gRootScene:runAction(cc.CallFunc:create((function(a,b)
    return function() print(a,b) end   -- 正确打印a, b 为 10, 20
end)(10,20)))
-- 注意
print(type((function(a,b)
    print("x")
    return function() print(a,b) end
end)(10,20)))
-- output:
-- [LUA-print] x   -- 此处因为type运算的时候做了一次调用。
-- [LUA-print] function
