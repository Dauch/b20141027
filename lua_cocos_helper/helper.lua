-- show up Layer
function showLayer(layer)
    layer:setVisible(false)
    layer:setPositionY(layer:getPositionY() + 480)
    layer:setScale(0.1, 1)
    layer:setVisible(true)

    layer:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.2, cc.p(0, - 480))
        , cc.ScaleTo:create(0.2, 1, 1)))
end

-- hide up Layer
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