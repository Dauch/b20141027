#include "java_commons.h"
#include <android/log.h>

jobject Java_NewObjectWithDefaultConstructor(JNIEnv *env, char *objClassName) {
	
	jobject result = NULL;
	jclass obj_class = Java_FindObjectClass(env, objClassName);
	if (env->ExceptionCheck()) {
	  return NULL;
	}

	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, "<init>", "()V");
		if (mid != NULL) {
			result = env->NewObject( obj_class, mid, NULL);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

jobject Java_NewObjectWithParam(JNIEnv *env, char *objClassName, char *methodType, ...) {

	jobject result = NULL;
	jclass obj_class = Java_FindObjectClass(env, objClassName);
	if (env->ExceptionCheck()) {
	  return NULL;
	}

	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, "<init>", methodType);
		if (mid != NULL) {
		    va_list args;
		    va_start(args, methodType);
			result = env->NewObjectV( obj_class, mid, args);
			va_end(args);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

void* Java_CallObjectMethodWithOneParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, void* param) {

	void* result = NULL;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
			result = Java_CallObjectMethod(env, obj, mid, param);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

void* Java_CallObjectMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName, char *methodType) {
	
	void* result = NULL;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
			result = Java_CallObjectMethod(env, obj, mid);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

void* Java_CallObjectMethodWithParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, ...) {

	void* result = NULL;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
		    va_list args;
		    va_start(args, methodType);
			result = env->CallObjectMethodV( obj, mid, args);
			va_end(args);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

void* Java_CallStaticObjectMethodWithParam(JNIEnv *env, char* className, char *methodName, char *methodType, ...) {

	void* result = NULL;
	jclass obj_class = Java_FindObjectClass(env, className);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetStaticMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
			va_list args;
			va_start(args, methodType);
			result = env->CallStaticObjectMethodV( obj_class, mid, args);
			va_end(args);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

jboolean Java_CallBooleanMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName) {

	jboolean result = JNI_FALSE;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, "()Z");
		if (mid != NULL) {
			result = Java_CallBooleanMethod(env, obj, mid);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

void Java_CallVoidMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName) {

	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, "()V");
		if (mid != NULL) {
			Java_CallVoidMethod(env, obj, mid);
		}
		Java_DeleteLocalRef(env, obj_class);
	}

}

void Java_CallStaticVoidMethodWithParam(JNIEnv *env, char* className, char *methodName, char *methodType, ...) {

	jclass obj_class = Java_FindObjectClass(env, className);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetStaticMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
			va_list args;
			va_start(args, methodType);
			env->CallStaticVoidMethodV( obj_class, mid, args);
			va_end(args);
		}
		Java_DeleteLocalRef(env, obj_class);
	}

}

jint Java_CallIntMethodWithParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, ...) {

	jint result = -1;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jmethodID mid = Java_GetMethodID(env, obj_class, methodName, methodType);
		if (mid != NULL) {
		    va_list args;
		    va_start(args, methodType);
			result = env->CallIntMethodV( obj, mid, args);
			va_end(args);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}

jboolean Java_InstanceOf(JNIEnv *env, jobject obj, char* className) {

	jclass obj_class = Java_FindObjectClass(env, className);
	if (obj_class == NULL) return JNI_FALSE;
	return env->IsInstanceOf( obj, obj_class);

}

jobject Java_GetObjectFieldValue(JNIEnv *env, jobject obj, char *fieldName, char *fieldType) {

	jobject result = NULL;
	jclass obj_class = Java_GetObjectClass(env, obj);
	if (obj_class != NULL) {
		jfieldID fid = Java_GetFieldID(env, obj_class, fieldName, fieldType);
		if (fid != NULL) {
			result = env->GetObjectField( obj, fid);
		}
		Java_DeleteLocalRef(env, obj_class);
	}
	return result;

}