
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

-- 确保在表t中获得的特定的字段
-- t and t.cfg_ and t.cfg_.typeName 查看
self:delegateFilter(parm1, parm2, t and t.cfg_ and t.cfg_.typeName)
