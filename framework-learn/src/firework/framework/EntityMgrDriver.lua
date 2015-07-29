-- 小岩<shenyan@910app.com>
-- 2015-4-14 20:15
local EntityMgrDriver = class("EntityMgrDriver")

function EntityMgrDriver:ctor()
	self.entityList_ = {}
	self.eNums_ = 0
end

function EntityMgrDriver:addEntity(e)
	for _, entity in ipairs(self.entityList_) do
		if entity == e then
			return
		end
	end
	table.insert(self.entityList_, e)
	self.eNums_ = self.eNums_ + 1
	e:setRid(self.eNums_)
	e:setEM(self)
end

function EntityMgrDriver:removeEntity(e)
	e:onRemove()
	local rid = e:getRid()
	assert(rid>0 and rid <= self.eNums_,
		string.format(self.__cname .. "removeEntity() -- invalid rid %d", tonumber(rid)))
	table.remove(self.entityList_, rid)
	self.eNums_ = #self.entityList_
	for index, entity in ipairs(self.entityList_) do
		if entity:getRid() > rid then
			entity:setRid(index)
		end
	end
end

function EntityMgrDriver:update(dt)
	self:updateImpl(dt)
	for _, entity in ipairs(self.entityList_) do
		entity:update(dt)
	end
end

function EntityMgrDriver:updateImpl(dt)
	error(self.__cname .. ":updateImpl() Method Not Implemented!")
end

function EntityMgrDriver:getEntityAll()
	return self.entityList_
end

function EntityMgrDriver:getEntityNum()
	return self.eNums_
end

return EntityMgrDriver