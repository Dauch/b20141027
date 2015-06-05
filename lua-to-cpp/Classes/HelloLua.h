/* 
   �ļ�����    HelloLua.h 
   �衡����    Lua Demo
   �����ˣ�    ��ľͷ (CSDN���ͣ�http://blog.csdn.net/musicvs) 

   �������ڣ�   2012.12.24 
*/  

#ifndef __HELLO_LUA_H_
#define __HELLO_LUA_H_

#include "cocos2d.h"

extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
};

using namespace cocos2d;

class HelloLua : public CCLayer {
public:
    CREATE_FUNC(HelloLua);
    virtual bool init();

    static CCScene* scene();

private:
    void demo1();
    void demo2();
    void demo3();
    void demo4();
    void demo5();

public:
    static int getNumber(int num);
    static int cpp_GetNumber(lua_State* pL);
};

#endif