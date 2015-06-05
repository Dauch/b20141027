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

/* 示例1：简单获取lua的全局变量 */
void HelloLua::demo1() {
    lua_State* pL = lua_open();
    luaopen_base(pL);
    luaopen_math(pL);
    luaopen_string(pL);

    /* 执行Lua脚本,返回0代表成功 */
    int err = luaL_dofile(pL, "helloLua.lua");
    CCLOG("open : %d", err);

    /* 重置栈顶索引 */
    lua_settop(pL, 0);
    lua_getglobal(pL, "myName");

    /* 判断栈顶的值的类型是否为String, 返回非0值代表成功 */
    int isstr = lua_isstring(pL, 1);
    CCLOG("isstr = %d", isstr);

    /* 获取栈顶的值 */
    const char* str = lua_tostring(pL, 1);
    CCLOG("getStr = %s", str);

    /* 清除字符串 */
    lua_pop(pL, 1);

    lua_close(pL);
}

/* 示例2：获取lua table的数据 */
void HelloLua::demo2() {
    /* 初始化 */
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* 执行脚本 */
    luaL_dofile(pL, "helloLua.lua");

    /* 取得table变量，在栈顶 */
    lua_getglobal(pL, "helloTable");

    /* 将C++的字符串放到Lua的栈中，此时，栈顶变为“name”， helloTable对象变为栈底 */
    lua_pushstring(pL, "name");

    /* 
        从table对象寻找“name”对应的值（table对象现在在索引为-2的栈中，也就是当前的栈底）,
        取得对应值之后，将值放回栈顶
    */
    lua_gettable(pL, -2);

    /* 现在表的name对应的值已经在栈顶了，直接取出即可 */
    const char* sName = lua_tostring(pL, -1);
    CCLOG("name = %s", sName);
}

/* C++调用lua的函数 */
void HelloLua::demo3() {
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* 执行脚本 */
    luaL_dofile(pL, "helloLua.lua");

    /* 把helloAdd函数对象放到栈中 */
    lua_getglobal(pL, "helloAdd");

    /* 把函数所需要的参数入栈 */
    lua_pushnumber(pL, 10);
    lua_pushnumber(pL, 5);

    /* 
        执行函数，第一个参数表示函数的参数个数，第二个参数表示函数返回值个数 ，
        Lua会先去堆栈取出参数，然后再取出函数对象，开始执行函数
    */
    lua_call(pL, 2, 1);

    int iResult = lua_tonumber(pL, -1);
    CCLOG("iResult = %d", iResult);
}

/* Lua调用C++的函数 */
void HelloLua::demo4() {
    lua_State* pL = lua_open();
    luaopen_base(pL);

    /* C++的函数和封装函数都必须是静态的，不知道可不可以不是静态的？当然不可以！ */
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
    /* 从栈顶中取一个值 */
    int num = (int)lua_tonumber(pL, 1);

    /* 调用getNumber函数，将返回值入栈 */
    lua_pushnumber(pL, getNumber(num));

    /* 返回值个数，getNumber只有一个返回值，所以返回1 */
    return 1;
}
