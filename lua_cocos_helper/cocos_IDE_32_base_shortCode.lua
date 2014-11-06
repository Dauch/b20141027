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

-------------------------------------
--  CocoStudio GUI sample code
-------------------------------------
local uiLayout = ccs.GUIReader:getInstance():widgetFromJsonFile("ccs_ui/hyy.ExportJson")
local layer = display.newLayer()
layer:addChild(uiLayout)
self:addChild(layer)
local rootSize = uiLayout:getSize()
local root = uiLayout:getChildByName("Panel_6")

local startBtn = ccui.Helper:seekWidgetByName(root, "Button_7")

local function starBtnClicked(sender,eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.ended then
    elseif eventType == ccui.TouchEventType.canceled then
    end
end

startBtn:addTouchEventListener(starBtnClicked)

-------------------------------------
--  CocoStudio Armature sample code
-------------------------------------
ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("ccs_ani/xiaochu/xiaochu.ExportJson")
local armature = ccs.Armature:create("xiaochu")
self:addChild(armature)
armature:getAnimation():play("lvxing")
-- armature:getAnimation():playWithIndex(0)