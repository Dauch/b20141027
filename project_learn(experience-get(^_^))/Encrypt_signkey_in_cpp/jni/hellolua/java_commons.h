#ifndef __JAVA_COMMONS_H
#define __JAVA_COMMONS_H

#include <stdlib.h>
#include <jni.h>

#define JAVA_TYPE_LIST(OP)               \
    OP(jobject,     Object)              \
    OP(jboolean,    Boolean)             \
    OP(jbyte,       Byte)                \
    OP(jchar,       Char)                \
    OP(jshort,      Short)               \
    OP(jint,        Int)                 \
    OP(jlong,       Long)                \
    OP(jfloat,      Float)               \
    OP(jdouble,     Double)              \
    OP(void,        Void)


#define Java_NewStringUTF(env, str) (str == NULL) ? NULL : env->NewStringUTF(str)
#define Java_GetStringUTFChars(env, str) (str == NULL) ? NULL : env->GetStringUTFChars(str, 0);
#define Java_ReleaseStringUTFChars(env, str, c) env->ReleaseStringUTFChars(str, c);

#define Java_DeleteLocalRef(env, obj) env->DeleteLocalRef(obj)

#define Java_NewByteArray(env, len) env->NewByteArray(len)
#define Java_GetArrayLength(env, arr) env->GetArrayLength(arr)
#define Java_GetByteArrayElements(env, arr, p) env->GetByteArrayElements(arr, p)
#define Java_ReleaseByteArrayElements(env, p1, p2, p3) env->ReleaseByteArrayElements(p1, p2, p3)

#define Java_FindObjectClass(env, className) env->FindClass(className)
#define Java_GetObjectClass(env, obj) env->GetObjectClass(obj)
#define Java_GetMethodID(env, objclass, methodName, methodType) env->GetMethodID(objclass, methodName, methodType)
#define Java_GetStaticMethodID(env, objclass, methodName, methodType) env->GetStaticMethodID(objclass, methodName, methodType)
#define Java_GetFieldID(env, objclass, fieldName, fieldType) env->GetFieldID(objclass, fieldName, fieldType)
#define Java_GetStaticFieldID(env, objclass, fieldName, fieldType) env->GetStaticFieldID(objclass, fieldName, fieldType)

#define Java_CallObjectMethod(env, obj, ...) env->CallObjectMethod(obj, __VA_ARGS__)
#define Java_CallStaticObjectMethod(env, obj, ...) env->CallStaticObjectMethod(obj, __VA_ARGS__)
#define Java_CallBooleanMethod(env, obj, ...) env->CallBooleanMethod(obj, __VA_ARGS__)
#define Java_CallByteMethod(env, obj, ...) env->CallByteMethod(obj, __VA_ARGS__)
#define Java_CallCharMethod(env, obj, ...) env->CallCharMethod(obj, __VA_ARGS__)
#define Java_CallShortMethod(env, obj, ...) env->CallShortMethod(obj, __VA_ARGS__)
#define Java_CallIntMethod(env, obj, ...) env->CallIntMethod(obj, __VA_ARGS__)
#define Java_CallLongMethod(env, obj, ...) env->CallLongMethod(obj, __VA_ARGS__)
#define Java_CallFloatMethod(env, obj, ...) env->CallFloatMethod(obj, __VA_ARGS__)
#define Java_CallDoubleMethod(env, obj, ...) env->CallDoubleMethod(obj, __VA_ARGS__)
#define Java_CallVoidMethod(env, obj, ...) env->CallVoidMethod(obj, __VA_ARGS__)
#define Java_CallStaticVoidMethod(env, obj, ...) env->CallStaticVoidMethod(obj, __VA_ARGS__)

#define Java_NewGlobalRef(evn, obj) env->NewGlobalRef(obj);
#define Java_DeleteGlobalRef(evn, obj) env->DeleteGlobalRef(obj);

jboolean Java_InstanceOf(JNIEnv *env, jobject obj, char* className);

jobject Java_NewObjectWithDefaultConstructor(JNIEnv *env, char *objClassName);
jobject Java_NewObjectWithParam(JNIEnv *env, char *objClassName, char *methodType, ...);

void* Java_CallObjectMethodWithOneParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, void* param);
void* Java_CallObjectMethodWithParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, ...);
void* Java_CallStaticObjectMethodWithParam(JNIEnv *env, char* className, char *methodName, char *methodType, ...);
void* Java_CallObjectMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName, char *methodType);
void Java_CallVoidMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName);
void Java_CallStaticVoidMethodWithParam(JNIEnv *env, char* className, char *methodName, char *methodType, ...);
jint Java_CallIntMethodWithParam(JNIEnv *env, jobject obj, char *methodName, char *methodType, ...);
jboolean Java_CallBooleanMethodWithoutParam(JNIEnv *env, jobject obj, char *methodName);

jobject Java_GetObjectFieldValue(JNIEnv *env, jobject obj, char *fieldName, char *fieldType);

#endif /* __JAVA_COMMONS_H */
