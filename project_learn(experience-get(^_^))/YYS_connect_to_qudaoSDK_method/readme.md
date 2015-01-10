#解读yys项目组开发的网游《武松打酱油》嵌入渠道sdk的方法
**个人研究，严禁传播**
（说明：本方法根据《武松打酱油》项目解读提取，个人研究，严禁传播，注意，这会非常长）
实现的功能有：
	· 渠道sdk的嵌入与游戏分离，使用代理模式
	· 将配置文件assets/res/platformData.json中，lua与java都读取。
还有其他重要的技术细节，请搜索 \*知识点\* 来查看
	

##Android 工程主要文件结构（只显示分析用到文件）
```
│  AndroidManifest.xml
│
├─assets
│  │─res
│  │   platformData.json
│  └─src
│      └─game  
│          └─sdk
│              │ AndroidSdk.lua
│              │ MySDK.lua
│              │
│              └─platform
│                  sina.lua
└─src
    ├─com
    │   └─baoyugame
    │       └─sdk
    │           │  AbstractPlatformSdk.java
    │           │  IPlatformSdk.java
    │           │  SdkActivity.java
    │           │  SdkFacade.java
    │           │
    │           └─platform
    │               PlatformSdk_sina.java
    └─org
        └─cocos2dx
            ├─lib
            │   ... 其他必要的文件
            └─lua
                AppActivity.java
```
##AndroidManifest.xml Activity
为了能使在启动游戏之前进行渠道sdk初始化的工作，设置在游戏启动之前进入一个空的Activity，需要使用2个Activity。
```xml
<!-- 游戏Activity -->
<activity android:name="org.cocos2dx.lua.AppActivity"
          android:label="@string/app_name"
          android:screenOrientation="landscape"
          android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
          android:configChanges="orientation">
</activity>

<!-- 启动游戏之前进入空的Activity入口，即程序入口Activity，在这个Activity里做一些渠道sdk初始化的工作 -->
<activity android:name="com.baoyugame.sdk.SdkActivity"
          android:label="@string/app_name"
          android:screenOrientation="landscape"
          android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
          android:configChanges="orientation">
     <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
     </intent-filter>
</activity>
```
##JAVA
`SdkActivity.java`
```java
public class SdkActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		SdkFacade.init(this);
		SdkFacade.initSDK();
	}
}
```
`SdkFacade.java`
```java
public class SdkFacade {
public static void init(Activity curActivity) {
	setActivity(curActivity);
	initPlatformData();
}
public static void initSDK() {
	platformSdk.initSDK();
}

// 需要维护使用一个全局的Activity 来做唯一当前活动Activity
private static Activity activity;

/**
 * *知识点*
 
 Log.i(TAG, "current activity:" + activity);
 会打印出来该activity的引用，比如current activity:com.baoyugame.sdk.SdkActivity#214de2  等
 
 */
public static void setActivity(Activity activity) {
	SdkFacade.activity = activity;
	Log.i(TAG, "current activity:" + activity);
}

// 维护一个landscape，供渠道sdk使用
private static boolean landscape = true;
public static boolean isLandscape() { return landscape;	}

// 维护一个platformData，供渠道sdk使用
private static JSONObject platformData;
public static JSONObject getPlatformData() { return platformData; }
/**
 * *知识点*
 * 将在assets/res/platformData.json文件读取到的json解析出来使用，由此获取配置信息
 
 Log.e(TAG, "read platformData.json error!");
 return;
 注意这里的程序的健壮性，能使开发者快速发现是哪里出错了
 无论Log.w，Log.e，Log.d，Log.i 都需要注意一下他们打印
 的信息，非常有用，什么时候用Log.w，什么时候用Log.e和return，
 显示出程序非常的健壮
 
 */

public static void initPlatformData() {
    // platformData.json文件详见下文
	byte[] jsonBytes = readBytes("res/platformData.json");
	if (jsonBytes == null || jsonBytes.length <= 0) {
		Log.e(TAG, "read platformData.json error!");
		return;
	}
	try {
		final JSONObject json = new JSONObject(new String(jsonBytes));
		String id = json.getString("current");
		if (id == null || id.equalsIgnoreCase("none")) {
			Log.w(TAG, "platformData is none!");
			return;
		}
		landscape = json.getBoolean("landscape");
		platformData = json.getJSONObject(id);
		initPlatform(platformData.getString("id"), platformData);
		Log.d(TAG, "get platformData: " + platformData.toString());

		// 友盟
		if (json.has("umeng")) {
			try {
				JSONObject umengJson = json.getJSONObject("umeng");
				String appKey = umengJson.getString("appKey");
				boolean umengDebug = umengJson.getBoolean("debug");
				AnalyticsConfig.setAppkey(appKey);
				AnalyticsConfig.setChannel(id);
				MobclickAgent.setDebugMode(umengDebug);
				Log.i(TAG, "init umeng stat :" + umengJson.toString());
			} catch (Exception e) {
				Log.e(TAG, "init umeng stat error!", e);
			}
		}
	} catch (JSONException e) {
		Log.e(TAG, "parse platformData error!", e);
	}
}

/**
 * *知识点*
 * 读取assets资源到byte数组
 * 
 * @param fileName
 * @return byte数组
 */
public static byte[] readBytes(String fileName) {
	AssetManager assetManager = getActivity().getResources().getAssets();
	InputStream input = null;
	ByteArrayOutputStream output = null;
	byte[] data = new byte[0];
	try {
		input = assetManager.open(fileName);
		output = new ByteArrayOutputStream();
		byte[] buffer = new byte[4096];
		int n = 0;
		while (-1 != (n = input.read(buffer))) {
			output.write(buffer, 0, n);
		}
		data = output.toByteArray();
		buffer = null;
		Log.d(TAG, "readBytes size :" + data.length + ", from " + fileName);
	} catch (Exception e) {
		Log.e(TAG, "readBytes error at file :" + fileName, e);
	} finally {
		if (input != null) {
			try {
				input.close();
			} catch (IOException e) {
			}
			input = null;
		}
		if (output != null) {
			try {
				output.close();
			} catch (IOException e) {
			}
			output = null;
		}
	}
	return data;
}

// 维护一个platformSdkMethods，供调用对应的方法
private static final Map<String, Method> platformSdkMethods = new HashMap<String, Method>();
private static IPlatformSdk platformSdk;

/**
 * *知识点* 将渠道平台代码方法压入一个map和接口实例来维护。
 * 直接操作对应的渠道文件（比如是新浪渠道的话，对应的新浪渠道所需要的代码写在com.baoyugame.sdk.platform.PlatformSdk_sina.java中，详见下文）来将方法写入到一个map中，供lua调用对应的方法。
 
 通过将PlatformSdk_sina.java继承于AbstractPlatformSdk.java(该文件实现IPlatformSdk.java接口并写入一些游戏必要的方法)来实现代码的统一、规范，这样的做法很聪明，而且扩展性很高，在定义platformSdk的时候不用寻找特定的渠道名称(比如新浪的通过将PlatformSdk_sina，而直接IPlatformSdk platformSdk;这样定义就好了)。
 */
private static void initPlatform(String platformId, JSONObject json) {
	try {
		Class<IPlatformSdk> clazz = (Class<IPlatformSdk>) Class
				.forName("com.baoyugame.sdk.platform.PlatformSdk_"
						+ platformId);

		Method[] methods = clazz.getMethods();
		for (Method method : methods) {
			platformSdkMethods.put(method.getName(), method);
		}

		platformSdk = clazz.newInstance();
		Log.d(TAG, "init platform sdk success!");
	} catch (Exception e) {
		Log.e(TAG, "initPlatform error:" + platformId, e);
	}
}
private static void callPlatform(String action, JSONObject params) {
	try {
		Method method = platformSdkMethods.get(action);
		if (method == null) {
			Log.e(TAG, "can't found action:" + action + " for "
					+ platformSdk);
			return;
		}
		if (method.getParameterTypes().length > 0) {
			method.invoke(platformSdk, params);
		} else {
			method.invoke(platformSdk);
		}
		Log.d(TAG, "call platform sdk method success! params:" + params);
	} catch (Exception e) {
		Log.e(TAG, "callPlatform action [" + action + "] error:"
				+ platformSdk, e);
	}
}
// 其他还有类似的方法调用，比如onResume、onKeyDown等等，需要被游戏的Activity调用，一般渠道sdk接入需要这些调用，调用详见下文
public static void onPause() {
	if (platformSdk != null)
		platformSdk.onPause();
}
/**
 * *知识点*
    在lua中传出需要调用的java的方法。使用json格式来在lua与java之间互传数据
    简而言之 AndroidSdk.lua->PlatformSdk_sina.java,下面是啰嗦的解释
    需要在lua文件（比如assets\src\game\sdk\AndroidSdk.lua）中维护一份代码进行封装调用java的方法，与渠道文件（比如PlatformSdk_sina.java）中提供的方法紧密相联，详见下文
 */
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
		String action = json.getString("action");
		JSONObject params = null;
		if (json.has("params")) {
			params = json.getJSONObject("params");
		}
		callPlatform(action, params);
	} catch (Exception e) {
		Log.e(TAG, "call sdk error:", e);
	}
}
/**
 * *知识点*
    在java中传出需要调用的lua的方法。使用json格式来在lua与java之间互传数据
    简而言之 PlatformSdk_sina.java->AndroidSdk.lua,下面是啰嗦的解释
    在渠道文件（比如PlatformSdk_sina.java）中发起调用lua文件提供的方法，在lua文件（比如assets\src\game\sdk\AndroidSdk.lua）中维护一份代码进行封装被调用（或回调），详见下文

 */
public static void callbackToLua(JSONObject json) {
	Log.i(TAG, "start call lua");
	final String strjson = json.toString();
	final String luaFunctionName = "__android_sdk_java2lua";
	int luaFunctionId = Cocos2dxLuaJavaBridge
			.callLuaGlobalFunctionWithString(luaFunctionName, strjson);
	Log.i(TAG, "call to lua:" + strjson);
}
}
```
`platformData.json`文件
```json
{
	"current" : "sina",
	"landscape" : true,
	"umeng" : {
		"appKey" : "547fda90fd98c544fa000375",
		"debug" : false
	},
    "pp" : {
		"id" : "pp",
		"gameId" : 5009
	},
	"sina":{
        "id":"sina",
        "appKey":"3459585058",
        "appSecret":"3fb93722c3aeea72554e8e5460e35103",
        "verifyURL":"http://game.weibo.cn/sso.php"
    }
}
```

接着分析`PlatformSdk_sina.java`
```java
public class PlatformSdk_sina extends AbstractPlatformSdk {
	public enum EventType {
		SdkInitSuccess, SdkNotInit, LoginSuccess, LoginExit,
	}
	@Override
	public void initSDK() {}
	@Override
	public void showLogin(JSONObject json) {
	    // 示例代码：获取platformData.json文件的特定渠道数据节点（sina）
	    // appkey = "3459585058"
	    String appkey = SdkFacade.getPlatformData().getString("appKey")
	    
	    // 示例代码：java调用lua的方法，使用json格式传递过去（已由父类封装过）
        final String token = "1212341241234";
        try {
        	final JSONObject loginResult = new JSONObject();
        	loginResult.put("action", "loginCallback");
        	loginResult.put("eventType",
        			EventType.LoginSuccess.toString());
        	loginResult.put("token", token);
        	loginResult.put("userId", userId);
        	// 调用父类的方法
        	sendToLua(loginResult);
        } catch (Exception e) {
        	Log.e(TAG, "onLoginCallback error!", e);
        }
        
	    // 示例代码：接收由lua发送json格式的数据进行提取（已由父类封装过再调用到这里）
	    // json = {parm1 = "xxx", parm2 = 123, parm3 = true}
	    String parm1 = "";
		int parm2 = 0;
		Boolean parm3 = false;
		try {
			parm1 = json.getString("parm1");
			parm2 = json.getInt("parm2");
			parm3 = json.getBoolean("parm3");
		} catch (Exception e) {
			Log.e(TAG, "decode json error:" + json, e);
		}
	}
	@Override
	public void showPayment(JSONObject json) {}
	@Override
	public void submitPlayer(JSONObject json) {}
	@Override
	public void showToolbar() {}
	@Override
	public void hideToolbar() {}
	@Override
	public void logout() {}
	@Override
	public void accountSwitch() {}
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
		}
		return false;
	}
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
    }
}
```
渠道平台文件`PlatformSdk_sina.java`继承于`AbstractPlatformSdk.java`，该文件进行了一些方法的封装，比如`sendToLua(JSONObject json)`、`getActivity()`、`startGame()`,子类可直接调用。还实现接口文件`IPlatformSdk.java`的一些方法（这些方法体里留空）。这样可使子类`PlatformSdk_sina.java`不需要的方法不用写出来，声明为`abstract`可以不用实现`IPlatformSdk`接口的全部方法
```java
public abstract class AbstractPlatformSdk implements IPlatformSdk {
	
	/**
	 * 发送数据到LUA
	 * 
	 * @param json
	 */
	public void sendToLua(JSONObject json) {
		SdkFacade.callbackToLua(json);
	}
	
	public Activity getActivity() {
		return SdkFacade.getActivity();
	}
	
	/**
	 * *知识点* 启动新的Activity后退出前一个Activity
	 * 启动游戏的Activity（在初始化渠道sdk后必须做的一步），退出刚启动游戏时空的Activity（即com.baoyugame.sdk.SdkActivity）
	 */
	protected void startGame() {
	    // 此处 me 为 com.baoyugame.sdk.SdkActivity
		Activity me = getActivity();
		Intent it = new Intent(me, AppActivity.class);
		// 启动游戏的Activity（即org.cocos2dx.lua.AppActivity），在AppActivity中的onCreate需要重新设置全局唯一活动的Activity，详见下文
		me.startActivity(it);
		// 退出com.baoyugame.sdk.SdkActivity这个Activity
		me.finish();
	}

    // 如果子类没继承则子类不需@Override这个方法，如果子类继承了则子类会无视这个方法，下几个方法类似。
	public boolean onKeyDown(int keyCode, KeyEvent event) {	return false; }
	public void onActivityResult(int requestCode, int resultCode, Intent data) {}
	public void onNewIntent(Intent intent) {}
	public void onPause() {}
	public void onResume() {}
}
```
由`startGame()`发出游戏正式开始信号。
`IPlatformSdk.java`
```java
public interface IPlatformSdk {
	void initSDK();
	void showLogin(JSONObject json);
	void showPayment(JSONObject json);
	void submitPlayer(JSONObject json);
	void showToolbar();
	void hideToolbar();
	void logout();
	void accountSwitch();
	void onActivityResult(int requestCode, int resultCode,
			Intent data);
	void onNewIntent(Intent intent);
	void onPause();
	void onResume();
	boolean onKeyDown(int keyCode, KeyEvent event);
}

```
`AppActivity.java`
```java
public class AppActivity extends Cocos2dxActivity{
    protected void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	// 重新设置全局唯一活动的Activity
    	SdkFacade.setActivity(this);
    }
    
    // 调用 SdkFacade 下的onPause()，一般渠道sdk需要这些接口，要在这里调用才能真正起作用，不然在IPlatformSdk、SdkFacade、PlatformSdk_sina等地方写入代码是没有作用。还有其他接口比如onKeyDown、onResume、onActivityResult等，可根据需求直接先在IPlatformSdk.java定义，这样要求子类必须实现他们。（而且必须在这里调用）
	@Override
	public void onPause(){
		SdkFacade.onPause();
	    super.onPause();
	}
}
```
自此，java方面分析完毕。进入到lua这边。

## LUA
lua提供的功能要有

 - 读取与java共享的platformData.json文件配置信息
 - 接收由java发起的程序调用
 - 提供封装好的由lua调用java的接口

`src\game\sdk\AndroidSdk.lua`文件
```lua
-- *知识点*
-- 在该文件代码使用之前 require "game.sdk.AndroidSdk" 一下
-- 后面就可以用AndroidSdk:getInstance()对该文件里的方法进行调用了
-- AndroidSdk.new()会执行AndroidSdk:__init()进行初始化的工作
-- AndroidSdk被删除的时候会调用AndroidSdk:__delete()进行一些清理的工作
-- ----------------------
AndroidSdk = BaseClass("AndroidSdk")
local sdkInstance = nil

function AndroidSdk:__init()
    self.platformInstance = nil 
end
function AndroidSdk:__delete()
    -- do something
end
function AndroidSdk:getInstance()
    if not sdkInstance then
        sdkInstance = AndroidSdk.new()
    end
    return sdkInstance
end
-- ----------------------

-- *知识点*
-- 维护这2个接口与java进行主要的交互，再在其他的地方对这2个接口进行封装
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

-- *知识点*
-- 提供封装好的由lua调用java的接口
-- 显示SDK登录  （有参数）
-- 全局调用，例如：
-- local params = {parm1 = "xxx", parm2 = 123, parm3 = true}
-- AndroidSdk:getInstance():showLogin(params)
function AndroidSdk:showLogin(params)
    local call_args = {
        action = "showLogin",
        params = params
    }
    __android_sdk_lua2java(call_args)
end

-- 此处发起通用的支付调用，传进来的params = {orderId = orderId,serverId=serverId,money = money,goodsId = goodsId}，如果渠道发起支付需要更多特定信息（比如角色等级，服务器信息等），可在渠道文件（sina.lua）里配置，在其getPaymentInfo()方法里添加更多信息传到java中去调用，详见下文。
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

-- 切换账号  （无参数）
function AndroidSdk:accountSwitch()
    local call_args = {
        action = "accountSwitch",
        params = nil,
    }
    __android_sdk_lua2java(call_args)
end
-- 还有其他类似的需要对java的方法的封装等等，详情所需看IPlatformSdk.java

function AndroidSdk:onCallback(obj)
    print("[AndroidSDK] onCallback: " .. tostring(self.platformInstance) .. "" .. tostring(self.platformInstance.onCallback))
    if self.platformInstance and self.platformInstance.onCallback then
        print("[AndroidSDK] calling callback")
        self.platformInstance.onCallback(obj)
    else
        print("[AndroidSDK] skip callback, platform listener nil!")
    end
end

-- 此方法由MySDK.lua初始化的时候调用
function AndroidSdk:initPlatform(platformId)
    self.platformInstance = require("game.sdk.platform." .. platformId) 
end

```
`MySDK.lua`
```lua
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
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.platformData = nil
    self:loadConfig()
end

-- *知识点*
-- 读取与java共享的platformData.json文件配置信息
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

-- *知识点*
-- 为什么在此处再封装一层？这样可以根据情况发布到android平台、iphone、winphone等，游戏内只关心逻辑就好，调用的话只调用这里，再在这里做特定平台分法事件。
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
```
在游戏开始时进行
```lua
require"src.game.sdk.MySDK"
MySDK:getInstance():initSDK()
```
即初始化了渠道sdk的全部信息。

`game\sdk\platform\sina.lua` 文件
```lua
-- *知识点*
-- 使用一个表来做渠道sdk回调的封装，此处可将渠道特有的信息集中在这个文件中，这样做很聪明：
-- 在登录的时候所需回调写在onCallback里（require("game.sdk.platform.sina").onCallback(obj)）（见上文调用）；
-- 在发起支付的时候添加额外的信息写在getPaymentInfo里（paymentParams = require("game.sdk.platform.sina").getPaymentInfo(params)）（见上文调用）。
local SINASDKListener = {
        -- obj = { action="", eventType = "", params = {} or nil }
        onCallback = function(obj)
            -- *知识点*
            -- 直接把传进来的数据理解成表，因为在调用该方法之前已经将json转换成表了
            if obj.action == "loginCallback" then
                if obj.eventType == "LoginSuccess" then
                    -- *知识点*
                    -- 向服务器发送信息
                    local url = "http://s.sh.baoyugame.com/ssoc/login/sina"
                    local xhr = cc.XMLHttpRequest:new()
                    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
                    -- 服务器验证结果的回调
                    local function onReadyStateChange()
                        local response = xhr.response
                        print("response:" .. response)
                        local output = json.decode(response,1)
                        if output.code ~= 0 then
                            print("token check error:" .. output.msg)
                            return
                        end
                        -- 此处登录验证完毕进入游戏
                    end
                    xhr:registerScriptHandler(onReadyStateChange)
                    xhr:open("POST", url)
                    -- 此处用 & 将信息连接起来发送
                    xhr:send("sid=" .. obj.token .. "&uid=" .. obj.userId)
                elseif obj.eventType == "LoginExit" then
                end
            elseif obj.action == "xxx" then
                -- do something
            end
        end,
        
        -- 提供添加发起支付所需的额外信息的接口
        -- {orderId = orderId,serverId = serverId,money = money,goodsId = goodsId}
        getPaymentInfo = function(paymentInfo)
            -- 添加发起支付所需的额外信息
            paymentInfo.GAME_USER_LV= "18"
            paymentInfo.GAME_USER_PARTY_NAME= "playerName"
            return paymentInfo
        end,
}
return SINASDKListener
```

##结语
以上分析了游戏接入渠道sdk的技术细节。认真总结和分析别人的代码将对自己的技能提升非常大。
以上分析的代码将上传到我的github（一个可执行的项目demo）