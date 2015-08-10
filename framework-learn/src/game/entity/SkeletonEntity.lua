-- 小岩<shenyan@910app.com>
-- 2015-4-14 20:36
local EntityDriver = require("src.firework.framework.EntityDriver")
local SkeletonEntity = class("SkeletonEntity", EntityDriver)

function SkeletonEntity:ctor(view, cfg)
	SkeletonEntity.super.ctor(self)
	self.view_ = view
end

function SkeletonEntity:onRemove()
	for comName, _ in pairs(self.components_) do
		self:removeComponent(comName)
	end
end

return SkeletonEntity
