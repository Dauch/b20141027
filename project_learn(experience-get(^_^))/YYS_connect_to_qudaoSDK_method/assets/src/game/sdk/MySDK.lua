require "game.sdk.AndroidSdk"
MySDK = BaseClass("MySDK")

local sdkManager = nil

function MySDK:getInstance()
    if not sdkManager then
        sdkManager = MySDK.new()
    end
    return sdkManager
end

function MySDK:__init()
    print("MySDK:__init()")
    self.platformData = nil
    self:loadConfig()
end

function MySDK:__delete()
    print("MySDK:__delete()")
end

function MySDK:loadConfig()
    local filepath = "res/platformData.json"
    if cc.FileUtils:getInstance():isFileExist(filepath) then
        local platformStrjson = cc.FileUtils:getInstance():getStringFromFile(filepath)
        local platformDatas = json.decode(platformStrjson,1)
        self.platformData = platformDatas[platformDatas.current]
    end
end

-- 取得平台配置数据
function MySDK:getPlatformData()
    return self.platformData
end

function MySDK:initSDK()
    if self:isAndroid() then
        local platformId = self:getPlatformData().id;
        AndroidSdk:getInstance():initPlatform(platformId)
    end
end

function MySDK:isAndroid()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == targetPlatform then
        return true
    end
    return false
end

--调用login
function MySDK:showLoginUI(params)
    if self:isAndroid() then
        AndroidSdk:getInstance():showLogin(params)
    end
end

function MySDK:submitPlayer()
    if self:isAndroid() then
        AndroidSdk:getInstance():submitPlayer()
    end
end

function MySDK:showPayment()
    if self:isAndroid() then
        local params = {orderId = "213124",serverId="123442",money = 10,goodsId = 12344}
        AndroidSdk:getInstance():showPayment(params)
    end
end

function MySDK:logout()
    if self:isAndroid() then
        AndroidSdk:getInstance():logout()
    end
end

function MySDK:showToolBar()
    if self:isAndroid() then
        AndroidSdk:getInstance():showToolbar()
    end
end

function MySDK:hideToolBar()
    if self:isAndroid() then
        AndroidSdk:getInstance():hideToolbar()
    end
end

--enter platform center
function MySDK:enterPlatform()
    if self:isAndroid() then
        AndroidSdk:getInstance():enterPlatform()
    end
end

--实名注册
function MySDK:realNameRegister()
    if self:isAndroid() then
        AndroidSdk:getInstance():realNameRegister()
    end
end

--切换用户
function MySDK:accountSwitch()
    if self:isAndroid() then
        AndroidSdk:getInstance():accountSwitch()
    end
end