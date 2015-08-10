public abstract class Cocos2dxActivity extends Activity implements Cocos2dxHelperListener {
	
    private static Cocos2dxActivity sContext = null;
	
    public static Context getContext() {
        return sContext;
    }
    
    @Override
    protected void onCreate(final Bundle savedInstanceState) {
		// ...
        sContext = this;
		// ...
        nativeCheckSign(getContext());

        this.mGLContextAttrs = getGLContextAttrs();
		// ...
    }

    private static native boolean nativeCheckSign(Context c);

    //native method,call GLViewImpl::getGLContextAttrs() to get the OpenGL ES context attributions
    private static native int[] getGLContextAttrs();

}
