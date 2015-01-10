require("json")
require("game.sdk.AndroidSdk")

local SINASDKListener = {
    -- obj = { action="", eventType = "", params = {} or nil }
    onCallback = function(obj)
        if obj.action == "loginCallback" then
            if obj.eventType == "LoginSuccess" then

                print("[LUA] decode data from java----------------------------start");
                print("onCallback(obj):obj.parmb1 = " .. tostring(obj.parmb1));
                print("onCallback(obj):obj.parmb2 = " .. tostring(obj.parmb2));
                print("onCallback(obj):obj.parmb3 = " .. tostring(obj.parmb3));
                print("[LUA] decode data from java----------------------------end");

                -- 向服务器发送信息
                local url = "http://s.sh.baoyugame.com/ssoc/login/sina"
                local xhr = cc.XMLHttpRequest:new()
                xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
                -- 服务器验证结果的回调
                local function onReadyStateChange()
                    local response = xhr.response
                    print("response:" .. response)
                    local output = json.decode(response,1)
                    if output.code ~= 0 then
                        print("token check error:" .. output.msg)
                        return
                    end
                    -- 此处登录验证完毕进入游戏
                end
                xhr:registerScriptHandler(onReadyStateChange)
                xhr:open("POST", url)
                -- 此处用 & 将信息连接起来发送
                xhr:send("sid=" .. obj.token .. "&uid=" .. obj.userId)
            elseif obj.eventType == "LoginExit" then
            end
        elseif obj.action == "xxx" then
            -- do something
        end
    end,

    -- {orderId = orderId,serverId = serverId,money = money,goodsId = goodsId}
    getPaymentInfo = function(paymentInfo)
        -- 添加发起支付所需的额外信息
        paymentInfo.GAME_USER_LV= "18"
        paymentInfo.GAME_USER_PARTY_NAME= "playerName"
        return paymentInfo
    end,
}
return SINASDKListener