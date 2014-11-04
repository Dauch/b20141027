#在使用lua语言开发游戏里调用android退出对话框

##1.（lua）在scene场景中的ctor


示例

	local IndexScene = class("IndexScene",function()
	    return cc.Scene:create()
	end)
	
	function IndexScene:ctor()
	
	    local function onNodeEvent(event)
	        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	
	        if event == "enter" then
	            if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
	                -- avoid unmeant back
	                self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
	                    -- keypad layer, for android
	                    local layer = cc.Layer:create()
	                    self:addChild(layer)
	
	                    local function onKeyReleased(keyCode, event)
	                        local label = event:getCurrentTarget()
	                        if keyCode == cc.KeyCode.KEY_BACK then
	                            app:callIsExitDialog()
	                        elseif keyCode == cc.KeyCode.KEY_MENU  then
	                        end
	                    end
	                    local listener = cc.EventListenerKeyboard:create()
	                    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
	
	                    local eventDispatcher = layer:getEventDispatcher()
	                    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
	                end)))
	            end
	        end
	    end
	
	    self:registerScriptHandler(onNodeEvent)
	end
	return IndexScene

在MyApp中

	function MyApp:callIsExitDialog()
	    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	
	    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
	        local luaj = require "luaj"
	        local args = {
	            
	        }
	        local sigs = "()V"
	        local className = "org/cocos2dx/lua/AppActivity"
	        luaj.callStaticMethod(className, "callIsExitDialog", args, sigs)
	    end
	end

##2.在android的java文件中

	package org.cocos2dx.lua;
	public class AppActivity extends Cocos2dxActivity
	{
	    public static void callIsExitDialog() {
	        s_instance.runOnUiThread(new Runnable() {
	            @Override
	            public void run() {
	                AlertDialog.Builder builder = new AlertDialog.Builder(s_instance);
	                builder.setTitle("提示");
	                builder.setMessage("确定退出吗");
	                builder.setIcon(android.R.drawable.ic_dialog_info);
	                builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
	
	                    @Override
	                    public void onClick(DialogInterface dialog, int which) {
	                        System.exit(0);
	                    }
	                });
	                builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
	
	                    @Override
	                    public void onClick(DialogInterface dialog, int which) {
	                        dialog.dismiss();
	                    }
	                }).show();
	            }
	        });
	    }
	}