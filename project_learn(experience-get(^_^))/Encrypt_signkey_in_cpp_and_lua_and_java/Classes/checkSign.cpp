#include "CCLuaEngine.h"
#include "cocos2d.h"

#include "java_commons.h"

USING_NS_CC;
using namespace std;

void nativeCheckSign(JNIEnv * env, jclass clazz, jobject object);

#if __cplusplus
extern "C" {
#endif
#include <lualib.h>
#include <lauxlib.h>

    JNIEXPORT void JNICALL Java_org_cocos2dx_lib_Cocos2dxActivity_nativeCheckSign(JNIEnv * env, jclass clazz, jobject object)
    {
        nativeCheckSign(env, clazz, object);
    }

#if __cplusplus
}
#endif

void string_replace(std::string &s1,const std::string &s2,const std::string &s3)
{
    std::string::size_type pos=0;
    std::string::size_type a=s2.size();
    std::string::size_type b=s3.size();
    while((pos=s1.find(s2,pos)) != std::string::npos)
    {
        s1.replace(pos,a,s3);
        pos+=b;
    }
}

void nativeCheckSign(JNIEnv * env, jclass clazz, jobject object) {
	// 注意：这是模拟以下java代码, 获取包的签名, 得到的result，即是下面C++代码的result_1
	/*
	String result = "";
	PackageInfo info = getGameActivity().getPackageManager().getPackageInfo(
			getGameActivity().getPackageName(), PackageManager.GET_SIGNATURES);
	for (Signature signature : info.signatures) {
		MessageDigest md = MessageDigest.getInstance("SHA");
		md.update(signature.toByteArray());
		result = Base64.encodeToString(md.digest(), Base64.DEFAULT);
		result = result.replaceAll(" ", "");
		result = result.replaceAll("\n", "");
		return result;
	}
	*/

    if (object == NULL) return;
    if (Java_InstanceOf(env, object, "android/content/Context") == JNI_FALSE) return;

    jobject context = (jobject)Java_CallObjectMethodWithoutParam(env, object, "getApplicationContext", "()Landroid/content/Context;");

    jobject package_manager = (jobject)Java_CallObjectMethodWithoutParam(env, context, "getPackageManager", "()Landroid/content/pm/PackageManager;");
    if (package_manager == NULL) return;

    jstring package_name = (jstring)Java_CallObjectMethodWithoutParam(env, context, "getPackageName", "()Ljava/lang/String;");

    jobject package_info = (jobject)Java_CallObjectMethodWithParam(env, package_manager, "getPackageInfo", "(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;", package_name, 64);
    if (package_info == NULL) return;


    jstring type = (jstring)Java_NewStringUTF(env,"SHA");
    jobjectArray signatures = (jobjectArray)Java_GetObjectFieldValue(env, package_info, "signatures", "[Landroid/content/pm/Signature;");
    if (signatures != NULL) {
        jobject signature = (jobject)env->GetObjectArrayElement(signatures, 0);
        if (signature != NULL) {
            jbyteArray signature_byte_array = (jbyteArray)Java_CallObjectMethodWithoutParam(env, signature, "toByteArray", "()[B");
            if (signature_byte_array != NULL) {
                jobject md = (jobject)Java_CallStaticObjectMethodWithParam(env, "java/security/MessageDigest", "getInstance", "(Ljava/lang/String;)Ljava/security/MessageDigest;", type);
                if (md != NULL) {
                    jclass class_MessageDigest = env->FindClass("java/security/MessageDigest");
                    jmethodID tem_method = env->GetMethodID(class_MessageDigest, "update", "([B)V");
                    env->CallVoidMethod(md, tem_method, signature_byte_array);

                    jbyteArray md_digest = (jbyteArray)Java_CallObjectMethodWithoutParam(env, md, "digest", "()[B");
                    if (md_digest != NULL) {
                        jstring result = (jstring)Java_CallStaticObjectMethodWithParam(env, "android/util/Base64", "encodeToString", "([BI)Ljava/lang/String;", md_digest, 0);
                        if (result != NULL) {
                            std::string result_1 = Java_GetStringUTFChars(env, result);
                            string_replace(result_1, " ", "");
                            string_replace(result_1, "\n", "");       

                            lua_State* L = LuaEngine::getInstance()->getLuaStack()->getLuaState();
                            
                            lua_getglobal(L, "checkSign");
                            lua_pushstring(L, result_1.c_str());
                            lua_pcall(L, 1, 0, 0);

                            Java_DeleteLocalRef(env, result);
                        }
                        Java_DeleteLocalRef(env, md_digest);
                    }
                    Java_DeleteLocalRef(env, class_MessageDigest);
                    Java_DeleteLocalRef(env, md);
                }
                Java_DeleteLocalRef(env, signature_byte_array);
            }
            Java_DeleteLocalRef(env, signature);
        }
        Java_DeleteLocalRef(env, signatures);
    }

    Java_DeleteLocalRef(env, type);
    Java_DeleteLocalRef(env, package_info);
    Java_DeleteLocalRef(env, package_name);
    Java_DeleteLocalRef(env, package_manager);
    Java_DeleteLocalRef(env, context);
}