lua get string md5
===
How to use?
========
1. copy md5 floder to your floder
    (e.g.floder like:runtime-src\firework\..)
    
2. in (AppDelegate.cpp  or some where you want to include)
```c++

extern "C"{
#include "md5/kc_lua_md5.h"
}

bool AppDelegate::applicationDidFinishLaunching()
{
// ...

    register_lua_md5(L)

// ...
}
```

3. use it to calculate md5 in lua:
```lua
	local function sumhexa (k)
		local md5 = require "md5"
		local k = md5.sum(k)
		return (string.gsub(k, ".", function (c)
			return string.format("%02x", string.byte(c))
		end))
	end
	local stringMd5 = sumhexa("moneny=" .. 123)
	print(stringMd5)	-- 94fb55b9f58c3da24a89b4ccd2e1c5d7
```

```
md5
	sum
	exor
	crypt
	decrypt
```	

if needed, you can also open des56 in this floder
```
--(you must open it in ldes56.cpp, refer to kc_lua_md5.cpp and kc_lua_md5.h)
des56
	crypt
	decrypt
```

have more fun!
===
