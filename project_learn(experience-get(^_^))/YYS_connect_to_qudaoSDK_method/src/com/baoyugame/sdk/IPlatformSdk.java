package com.baoyugame.sdk;

import org.json.JSONObject;

import android.content.Intent;
import android.view.KeyEvent;

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
