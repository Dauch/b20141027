-------------------------------------
-- update / unUpdate
-------------------------------------
local scheduler = cc.Director:getInstance():getScheduler()

local function interval(dt)
end

-- The scheduled script callback will be called every 'interval' seconds.
-- If paused is true, then it won't be called until it is resumed.
-- If 'interval' is 0, it will be called every frame.
-- return schedule script entry ID, used for unscheduleScriptFunc().
-- local  pDirector = cc.Director:getInstance()
-- pDirector:getActionManager():resumeTarget(node)
local PauseResumeActions_pauseEntry = scheduler:scheduleScriptFunc(interval, 3, false)
scheduler:unscheduleScriptEntry(PauseResumeActions_pauseEntry)

-------------------------------------
--  Action CallFunc
-------------------------------------
local function startBtnDoneActCallBack( sender, paramTable)
	-- sender 是startBtn
	-- paramTable 是传进来的table 即{12, 15}, 参数可选
end

cc.CallFunc:create(startBtnDoneActCallBack, {12, 15})