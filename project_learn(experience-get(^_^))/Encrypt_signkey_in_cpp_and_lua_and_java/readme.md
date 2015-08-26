1. 将Classes文件夹里的文件复制到自己工程的Classes里， 在proj.android\jni\Android.mk 里
	LOCAL_SRC_FILES := \ 的下面
		// 注意是以下2行
		../../Classes/java_commons.cpp  \
		../../Classes/checkSign.cpp \

2. java中，在 org.cocos2dx.lib.Cocos2dxActivity 中 添加
    public static void handleCheckSignKeyId() {
        nativeCheckSign(getContext());
    }
    public static native boolean nativeCheckSign(Context c);
	
3. lua中，在main.lua 中 添加

local signCheckSuccess = false

local signList = {
    "tSNsfmbSNMXmuG7gIENg9iv+u3I=",
    "KHCDmgt/5fRAHq0yutteSRaAkf0",
    "ARgxM8ESmcGQED0pYv36XsMbV8I=",
    "EQrzxnjAFAjsgi3RKUztzMBitm0=",
}
function checkSign(sign)
    for i, k in ipairs(signList) do
        if k == sign then
            signCheckSuccess = true
            return
        end
    end
    signCheckSuccess = false
end

local main()
	-- ....
	
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        signCheckSuccess = true
    elseif cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
		local className = "org.cocos2dx.lib.Cocos2dxActivity"
		local methodName = "handleCheckSignKeyId"
		local args = {}
		local methodSig = "()V"
		LuaJavaBridge.callStaticMethod(className, methodName, args, methodSig)
    end
    local sc
    sc = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if signCheckSuccess then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(sc)
            -- 开始游戏
            -- 进入游戏代码
        end
    end, 1/60, false)
end
