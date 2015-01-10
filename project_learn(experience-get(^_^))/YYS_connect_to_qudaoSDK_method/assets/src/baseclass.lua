function BaseClone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function BaseClass(myName,super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.__init    = function() end
        cls.__cname = myName
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:__init(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {__init = function() end}
        end

        cls.__cname = myName
        cls.__ctype = 2 -- lua
        cls.__index = cls
        cls.__init    = function() end

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:__init(...)
            return instance
        end
    end
    cls.__delete = function() end
    cls.DeleteMe = function(self)
        local now_super = self--self.class_type 
        while now_super ~= nil do   
            if now_super.__delete then
                now_super.__delete(self)
            end
            now_super = now_super.super
        end
    end
    return cls
end