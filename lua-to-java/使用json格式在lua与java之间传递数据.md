#使用json格式在lua与java之间传递数据

## lua -> java
### lua
```lua
__android_sdk_lua2java({
    action = "showPayment",
    params = {orderId = 1,serverId=2}
})

-- 提供lua调用java函数，传递json字符串
function __android_sdk_lua2java(obj)
    print("__android_sdk_lua2java start")
    local className = "com.baoyugame.sdk.SdkFacade"
    local methodName = "callFromLua"
    local strjson = json.encode(obj)
    local args = { strjson }
    local methodSig = "(Ljava/lang/String;)V"
    local retValue = LuaJavaBridge.callStaticMethod(className,methodName,args,methodSig)
    print("__android_sdk_lua2java:" .. tostring(retValue))    -- 如果调用成功打印true
end
```
###java
```java
public static void callFromLua(String strjson) {
	Log.d(TAG, "call from lua: " + strjson);
	JSONObject json = null;
	try {
		json = new JSONObject(strjson);
	} catch (JSONException e) {
		Log.e(TAG, "parse json error: " + strjson, e);
	}
	if (json == null)
		return;
	try {
		String action = json.getString("action");    // action = "showPayment"
		JSONObject params = null;
		if (json.has("params")) {
			params = json.getJSONObject("params");    // params = {orderId = 1,serverId=2}
		}
		// do something 
	} catch (Exception e) {
		Log.e(TAG, "call sdk error:", e);
	}
}
```

## java -> lua
### java
```java
private void ucSdkLogin() {
	try {
		final JSONObject loginResult = new JSONObject();
		loginResult.put("action", "loginCallback");
		callbackToLua(loginResult);
	} catch (Exception e) {
		Log.e(TAG, "onLoginCallback error!", e);
	}
}
public static void callbackToLua(JSONObject json) {
	Log.i(TAG, "start call lua");
	final String strjson = json.toString();
	final String luaFunctionName = "__android_sdk_java2lua";
	int luaFunctionId = Cocos2dxLuaJavaBridge
			.callLuaGlobalFunctionWithString(luaFunctionName, strjson);
	Log.i(TAG, "call to lua:" + strjson);
}
```
### lua
```lua
-- 提供java调用的全局函数，传递json字符串
function __android_sdk_java2lua(strjson)
    print("__android_sdk_java2lua:" .. strjson)
    local obj = json.decode(strjson)
    onCallback(obj)
end

-- obj = { action="loginCallback"}
onCallback = function(obj)
    if obj.action == "loginCallback" then
    end
end

```