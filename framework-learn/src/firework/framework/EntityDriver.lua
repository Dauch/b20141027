-- 小岩<shenyan@910app.com>
-- 2015-4-14 20:07
local EntityDriver = class("EntityDriver")

function EntityDriver:ctor()
	self.listenerList_ = {}
	self.runtimeId_ = 0
	self.eM_ = nil -- ENTITY MGR
end

function EntityDriver:setRid(rid)
	self.runtimeId_ = rid
end

function EntityDriver:getRid()
	return self.runtimeId_
end

function EntityDriver:setEM(mgr)
	self.eM_ = mgr
end

function EntityDriver:getEM()
	return self.eM_
end

function EntityDriver:registerListener(callback, target)
	assert(callback ~= nil and type(callback) == "function",
		self.__cname .. ":registerListener() -- invalid callback")
	for _, listeners in ipairs(self.listenerList_) do
		if listeners[1] == callback and listeners[2] == target then
			return
		end
	end
	table.insert(self.listenerList_, {callback,target})
end

function EntityDriver:removeListener(callback, target)
	assert(callback ~= nil and type(callback) == "function",
		self.__cname .. ":removeListener() -- invalid callback")
	for index, listeners in ipairs(self.listenerList_) do
		if listeners[1] == callback and listeners[2] == target then
			table.remove(self.listenerList_, index)
		end
	end
end

function EntityDriver:update(dt)
	for _, listeners in ipairs(self.listenerList_) do
		if listeners[2] then
			listeners[1](listeners[2], dt)
		else
			listeners[1](dt)
		end
	end
end

function EntityDriver:clearListeners()
	self.listenerList_ = {}
end

return EntityDriver