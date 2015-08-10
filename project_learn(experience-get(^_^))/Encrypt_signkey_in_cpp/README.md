encrypt sign key in cpp (cocos2dx)
=========

防止反编译apk包之后再打包时使用别的签名，若使用别的签名则闪退不能进行游戏

修改jni/hellolua/main.cpp文件，要在src/org/cocos2dx/lib/Cocos2dxActivity.java 文件做入口校验。