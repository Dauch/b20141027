extern "C"{
#include "tolua_fix.h"
#include "kc_lua_profile.h"
#include "lua_profiler.h"

TOLUA_API int register_lua_profile(lua_State* L)
{
	luaopen_profiler(L);
	return 1;
}
}