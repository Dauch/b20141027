-------------------------------------
--  show up Layer
-------------------------------------
function showLayer(layer)
    layer:setVisible(false)
    layer:setPositionY(layer:getPositionY() + 480)
    layer:setScale(0.1, 1)
    layer:setVisible(true)

    layer:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.2, cc.p(0, - 480))
        , cc.ScaleTo:create(0.2, 1, 1)))
end

-------------------------------------
--  hide up Layer
-------------------------------------
function hideLayer(layer)
    local function callback( sender )
        layer:setPositionY(layer:getPositionY() - 480)
        sender:setVisible(false)
    end

    layer:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.2, 0.1, 1)
        , cc.MoveBy:create(0.2, cc.p(0, 480))
        , cc.CallFunc:create(callback)))
end

-------------------------------------
--  print lua table   way 1
-------------------------------------
function print_lua_table (lua_table, indent)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end

-------------------------------------
--  print lua table   way 2
-------------------------------------
function print_t(lua_table)
    local cache = {  [lua_table] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
            else
                table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return table.concat(temp,"\n"..space)
    end
    print("\n" .. _dump(lua_table, "",""))
end
