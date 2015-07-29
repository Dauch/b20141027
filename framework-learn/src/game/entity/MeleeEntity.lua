-- 小岩<shenyan@910app.com>
-- 2015-4-16 10:47

local SkeletonEntity = require "game.entity.SkeletonEntity"

local MeleeEntity = class("MeleeEntity", SkeletonEntity)

function MeleeEntity:ctor(view, cfg)
	MeleeEntity.super.ctor(self, view, cfg)
end

function MeleeEntity:getAttackRect()
	return self:getView():getBoundingBox()
end


return MeleeEntity
