package com.baoyugame.sdk.platform;

import android.util.Log;
import android.view.KeyEvent;
import com.baoyugame.sdk.AbstractPlatformSdk;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONObject;

public class PlatformSdk_sina extends AbstractPlatformSdk {

	private final static String TAG = "PlatformSdk_sina";


	public enum EventType {
		SdkInitSuccess, SdkNotInit, LoginSuccess, LoginExit,
	}

	@Override
	public void initSDK() {
		Log.d(TAG, "start game");
		startGame();
		Log.d(TAG, "done start game");
	}

	@Override
	public void showLogin(JSONObject json) {
		Log.d(TAG, "[JAVA] decode data from lua----------------------------start");
		// call from lua
		// json = {parm1 = "txt123", parm2 = 123, parm3 = true}
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
		Log.d(TAG, "parm1 = " + parm1);
		Log.d(TAG, "parm2 = " + parm2);
		Log.d(TAG, "parm3 = " + parm3);
		Log.d(TAG, "[JAVA] decode data from lua----------------------------end");

		Log.d(TAG, "[JAVA] send data to lua----------------------------start");
		// call back to lua
		try {
			final JSONObject loginResult = new JSONObject();
			loginResult.put("action", "loginCallback");
			loginResult.put("eventType",
					EventType.LoginSuccess.toString());
			loginResult.put("parmb1", parm1);
			loginResult.put("parmb2", parm2);
			loginResult.put("parmb3", parm3);
			// 调用父类的方法
			sendToLua(loginResult);
		} catch (Exception e) {
			Log.e(TAG, "onLoginCallback error!", e);
		}
		Log.d(TAG, "[JAVA] send data to lua----------------------------end");
	}

	@Override
	public void showPayment(JSONObject json) {
	}

	@Override
	public void submitPlayer(JSONObject json) {
	}

	@Override
	public void showToolbar() {
	}

	@Override
	public void hideToolbar() {
	}

	@Override
	public void logout() {
	}

	@Override
	public void accountSwitch() {
	}

}
