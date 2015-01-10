
local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
    return scene
end


function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    print("GameScene:ctor() : Enter the GameScene")
    -- lua -> java
    print("[LUA] send data to java----------------------------start");
    local params = {parm1 = "txt123", parm2 = 123, parm3 = true}
    MySDK:getInstance():showLoginUI(params)
    print("[LUA] send data to java----------------------------end");
end

return GameScene
