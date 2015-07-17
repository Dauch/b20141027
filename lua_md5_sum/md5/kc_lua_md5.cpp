extern "C"{
#include "tolua_fix.h"
#include "kc_lua_md5.h"
#include "md5.h"

TOLUA_API int register_lua_md5(lua_State* L)
{
	luaopen_md5_core(L);
	return 1;
}
}