-- 小岩<shenyan@910app.com>
-- 2014-4-16 17:30
local EntityDriver = require("src.firework.framework.EntityDriver")
local ArrowEntity = class("ArrowEntity", EntityDriver)

function ArrowEntity:ctor(view, cfg)
	ArrowEntity.super.ctor(self, view, cfg)
	self.view_ = view
end

function ArrowEntity:onRemove()
	for comName, _ in pairs(self.components_) do
		self:removeComponent(comName)
	end
end

return ArrowEntity
