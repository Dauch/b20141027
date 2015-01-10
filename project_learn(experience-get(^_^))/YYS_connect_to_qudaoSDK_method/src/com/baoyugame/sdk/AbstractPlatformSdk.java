package com.baoyugame.sdk;

import android.util.Log;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.view.KeyEvent;

/**
 * 继承这个类实现各个平台SDK功能调用
 * 
 * @author Tony
 * 
 */
public abstract class AbstractPlatformSdk implements IPlatformSdk {

	private static final String TAG = "AbstractPlatformSdk";

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
	 * 启动游戏
	 */
	protected void startGame() {
		Activity me = getActivity();
		Intent it = new Intent(me, AppActivity.class);
		me.startActivity(it);
		me.finish();
	}

	public boolean onKeyDown(int keyCode, KeyEvent event) {
		return false;
	}

	public void onActivityResult(int requestCode, int resultCode, Intent data) {
	}

	public void onNewIntent(Intent intent) {
	}

	public void onPause() {
	}

	public void onResume() {
	}
}
