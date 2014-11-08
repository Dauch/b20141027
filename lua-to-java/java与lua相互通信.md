#java与lua相互通信
##1. 全局调用
###java->lua
java 代码
```java
-- 调用
context.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("FUN_acceptData", "x" + " = " +100);
            }
});
```
lua 代码
```lua
-- 接收 加一个前缀FUN_(便于识别全局函数)
function FUN_acceptData(str)
    for k, v in string.gmatch(str, "(%w+) = (%w+)") do
        if k == "x" then
            CUR_TOUCH_X = tonumber(v) or 0
        elseif k == "y" then
            CUR_TOUCH_Y = tonumber(v) or 0
        end
    end
end
```


----------


###lua->java
lua 代码
```lua
-- 调用
app:sendToJava("xxx")

function MyApp:sendToJava(content)
    if device.platform == "android" then
        local javaClassName = "org.cocos2dx.lua.AppActivity"
        local javaMethodName = "sendToJava"
        local javaParams = {
            content
        }
        local javaMethodSig = "(Ljava/lang/String;)V"
        LuaJavaBridge.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
end
```
java 代码
```java
-- 接收
package org.cocos2dx.lua;
public class AppActivity{
    static public void sendToJava(final String content) {
        context.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(TAG, content);
            }
        });
    }
}
```

##2. 局部调用
lua->java
```lua

function MyApp:buy(payID, funID)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "luaj"
        local args = {
            payID, funID
        }
        local sigs = "(Ljava/lang/String;I)V"
        local className = "org/cocos2dx/lua/AppActivity"
        luaj.callStaticMethod(className, "buy", args, sigs)
    end
end

-- 回调
local function buyCallBack(result)
    if result == "pay_1" then
    end
end
app:buy("pay_1", buyCallBack)
```
java->lua
```java
package org.cocos2dx.lua;
public class AppActivity{
    static int luaCallBack = 0;
    // 从lua中接受发起的支付请求
    public static void buy(final String content,  final int luaFunctionId) {
        luaCallBack = luaFunctionId;
        s_instance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pay(content)
            }
        });
    }
    // 支付成功回调
    private static void pay(final String content) {
        s_instance.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaCallBack, content);                               
                Cocos2dxLuaJavaBridge.releaseLuaFunction(luaCallBack);
            }
        });
    }
}
}
```