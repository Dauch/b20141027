#include "HelloLua.h"

CCScene* HelloLua::scene() {
    CCScene* scene = CCScene::create();

    CCLayer* layer = HelloLua::create();

    scene->addChild(layer);

    return scene;
}

bool HelloLua::init() {
    demo4();
    return true;
}

/* ʾ��1���򵥻�ȡlua��ȫ�ֱ��� */
void HelloLua::demo1() {
    lua_State* pL = lua_open();
    luaopen_base(pL);
    luaopen_math(pL);
    luaopen_string(pL);

    /* ִ��Lua�ű�,����0����ɹ� */
    int err = luaL_dofile(pL, "helloLua.lua");
    CCLOG("open : %d", err);

    /* ����ջ������ */
    lua_settop(pL, 0);
    lua_getglobal(pL, "myName");

    /* �ж�ջ����ֵ�������Ƿ�ΪString, ���ط�0ֵ����ɹ� */
    int isstr = lua_isstring(pL, 1);
    CCLOG("isstr = %d", isstr);

    /* ��ȡջ����ֵ */
    const char* str = lua_tostring(pL, 1);
    CCLOG("getStr = %s", str);

    /* ����ַ��� */
    lua_pop(pL, 1);

    lua_close(pL);
}

/* ʾ��2����ȡlua table������ */
void HelloLua::demo2() {
    /* ��ʼ�� */
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* ִ�нű� */
    luaL_dofile(pL, "helloLua.lua");

    /* ȡ��table��������ջ�� */
    lua_getglobal(pL, "helloTable");

    /* ��C++���ַ����ŵ�Lua��ջ�У���ʱ��ջ����Ϊ��name���� helloTable�����Ϊջ�� */
    lua_pushstring(pL, "name");

    /* 
        ��table����Ѱ�ҡ�name����Ӧ��ֵ��table��������������Ϊ-2��ջ�У�Ҳ���ǵ�ǰ��ջ�ף�,
        ȡ�ö�Ӧֵ֮�󣬽�ֵ�Ż�ջ��
    */
    lua_gettable(pL, -2);

    /* ���ڱ��name��Ӧ��ֵ�Ѿ���ջ���ˣ�ֱ��ȡ������ */
    const char* sName = lua_tostring(pL, -1);
    CCLOG("name = %s", sName);
}

/* C++����lua�ĺ��� */
void HelloLua::demo3() {
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* ִ�нű� */
    luaL_dofile(pL, "helloLua.lua");

    /* ��helloAdd��������ŵ�ջ�� */
    lua_getglobal(pL, "helloAdd");

    /* �Ѻ�������Ҫ�Ĳ�����ջ */
    lua_pushnumber(pL, 10);
    lua_pushnumber(pL, 5);

    /* 
        ִ�к�������һ��������ʾ�����Ĳ����������ڶ���������ʾ��������ֵ���� ��
        Lua����ȥ��ջȡ��������Ȼ����ȡ���������󣬿�ʼִ�к���
    */
    lua_call(pL, 2, 1);

    int iResult = lua_tonumber(pL, -1);
    CCLOG("iResult = %d", iResult);
}

/* Lua����C++�ĺ��� */
void HelloLua::demo4() {
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* C++�ĺ����ͷ�װ�����������Ǿ�̬�ģ���֪���ɲ����Բ��Ǿ�̬�ģ���Ȼ�����ԣ� */
    lua_register(pL, "cpp_GetNumber", cpp_GetNumber);

    luaL_dofile(pL, "helloLua.lua");

    lua_close(pL);

}

void HelloLua::demo5() {

}

int HelloLua::getNumber( int num ) {
    CCLOG("getNumber num = %d", num);
    return num + 1;
}

int HelloLua::cpp_GetNumber( lua_State* pL ) {
    /* ��ջ����ȡһ��ֵ */
    int num = (int)lua_tonumber(pL, 1);

    /* ����getNumber������������ֵ��ջ */
    lua_pushnumber(pL, getNumber(num));

    /* ����ֵ������getNumberֻ��һ������ֵ�����Է���1 */
    return 1;
}
