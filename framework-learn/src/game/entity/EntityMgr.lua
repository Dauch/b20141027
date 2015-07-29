-- 小岩<shenyan@910app.com>
-- 2015-4-15 9:58
local EntityMgrDriver = require("src.firework.framework.Entit")
local EntityMgr = class("EntityMgr", EntityMgrDriver)

function EntityMgr:ctor(cb)
	EntityMgr.super.ctor(self)
	self.getEnmeyEntityListCallback_ = cb or nil
end

function EntityMgr:setCB(cb)
	self.getEnmeyEntityListCallback_ = cb or nil
end

function EntityMgr:updateImpl(dt)
	local enmeyList = self.getEnmeyEntityListCallback_()

	for _, entity in ipairs(self:getEntityAll()) do
		if entity:canAttack() then
			entity:updateCefos01(enmeyList)
		end
	end
end

function EntityMgr:removeAll()
	for _, entity in ipairs(self:getEntityAll()) do
		entity:onRemove()
	end
end

return EntityMgr
