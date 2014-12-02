-- 自己的总结
--===========================================
-- 加载资源
display.addSpriteFramesWithFile(GAME_UI_TEXTURE_DATA_FILENAME, GAME_UI_TEXTURE_IMAGE_FILENAME)
---------------------------------------------

-- 添加一个纯色层
self:addChild(CCLayerColor:create(ccc4(0, 0, 0, 180)))
-- 或
display.newColorLayer(ccc4(255, 255, 255, 255)):addTo(self)
-- 添加一个指定大小的纯色层 100*100
local tColorLayer = CCLayerColor:create(ccc4(255, 0, 0, 100), 100, 100):addTo(self)
tColorLayer:ignoreAnchorPointForPosition(false)
tColorLayer:setAnchorPoint(ccp(0.5, 0.5))
tColorLayer:setPosition(display.cx, display.cy)
-- 添加一个渐变层 注：ccp(0, -1)这个可自己调，调到自己想要的效果
local tColorLayer = CCLayerGradient:create(ccc4(255, 0, 0, 100), ccc4(0, 255, 0, 100), ccp(0, -1)):addTo(self)
-- 其实还可以创建一个 多层布景层：CCLayerMultiplex 的，目前还不知道有什么实际用途
-- 见 http://www.myexception.cn/operating-system/1450644.html

---------------------------------------------

-- 背景图（作为容器）
self.content = display.newSprite("#dialog_bg.png", display.cx, display.cy):addTo(self)
---------------------------------------------


-- 按钮和及其文字：购买按钮及其文字
local bugBtnLabel = nil
local bugBtn = ui.newImageMenuItem({
    image         = "#select_b1.png",
    imageSelected = "#select_b2.png",
    x             = self.content:getContentSize().width/2,
    y             = 70,
    listener      = function()
    	-- TODO
    end
})
bugBtnLabel = ui.newTTFLabel({text = "购买"
    , x = bugBtn:getContentSize().width/2
    , y = bugBtn:getContentSize().height/2+5
    , size = 30, align = ui.TEXT_VALIGN_CENTER})
bugBtn:addChild(bugBtnLabel)

local menu = ui.newMenu({bugBtn})
self.content:addChild(menu)

---------------------------------------------

-- 添加触摸监听事件
touchLayer = display.newLayer()
self:addChild(touchLayer)
local function onTouch(eventType, x, y)
    if eventType == "ended" then
    end
    return true
end
touchLayer:setTouchEnabled(true)
touchLayer:addTouchEventListener(onTouch)

---------------------------------------------

-- 改变精灵图片 注意，2者不同。具体实践看看（TODO）
self.content:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kuang_2.png"))
self.content:self:setTexture(CCTextureCache:sharedTextureCache():addImage("image/player_icon_1.png"))
---------------------------------------------

-- 检测碰撞
self.kuangs[i]:boundingBox():containsPoint(ccp(x,y))
self.player:boundingBox():intersectsRect(self.bullet:boundingBox())

---------------------------------------------

-- 快捷设置
self.views_[self.enemy] = HeroView.new(self.enemy)
    :pos(display.cx + 300, display.cy)
    :flipX(true)
    :addTo(self)

cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
    :setButtonSize(160, 80)
    :setButtonLabel(cc.ui.UILabel.new({text = "fire"}))
    :onButtonPressed(function(event)
        event.target:setScale(1.1)
    end)
    :onButtonRelease(function(event)
        event.target:setScale(1.0)
    end)
    :onButtonClicked(function()
        self:fire(self.player, self.enemy)
    end)
    :pos(display.cx - 300, display.bottom + 100)
    :addTo(self)
---------------------------------------------


-- 图片icon与文字混编可采用这样的方式布局
-- 文字：补充多少金币需要多少钱
local describeTxts = {"补充        700\n只需  5  元", "补充        1500\n只需  10  元", "补充        3200\n只需  20  元"}
local describeTxt = ui.newTTFLabel({text = describeTxts[1],
        x     = w/2,
        y     = h/2 - 40,
        size  = 30,
        align = ui.TEXT_VALIGN_CENTER})
	:addTo(content)
-- 图片：金币Icon (注意是add 在 describeTxt上)
local goldIcon = display.newSprite("#select_coin.png", 90, 60):addTo(describeTxt)
---------------------------------------------


-- 文字对齐
ui.TEXT_ALIGN_LEFT
ui.TEXT_ALIGN_CENTER
ui.TEXT_ALIGN_RIGHT
ui.TEXT_VALIGN_TOP
ui.TEXT_VALIGN_CENTER
ui.TEXT_VALIGN_BOTTOM
---------------------------------------------

-- 动作
:stopAllActions()
CCDelayTime:create(time)
CCFadeIn:create(time)
CCFadeOut:create(time)
CCFadeTo:create(time, opacity)
CCMoveTo:create(time, ccp(x, y))
CCMoveBy:create(time, CCPoint(x or 0, y or 0))
CCRotateTo:create(time, rotation)
CCRotateBy:create(time, rotation)
CCScaleTo:create(time, scale)
CCScaleBy:create(time, scale)
CCSkewTo:create(time, sx, sy)
CCSkewBy:create(time, sx or 0, sy or 0)
CCTintTo:create(time, r or 0, g or 0, b or 0)
CCTintBy:create(time, r or 0, g or 0, b or 0)

CCSequence:create(arrayOfActions)
CCSpawn:create(arrayOfActions)
CCRepeat:create(pAction, times)
CCRepeatForever:create(pAction)
---------------------------------------------

-- 跳动动画
local actions = CCArray:create()
actions:addObject(CCScaleTo:create(1.5, 1, 0.95))
actions:addObject(CCScaleTo:create(1.5, 1, 1.00))
self.items[i]:runAction(CCRepeatForever:create(CCJumpBy:create(3, ccp(0, 0), 5, 1)))
self.items[i]:runAction(CCRepeatForever:create(CCSequence:create(actions)))
---------------------------------------------

-- 延时函数
self:performWithDelay(function()
end, 0.5)

---------------------------------------------

-- 图层事件
self:registerScriptHandler(function(event)
    if event == "enter" then
    elseif event == "enterTransitionFinish" then
    elseif event == "exitTransitionStart" then
    elseif event == "cleanup" then
    elseif event == "exit" then
    end
end)
---------------------------------------------

-- 事件通知
local notifiCent = CCNotificationCenter:sharedNotificationCenter()

local function paySuccedCallback4()
end
notifiCent:registerScriptObserver(self, paySuccedCallback4, "name")

notifiCent:unregisterScriptObserver(self, "name")

---------------------------------------------

--  加载资源
function MainScene:load()

    -- 动画加载适配器
    -- 参数说明：
    -- picNum：图片的数量（动画的帧数）
    -- picNameExcNum：图片的名字，不包括其名字里面的数字和其后缀名
    -- aniIntervalTime：动画每帧间隔时间
    -- storageAniName：存储的动画的名字
    local function loadAniAdapter( picNum, picNameExcNum, aniIntervalTime, storageAniName)
        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        local animFrames = CCArray:createWithCapacity(picNum)
        for i = 1, picNum do
            local frame = cache:spriteFrameByName(picNameExcNum .. i .. ".png")
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, aniIntervalTime)
        display.setAnimationCache(storageAniName, animation)
    end

    -- 飞机打击动画
    loadAniAdapter(3, "airattack_", 0.1, "airattack")

    -- 大礼包动画
    loadAniAdapter(6, "giftblink_", 0.1, "giftpacksicon")
end

---------------------------------------------

-- 信息存储，存到文件中
setToMsg(KEY_LASER_NUM, self.laserValue)
setToMsg(KEY_AIR_NUM, self.airValue)
--  压入信息
function setToMsg(keyValue, tmpValue)
    CCUserDefault:sharedUserDefault():setIntegerForKey(keyValue, tmpValue)
    CCUserDefault:sharedUserDefault():flush()
end
---------------------------------------------


-- 动态添加删除菜单按钮
-- 从self.menu添加该按钮
self.giftPack = ui.newImageMenuItem({
        image    = "#giftpacks_1.png",
        x        = display.right - 100,
        y        = display.top - 150,
        listener = function ()

        end})
    :addTo(self.menu)
-- 从self.menu删除该按钮
self.giftPack:setVisible(false)
self.giftPack:removeFromParentAndCleanup(true)

-- 获取按钮的图片并做动画
self.giftPack:getNormalImage():runAction(CCRepeatForever:create(CCAnimate
    :create(CCAnimationCache:sharedAnimationCache():animationByName("giftpacks"))))
-- 注意这里的getNormalImage()是获取到"#giftpacks_1.png"的图片
-- 对应的还有  getSelectedImage()   getDisabledImage()
-- 参考
--  @since v0.8.0
--  */
-- class CCMenuItemSprite : public CCMenuItem
-- {
--     /** the image used when the item is not selected */
--     CCNode* getNormalImage();
--     void setNormalImage(CCNode* node);

--     /** the image used when the item is selected */
--     CCNode* getSelectedImage();
--     void setSelectedImage(CCNode* node);

--     /** the image used when the item is disabled */
--     CCNode* getDisabledImage();
--     void setDisabledImage(CCNode* node);

--     /** creates a menu item with a normal, selected and disabled image*/
--     static CCMenuItemSprite * create(CCNode* normalSprite, CCNode* selectedSprite, CCNode* disabledSprite = NULL);
-- };

---------------------------------------------

-- repeat 的应用
-- 剔除激光武器
local giftType = math.random(8)
-- while giftType == 3 do
--  giftType = math.random(8)
-- end
-- 这样可确保 giftType ~= 3
repeat
    giftType = math.random(8)
until giftType ~= 3

local function onEnterFrame(dt)
    -- dt 是这一帧和上一帧之间的时间间隔，通常为 1/60 秒
end
node:scheduleUpdate(onEnterFrame)
-- 要取消帧事件：
node:unscheduleUpdate()

---------------------------------------------

-- 遍历子物体
local children = node:getChildren()
local len = children:count()
for i = 0, len-1, 1 do
    -- child 即是子物体
    local  child = tolua.cast(children:objectAtIndex(i), "CCNode")
end
---------------------------------------------


-- 需要存储不同的值，但根据不同的index传进来设置不同的值的时候可以这样做（注意key与value的分布）
local index = self.giftIndex
local addValue = {
    {key = KEY_COIN_NUM, value = 100},
    {key = KEY_COIN_NUM, value = 200},
    {key = KEY_LASER_NUM, value = 10},
    {key = KEY_AIR_NUM, value = 5},
    {key = KEY_LASER_NUM, value = 20},
}
local value = CCUserDefault:sharedUserDefault():getIntegerForKey(addValue[index].key, 0) + addValue[index].value
CCUserDefault:sharedUserDefault():setIntegerForKey(addValue[index].key, value)
CCUserDefault:sharedUserDefault():flush()

---------------------------------------------


-- 创建Scale9Sprite
-- 注意 content_bg.png 不需要特殊编辑过
local contentBg = display.newScale9Sprite("bg/content_bg.png"
    , display.cx, display.cy - 40, CCSizeMake(627, 770)):addTo(self)

---------------------------------------------

---------------------------------------------

-- 替换listener，注意是完全替换，之前写的不生效
items[i] = ui.newImageMenuItem({
    image           = imgName,
    imageSelected = "#dialog_bt2_pressed.png",
    x             = w/2 + (i -1) * 320 - 150,
    y             = 110,
    listener      = function ()
        -- 不生效
         if i == 1 then
             mainScene:again()
         elseif i == 2 then
                contentBg:runAction(CCSequence:createWithTwoActions(
                    CCScaleBy:create(0.25, 0, 1.0),
                    CCCallFunc:create(function ()
                        mainScene:timeDelay()
                        self:removeFromParentAndCleanup(true)
                    end)))
         end
    end})
-- 替换listener，注意是完全替换，之前写的不生效
items[i]:registerScriptTapHandler(function()
    print("i = " .. i)
end)
---------------------------------------------

-- 进入游戏前添加启动页
local mmScene = display.newScene()
display.newSprite("bg/mm_logo_startup.jpg", display.cx, display.cy):addTo(mmScene)
mmScene:runAction(CCSequence:createWithTwoActions(
        CCDelayTime:create(2),
        CCCallFunc:create(function ()
            app:enterIndexScene()
        end)))
display.replaceScene(mmScene, "fade", 0.6, display.COLOR_BLACK)

---------------------------------------------

--2.2.3
-- 注册帧事件处理函数
self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) self:updateFrame(dt) end)
-- 注册帧事件
self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))

-- 可以动态捕获触摸事件，并在捕获触摸事件开始时决定是否接受此次事件
self.parentButton:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
end)
-- 添加触摸事件处理函数
self.sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
end)

---------------------------------------------

local scheduler = CCDirector:sharedDirector():getScheduler()
local function MotionStreakTest1_update(dt)
end
local MotionStreakTest1_entry = nil
if tag == "enter" then
     --[==[The scheduled script callback will be called every 'interval' seconds.
     If paused is YES, then it won't be called until it is resumed.
     If 'interval' is 0, it will be called every frame.
     return schedule script entry ID, used for unscheduleScriptFunc().]==]
    MotionStreakTest1_entry = scheduler:scheduleScriptFunc(MotionStreakTest1_update, 0, false)
elseif tag == "exit" then
    scheduler:unscheduleScriptEntry(MotionStreakTest1_entry)
end

---------------------------------------------
-- 灰度图
display.newGraySprite(iconName, {0.2, 0.3, 0.5, 0.1})
    :pos(50 + 160 + (j - 1)*110, groupBg:getContentSize().height/2 + 2)
    :scale(0.6)
    :addTo(groupBg)

---------------------------------------------
-- 关于boxing
-- 得到的是node本身的boxing，与node子类没任何关系
node:getBoundingBox()
--===========================================



-- 别人的总结
--===========================================
-- 在网上看了一些例子，可能是版本的问题运行时出错，折腾了一下修改一部份代码，发上来做个记录以便日后做参考：

collectgarbage("setpause", 100)    -- 一个垃圾回收函数，详细的自行百度
collectgarbage("setstepmul", 5000)
local frameWidth = 105
local frameHeight = 95

-- 加载到缓存中
CTexture2D *pTexture = CCTextureCache::sharedTextureCache()->addImage(szFilename);
local textureDog = CCTextureCache:sharedTextureCache():addImage("dog.png")
-- 显示区域
CCRectMake(0, 0, frameWidth, frameHeight)

-- sprite 操作 CCSprite是一副2D图像,CCSprite可以通过图像或者图像中的一个矩形子区域创建
-- 1.通过纹理来创建
local texture1 = CCTextureCache:sharedTextureCache():addImage("dog.png")
local spriteTest = CCSprite:createWithTexture(texture1, CCRectMake(0, 0, frameWidth, frameHeight))
-- 2.通过路径创建
local spriteTest = CCSprite:create("dog.png")
local spriteTest = CCSprite:create("dog.png",CCRectMake(0, 0, frameWidth, frameHeight))
-- 3.帧创建
local texture1 = CCTextureCache:sharedTextureCache():addImage("dog.png")
local frame1 = CCSpriteFrame:createWithTexture(texture1, CCRectMake(0, 0, frameWidth, frameHeight))
local spriteTest = CCSprite:createWithSpriteFrame(frame1)

-- 4.载入贴图集
cache = CCSpriteFrameCache:sharedSpriteFrameCache()
cache:addSpriteFramesWithFile("Info.plist")
--生成Sprite
local spriteTest = CCSprite:createWithSpriteFrameName("1.png")
--需要更换图片时
local frame2 = cache:spriteFrameByName("2.png")
spriteTest:setDisplayFrame(frame2)

-- 5.创建动画 如跑步动作
local textureDog = CCTextureCache:sharedTextureCache():addImage("dog.png")
-- 创建帧并加入数组
local frame0 = CCSpriteFrame:createWithTexture(textureDog, CCRectMake(0, 0, frameWidth, frameHeight))
local frame1 = CCSpriteFrame:createWithTexture(textureDog, CCRectMake(frameWidth, 0, frameWidth, frameHeight))
local animFrames = CCArray:create()
animFrames:addObject(frame0)
animFrames:addObject(frame1)
-- 加入动画数据 0.5秒
local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.5)
-- 创建动画动作
local animate = CCAnimate:create(animation)
-- 释放图片数组
animFrames:release()
-- 播放动画
local spriteDog = CCSprite:create()
-- 重复播放
spriteDog:runAction(CCRepeatForever:create(animate))
-- 有次数播放 10次
spriteDog:runAction(CCRepeat:create(animate, 10))
-- 暂停动画
spriteDog.isPaused = true

-- sprite加载完了就改各类应用了。
-- 1,锚点
-- 锚点就是所有扭转,移动,缩放的参考点。cocos2-x中默认的锚点是中间点。
-- 锚点用比例来默示局限为0-1,(0,0)点代表左下点,(1,1)代表右上点。设置的函数为
setAnchorPoint(ccp(0.5, 0.5));

-- 2,扭转
setRotation(angle) -- 此中angle为角度不是弧度。正数为顺时针扭转,负数为逆时针扭转。

-- 3,位置
setPosition(ccp(xPos, yPos)) -- xPos和yPos为相对于父节点锚点的位置。

-- 4,缩放
setScale(s); --  整体缩放
setScaleX(s); -- 原图片坐标X轴缩放
setScaleY(s); -- 原图片坐标Y轴缩放
-- s为比例,s = 1默示原尺寸。

-- 5,倾斜
setSkewX(s); -- 原图片坐标X轴倾斜
setSkewY(s); -- 原图片坐标Y轴倾斜
-- X轴向右为正,Y轴向上为正。

-- 6,透明度
setOpacity(s);
-- s局限0-255,0完全透明,255完全不透明。

-- 7,可见
setIsVisible(bVisible)
-- bVisible为bool值true代表可见false代表不成见
-- 最后,初始化完成后,不要忘了应用addChild参加到父节点,不然是不会显示的

spriteTest:setPosition(200,100)
-- 层
local layerFarm = CCLayer:create()
layerFarm:addChild(spriteTest)
-- 场景
local sceneGame = CCScene:create()
sceneGame:addChild(layerFarm)
-- 场景切换
CCDirector:sharedDirector():runWithScene(sceneGame)



--===========================================

-- 加密
--===========================================
// load framework
pStack->loadChunksFromZip("res/framework_precompiled.zip");
pStack->loadChunksFromZip("res/game.zip");
pStack->executeString("require 'main'");

-- 支付
--===========================================
public static native void paymentCompleted(final int id);

void Java_mobi_shoumeng_smfootball_Smfootball_paymentCompleted(JNIEnv*  env, jobject thiz, jint id)
{
    CCNotificationCenter::sharedNotificationCenter()->postNotification(
        CCString::createWithFormat("pay%d", id)->getCString(), NULL);
}

function MyApp:pay(id)
    if device.platform == "mac" or device.platform == "windows" then
        CCNotificationCenter:sharedNotificationCenter():postNotification(id, nil);
    elseif device.platform == "android" then
        local javaClassName = "mobi.shoumeng.newrun.Newrun"
        local javaMethodName = "sendString"
        local javaParams = {
           id
        }
        local javaMethodSig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        -- luaoc.callStaticMethod("AppController", "sendString", { content = id})
    end
end

-- 付费模块简化
-- 调用部分
app:pay("pay7")

-- 回调部分
local function paySuccessCallback(id)
    self:performWithDelay(function()
        if id == "pay7" then
        end
    end, 0.5)
end
local notifiCent = CCNotificationCenter:sharedNotificationCenter()
self:registerScriptHandler( function(event)
    if event == "enterTransitionFinish" then
        notifiCent:registerScriptObserver(self, paySuccessCallback, "pay7")
    elseif event == "exitTransitionStart" then
        notifiCent:removeAllObservers(self)
    end
end )

-- 用到cocos2d的坐标转换，一般两种情况：
-- 1）从当前坐标点获取世界坐标点(屏幕坐标点，opengl的坐标系)
-- 2）从当前坐标点获取相对于某个CCNode的坐标点；
-- 第一种情况，直接用:nodeParent->convertToWorldSpace(node->getPosition());
-- 这里一定是需要转换坐标对象的父类调用convertToWorldSpace,参数是对象的坐标点(相对于父类的坐标点)；
-- 返回的是屏幕坐标点；
-- 第二种情况，直接用:node2->convertToNodeSpace(node1->getPosition);
-- node2并不是node1的父类，现在的情况就是:node1想得到相对于node2坐标系的坐标点；
-- 返回的是相对于node2坐标系的坐标点。
-- 以上的调用，是没有考虑nodeParent和node2的anchorPoint的(就是使用了0,0的锚点)；考虑到锚点就使用：
-- convertToWorldSpaceAR()和convertToNodeSpaceAR();具体含义了？
-- nodeParent->convertToWorldSpaceAR(node->getPosition()):因为默认是0,0的锚点，
-- 所以其得到的坐标点是ccpAdd(nodeParent->convertToWorldSpace(node->getPosition()),ccp(nodeParent->getContentSize.width*0.5,nodeParent->getContentSize.height*0.5))
-- node2->convertToNodeSpaceAR(node1->getPosition):因为默认是0,0的锚点，
-- 所以其得到的坐标点是ccpSub(nodeParent->convertToWorldSpace(node->getPosition()),ccp(node2->getContentSize.width*0.5,node2->getContentSize.height*0.5))
-- -------------
-- 以下已测
-- 本地坐标转世界坐标
local pos = node:getParent():convertToWorldSpace(
    cc.p(node:getPositionX()
        , node:getPositionY()))
local x = pos.x
local y = pos.y
print("node x = " .. x .. " y = " .. y )
