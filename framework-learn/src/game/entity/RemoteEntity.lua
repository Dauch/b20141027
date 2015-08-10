-- 小岩<shenyan@910app.com>
-- 2015-4-16 11:13
local SkeletonEntity = require "game.entity.SkeletonEntity"

local RemoteEntity = class("RemoteEntity", SkeletonEntity)

function RemoteEntity:ctor(view, cfg)
	RemoteEntity.super.ctor(self, view, cfg)
end

function RemoteEntity:getAttackRect()
	if self:getView():getDirection() == -1 then
		return cc.rect(
			self:getView():getPositionX()+self:getView():getDirection()*self:getCfgByKey("distance"),
			self:getView():getPositionY(),
			self:getCfgByKey("distance"),
			self:getCRect().height
		)
	else
		return cc.rect(
			self:getView():getPositionX(),
			self:getView():getPositionY(),
			self:getCfgByKey("distance"),
			self:getCRect().height
		)
	end
end

return RemoteEntity
