package com.baoyugame.sdk;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import com.umeng.analytics.AnalyticsConfig;
import com.umeng.analytics.MobclickAgent;

import android.app.Activity;
import android.content.Intent;
import android.content.res.AssetManager;
import android.util.Log;
import android.view.KeyEvent;

/**
 * SDK调用入口
 * 
 * @author Tony
 * 
 */
public class SdkFacade {

	private static final String TAG = "SdkFacade";

	private static Activity activity;

	private static IPlatformSdk platformSdk;

	private static JSONObject platformData;

	private static boolean anySdk = false;

	private static boolean landscape = true;

	public static boolean isAnySdk() {
		return anySdk;
	}

	public static Activity getActivity() {
		return activity;
	}

	public static void init(Activity curActivity) {
		setActivity(curActivity);
		initPlatformData();
	}

	public static void initPlatformData() {
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

	public static void initSDK() {

		platformSdk.initSDK();
	}

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

	private static final Map<String, Method> platformSdkMethods = new HashMap<String, Method>();

	@SuppressWarnings("unchecked")
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

	public static void callbackToLua(JSONObject json) {
		Log.i(TAG, "start call lua");
		final String strjson = json.toString();
		final String luaFunctionName = "__android_sdk_java2lua";
		Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString(luaFunctionName, strjson);
		Log.i(TAG, "call to lua:" + strjson);
	}

	public static void onActivityResult(int requestCode, int resultCode,
			Intent data) {
		if (platformSdk != null)
			platformSdk.onActivityResult(requestCode, resultCode, data);
	}

	public static void onNewIntent(Intent intent) {
		if (platformSdk != null)
			platformSdk.onNewIntent(intent);
	}

	public static void onPause() {
		if (platformSdk != null)
			platformSdk.onPause();
	}

	public static void onResume() {
		if (platformSdk != null)
			platformSdk.onResume();
	}

	public static boolean onKeyDown(int keyCode, KeyEvent event) {
		if (platformSdk != null)
			return platformSdk.onKeyDown(keyCode, event);
		return false;
	}

	public static void setActivity(Activity activity) {
		SdkFacade.activity = activity;
		Log.i(TAG, "current activity:" + activity);
	}

	/**
	 * 读取assets资源到byte数组
	 * 
	 * @param fileName 文件名
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

	public static JSONObject getPlatformData() {
		return platformData;
	}

	public static boolean isLandscape() {
		return landscape;
	}

	public static void setLandscape(boolean landscape) {
		SdkFacade.landscape = landscape;
	}

}
