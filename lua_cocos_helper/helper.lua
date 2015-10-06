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

-------------------------------------
--  change Sprite Texture
-------------------------------------
local sp = cc.Sprite:create("ui/battle/little_game/CG_1.png")
if not isSuccess then
    sp:setTexture("ui/battle/little_game/sb.png")
end

-------------------------------------
--  Swallow all Touches
-------------------------------------
local function setSwallowTouches(layer)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(_,__) return true end,cc.Handler.EVENT_TOUCH_BEGAN)
    layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer)
end

local layer = cc.Layer:create()
layer:setTag(1002)
setSwallowTouches(layer)

-------------------------------------
--  tag use
-------------------------------------
-- set
local runScene = gDirector:getRunningScene()
local layer = cc.Layer:create()
layer:setTag(1002)
runScene:addChild(layer)

-- get
local runScene = gDirector:getRunningScene()
local layer = runScene:getChildByTag(1002)

-------------------------------------
--  set a sprite gray
-------------------------------------

-- function ~
local function shaderForSprite(spNode,EffectType)
    local fileUtils = cc.FileUtils:getInstance()
    if EffectType == "Gray" then
        local p = cc.GLProgram:createWithByteArrays(fileUtils:getStringFromFile("shader/default.vsh"), fileUtils:getStringFromFile("shader/gray.fsh"))
        local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
        spNode:setGLProgramState(status)
    elseif EffectType == "None" then
        local p = cc.GLProgram:createWithByteArrays(fileUtils:getStringFromFile("shader/default.vsh"), fileUtils:getStringFromFile("shader/default.fsh"))
        local status = cc.GLProgramState:getOrCreateWithGLProgram(p)
        spNode:setGLProgramState(status)
    end
end

-------
-- file shader/default.vsh
--[[
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

void main()
{
    gl_Position = CC_PMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
}
--]]
-------
-- file shader/default.fsh
--[[
#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
    vec4 v_orColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
    gl_FragColor = v_orColor;
}
--]]
-------
-- file shader/gray.fsh
--[[
#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
    vec4 v_orColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
    float gray = dot(v_orColor.rgb, vec3(0.299, 0.587, 0.114));
    gl_FragColor = vec4(gray, gray, gray, v_orColor.a);
}
--]]

-- how to use? 

local sp = cc.Sprite:create("ui/shop/scjmBG_new.png")
-- set it gray 
shaderForSprite(sp, "Gray")
-- set it back normal 
shaderForSprite(sp, "None")


-------------------------------------
--  add a child with an action and use the backgrayround or not(option)
-------------------------------------
-- notices: *new know point*
-- cc.TargetedAction:create can be use the action to the target node
-- cc.Show:create is an action that setVisible(true) {aka.}(cc.Hide:create is opposite)
local function addChildWithAction(childNode,parentNode,hasBackground)
    if not childNode or not parentNode then
        return
    end
    parentNode:addChild(childNode)
    local background,showBackground
    if hasBackground then
        background = cc.LayerColor:create(cc.c4b(25, 25, 25, 200))
        background:setVisible(false)
        childNode:addChild(background,-1)
    end
    childNode:setScale(0)
    local bigAction = cc.ScaleTo:create(0.15,1.25)
    local smallAction = cc.ScaleTo:create(0.1,1.0)
    if hasBackground then
        showBackground = cc.TargetedAction:create(background,cc.Show:create())
    end
    childNode:runAction(cc.Sequence:create(bigAction,smallAction,showBackground))
end


-------------------------------------
--  pairs of registerScriptHandler and unregisterScriptHandler
-------------------------------------
-- target may be a layer
target:registerScriptHandler(function(event) 
    if "enter" == event then
        -- do something
        target:unregisterScriptHandler()
    end
end)

-------------------------------------
--  change a node's parent to another
-------------------------------------
local tips = cc.Sprite:create("ui/shop/scjmBG_new.png")
oldParentLayer:addChild(tips)

tips:retain()
tips:removeFromParent()

newParentLayer:addChild(tips)

-------------------------------------
--  newbie need a guide, play a ani and hightlight the targetBtn, make other area couldn't click
-------------------------------------
GuideBase = class("GuideBase", function()
    return cc.Layer:create()
end)

function GuideBase:onClicked(touch, event)
    if type(self.cbClick)~="function" then return end
    -- "if self.cbClick(self, touch, event) then" is option
    if self.cbClick(self, touch, event) then
        self:removeAllChildren()
        self:setVisible(false)
        -- other handle...
    end
end

-- this target is button, and cbClick is a callback that the button click
function GuideBase:doShow(target, cbClick)
    self.target  = target
    self.cbClick = cbClick
    if not target then
        return
    end

    if not self:getParent() then
        gDirector:getRunningScene():addChild(self)
    end
    self:removeAllChildren()
    self:setVisible(true)

    local box = self.target:getBoundingBox()
    local tp  = self.target:getParent()
    local wp1 = tp:convertToWorldSpace({x=box.x,y=box.y})
    local wp2 = tp:convertToWorldSpace({x=box.x+box.width,y=box.y+box.height})

    local areaInWorld = {
        x = wp1.x,
        y = wp1.y,
        width  = wp2.x - wp1.x,
        height = wp2.y - wp1.y
    }
    self.areaInWorld = areaInWorld

    local tm = 0.3
    local acting = true

    local mask1 = cc.LayerColor:create(cc.c4b(50,50,50,200), areaInWorld.x, VR.visibleSize.height)
    mask1:ignoreAnchorPointForPosition(false)
    mask1:setAnchorPoint(0, 0)
    mask1:setPosition(0, 0)
    self:addChild(mask1)
    mask1:setPositionX(mask1:getPositionX()-mask1:getContentSize().width)
    mask1:runAction(cc.MoveBy:create(tm, cc.p(mask1:getContentSize().width,0)))

    local mask2 = cc.LayerColor:create(cc.c4b(50,50,50,200), VR.visibleSize.width-areaInWorld.x-areaInWorld.width, VR.visibleSize.height)
    mask2:ignoreAnchorPointForPosition(false)
    mask2:setAnchorPoint(1, 0)
    mask2:setPosition(VR.visibleSize.width, 0)
    self:addChild(mask2)
    mask2:setPositionX(mask2:getPositionX()+mask2:getContentSize().width)
    mask2:runAction(cc.MoveBy:create(tm, cc.p(-mask2:getContentSize().width,0)))

    local mask3 = cc.LayerColor:create(cc.c4b(50,50,50,200), areaInWorld.width, VR.visibleSize.height-areaInWorld.y-areaInWorld.height)
    mask3:ignoreAnchorPointForPosition(false)
    mask3:setAnchorPoint(0, 0)
    mask3:setPosition(areaInWorld.x, areaInWorld.y+areaInWorld.height)
    self:addChild(mask3)
    local x,y = mask3:getPosition()
    mask3:setPosition(0, VR.visibleSize.height)
    mask3:runAction(cc.MoveBy:create(tm, cc.p(x,y-VR.visibleSize.height)))
    mask3:setScale(VR.visibleSize.width/mask3:getContentSize().width)
    mask3:runAction(cc.ScaleTo:create(tm, 1))

    local mask4 = cc.LayerColor:create(cc.c4b(50,50,50,200), areaInWorld.width, areaInWorld.y)
    mask4:ignoreAnchorPointForPosition(false)
    mask4:setAnchorPoint(0, 1)
    mask4:setPosition(areaInWorld.x, areaInWorld.y)
    self:addChild(mask4)
    local sz  = mask4:getContentSize()
    local x,y = mask4:getPosition()
    mask4:setPosition(0, 0)
    mask4:runAction(cc.MoveBy:create(tm, cc.p(x, y)))
    mask4:setScale(VR.visibleSize.width/mask4:getContentSize().width)
    mask4:runAction(cc.Sequence:create(
        cc.ScaleTo:create(tm, 1),
        cc.CallFunc:create(function()
            self:onShowComplete()
            acting = false
        end)
    ))

    -- 仅目标区域可接受点击
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch, event)
        local p = touch:getLocation()
        if acting or not (p.x>=areaInWorld.x and p.x<(areaInWorld.x+areaInWorld.width) and p.y>=areaInWorld.y and p.y<(areaInWorld.y+areaInWorld.height) ) then
            -- notices: *new know point* stopPropagation,is stop propagation the event forward.
            event:stopPropagation()
        else
            self:onClicked(touch, event)
        end
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():removeEventListenersForTarget(self)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

-------------------------------------
--  *new know point*  (CCNode.h)setPosition in a new way.
-------------------------------------
--[[
/** Sets the position (x,y) using values between 0 and 1.
 The positions in pixels is calculated like the following:
 @code
 // pseudo code
 void setNormalizedPosition(Vec2 pos) {
   Size s = getParent()->getContentSize();
   _position = pos * s;
 }
 @endcode
 *
 * @param position The normalized position (x,y) of the node, using value between 0 and 1.
 */
virtual void setNormalizedPosition(const Vec2 &position);
--]]


-------------------------------------
--  *new know point*  (CCNode.h)getPosition in a new way (through anchorpint).
-------------------------------------
--[[
/**
 * Returns the anchorPoint in absolute pixels.
 *
 * @warning You can only read it. If you wish to modify it, use anchorPoint instead.
 * @see `getAnchorPoint()`
 *
 * @return The anchor point in absolute pixels.
 */
virtual const Vec2& getAnchorPointInPoints() const;
--]]

-------------------------------------
--  *new know point*  (CCNode.h)addChild getChild in a new way (through custom name).
-------------------------------------
--[[
/**
 * Adds a child to the container with z order and name
 *
 * If the child is added to a 'running' node, then 'onEnter' and 'onEnterTransitionDidFinish' will be called immediately.
 *
 * @param child     A child node.
 * @param localZOrder    Z order for drawing priority. Please refer to `setLocalZOrder(int)`.
 * @param name      A string to identify the node easily. Please refer to `setName(const std::string&)`.
 *
 */
virtual void addChild(Node* child, int localZOrder, const std::string &name);
/** Changes the name that is used to identify the node easily.
 * @param name A string that identifies the node.
 *
 * @since v3.2
 */
virtual void setName(const std::string& name);
/**
 * Gets a child from the container with its name.
 *
 * @param name   An identifier to find the child node.
 *
 * @return a Node object whose name equals to the input parameter.
 *
 * @since v3.2
 */
virtual Node* getChildByName(const std::string& name) const;
--]]
