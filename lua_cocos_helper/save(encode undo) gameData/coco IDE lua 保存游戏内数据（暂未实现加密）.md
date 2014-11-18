# coco IDE lua 保存游戏内数据（暂未实现加密）
1.初始化
```lua
-- Myapp.lua
GameState = require "GameState"

-- 初始化全局保存的数据表，让其成为全局函数
function MyApp:ctor()
    self.GameData = {}
    -- init GameState
    GameState.init(function(param)
        local returnValue=nil
        if param.errorCode then
            print("error")
        else
            -- crypto
            if param.name == "save" then
                local str = json.encode(param.values)
                str = crypto.encryptXXTEA(str, "abcd")
                returnValue = {data = str}
            elseif param.name=="load" then
                local str = crypto.decryptXXTEA(param.values.data, "abcd")
                returnValue = json.decode(str)
            end
            -- returnValue=param.values
        end
        return returnValue
    end)
    local t = {}
    if io.exists(GameState.getGameStatePath()) then
        t = GameState.load()
    else
        -- 让其使用文本格式存贮，使用数字出错，原因未知。
        t.curScore = "0"
        t.startCells = {}
    end

    self.GameData.curScore = tonumber(t.curScore)
    self.GameData.startCells = totable(t.startCells)

    GameState.save(t)
end

-- helper.lua
function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.exists(path)
    return cc.FileUtils:getInstance():isFileExist(path)
end

function save()
    local t = {}

    t.curScore = tostring(app.GameData.curScore)
    t.startCells = totable(app.GameData.startCells)

    GameState.save(t)
end
```
2.使用
```lua
    app.GameData.curScore = 0
    app.GameData.startCells = {}
```
3.保存
```lua
    save()
```

附录：
见文件夹下 
GameState.lua 
crypto.lua (实现加密，暂未起作用)
json.lua（已经封装好在引擎里面了）