
-- 创建一个序列帧动画 walk0001.png ~ walk0008.png
local frames = display.newFrames("Walk%04d", 1, 8)
local animatiom = display.newAnimation(frames, 0.2)

-- 创建一个 Sprite
local sprite = display.newSprite("#Walk0001.png")

-- 在 Sprite 上播放动画
sprite:playanimationForever(animation)



-- 创建一个序列帧动画 walk0001.png ~ walk0008.png
local cache = cc.SpriteFrameCache:getInstance()
local frames = {}
for i = 1, 8 do
	local name = string.format("Walk%0d.png", i)
	local frame = cache:getSpriteFrame(name)
	frames[#frames + 1] = frame
end
local time = 0.2 / ##frames
local animation = cc.Animation:createWithSpriteFrames(frames, time)

-- 创建一个 Sprite
local sprite = cc.Sprite:createWithSpriteFrame("Walk0001.png")

-- 创建一个序列帧动画 walk0001.png ~ walk0008.png
local animate = cc.Animate:create(animation)
local action = cc.RepeateForever:create(animate)
sprite::runAction(action)
