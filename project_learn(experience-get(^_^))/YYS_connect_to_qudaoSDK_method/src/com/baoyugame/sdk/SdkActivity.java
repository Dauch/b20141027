package com.baoyugame.sdk;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;
import org.cocos2dx.lua.AppActivity;

public class SdkActivity extends Activity {

	protected static final String TAG = "SdkActivity_YYS";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		SdkFacade.init(this);
		if (SdkFacade.isLandscape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		SdkFacade.initSDK();
	}
}
