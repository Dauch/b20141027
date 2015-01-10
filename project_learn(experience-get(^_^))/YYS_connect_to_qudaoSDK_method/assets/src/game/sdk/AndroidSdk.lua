require("json")
AndroidSdk = BaseClass("AndroidSdk")

local sdkInstance = nil

function AndroidSdk:__init()
    self.platformInstance = nil 
end

function AndroidSdk:getInstance()
    if not sdkInstance then
        sdkInstance = AndroidSdk.new()
    end
    return sdkInstance
end

function AndroidSdk:initPlatform(platformId)
    self.platformInstance = require("game.sdk.platform." .. platformId) 
end

-- 显示SDK登录
function AndroidSdk:showLogin(params)
    local call_args = {
        action = "showLogin",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 显示SDK支付
function AndroidSdk:showPayment(params)
    local paymentParams = params;
    if self.platformInstance and self.platformInstance.getPaymentInfo then
        print("[AndroidSDK] calling getPaymentInfo")
        paymentParams = self.platformInstance.getPaymentInfo(params)
    else
        print("[AndroidSDK] open payment use default params!")
    end
    local call_args = {
        action = "showPayment",
        params = paymentParams
    }
    __android_sdk_lua2java(call_args)
end

-- 主动退出账号
function AndroidSdk:logout(params)
    local call_args = {
        action = "logout",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 显示浮动图标
function AndroidSdk:showToolbar(params)
    local call_args = {
        action = "showToolbar",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 隐藏浮动图标
function AndroidSdk:hideToolbar(params)
    local call_args = {
        action = "hideToolbar",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 打开账号中心
function AndroidSdk:enterPlatform(params)
    local call_args = {
        action = "enterPlatform",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 切换账号
function AndroidSdk:accountSwitch()
    local call_args = {
        action = "accountSwitch",
        params = nil,
    }
    __android_sdk_lua2java(call_args)
end

-- 调用充值
function AndroidSdk:showPayment(params)
    local call_args = {
        action = "showPayment",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

function AndroidSdk:onCallback(obj)
    print("[AndroidSDK] onCallback: " .. tostring(self.platformInstance) .. "" .. tostring(self.platformInstance.onCallback))
    if self.platformInstance and self.platformInstance.onCallback then
        print("[AndroidSDK] calling callback")
        self.platformInstance.onCallback(obj)
    else
        print("[AndroidSDK] skip callback, platform listener nil!")
    end
end

-- 提供lua调用java函数，传递json字符串
function __android_sdk_lua2java(obj)
    print("__android_sdk_lua2java start")
    local className = "com.baoyugame.sdk.SdkFacade"
    local methodName = "callFromLua"
    local strjson = json.encode(obj,1)
    local args = { strjson }
    local methodSig = "(Ljava/lang/String;)V"
    local retValue = LuaJavaBridge.callStaticMethod(className,methodName,args,methodSig)
    print("__android_sdk_lua2java:" .. tostring(retValue))
end

-- 提供java调用的全局函数，传递json字符串
function __android_sdk_java2lua(strjson)
    print("__android_sdk_java2lua:" .. strjson)
    local obj = json.decode(strjson,1)
    AndroidSdk:getInstance():onCallback(obj)
end