lua&luajit profiler
===
How to use?
=======
1. copy luajitprofiler&profiler floder to your floder
    (e.g.floder like:runtime-src\firework\..)
    
2. in (AppDelegate.cpp  or some where you want to include)
```c++
    
#define USE_PROFILER 1
#ifdef USE_PROFILER
#include "kc_luajit_profile.h"
extern "C"{
#include "kc_lua_profile.h"
}
#endif

bool AppDelegate::applicationDidFinishLaunching()
{
// ...

#ifdef USE_PROFILER
    register_luajit_profile(L);
    register_lua_profile(L);
#endif

// ...
}
```

3. use lua profiler in lua:
```lua
    -- start
    require "lua_profiler"
    lua_profiler.start("d:/de/t/lua_profiler.out")
    -- stop  you must stop, or you will got emty in lua_profiler.out
    -- wanning: this lua_profiler.out will get very big(Mb+)
    lua_profiler.stop()
```
    anylize it :
    int cmd excute:
    
    lua summary.lua -v lprof_123456.out
    
    then copy out the data, change "    " in data to ",", then save as csv file, then you can anylize it.
      
```
lua_profiler
	pause
	resume
	start
	stop
```	
4. use luajit profiler in lua:
```lua
    -- start
    require "luajit_profiler"
    luajit_profiler.start()
    luajit_profiler.dump_to("d:/de/t/luajit_profiler.out")
```
    anylize it :
    change luajit_profiler.out to luajit_profiler.csv , then you can anylize it.
```
luajit_profiler
	start
	stop
	reset
	enable
	disable
	enableNativeProfile
	disableNativeProfile
	dump_to(filename)
	dump
	hook  ( profile.hook(table, name, stat_fn) )
```	
have more fun!
===
