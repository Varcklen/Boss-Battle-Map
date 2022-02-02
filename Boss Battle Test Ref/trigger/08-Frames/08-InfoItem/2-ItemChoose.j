function Trig_ItemChoose_Conditions takes nothing returns boolean
    return not(udg_fightmod[0]) and not(udg_fightmod[3])// and not(BlzFrameIsVisible(bgfrgfon[1]))
endfunction

function Trig_ItemChoose_Actions takes nothing returns nothing
    local real x = BlzGetTriggerPlayerMouseX()
    local real y = BlzGetTriggerPlayerMouseY()
	local integer k
    local string text
    local item itemtarget = RandomItemInRectSimpleBJ(RectFromCenterSizeBJ(Location(x, y), 200, 200))

    if itemtarget != null and GetItemType(itemtarget) != ITEM_TYPE_POWERUP then
        set text = BlzGetItemDescription(itemtarget)
        set k = StringLength(text)
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible(unitfon, false)
            call BlzFrameSetVisible(itemfon, true)
            call BlzFrameSetTexture( itemicon, BlzGetItemIconPath(itemtarget), 0, true )
            call BlzFrameSetText( itemname, GetItemName(itemtarget) )
            call BlzFrameSetAbsPoint(itemfon, FRAMEPOINT_TOP, 0.125, 0.55-bnspos)
    
            call BlzFrameSetText( itemtool, text )
            call BlzFrameSetSize(itemfon, 0.25, 0.08+(0.0003*k))
            call BlzFrameSetSize(itemtool, 0.23, 0.02+(0.0003*k))
        endif
    else
        if GetLocalPlayer() == GetTriggerPlayer() then
            call BlzFrameSetVisible(itemfon, false)
        endif
    endif
    
    set itemtarget = null
endfunction

function InitTrig_ItemChoose takes nothing returns nothing
    local integer i = 0
    set gg_trg_ItemChoose = CreateTrigger(  )
    loop
        exitwhen i > 3
        //call TriggerRegisterPlayerMouseEventBJ( gg_trg_ItemChoose, Player(i), bj_MOUSEEVENTTYPE_UP )
        call TriggerRegisterPlayerEvent(gg_trg_ItemChoose, Player(i), EVENT_PLAYER_MOUSE_UP)
        set i = i + 1
    endloop
    call TriggerAddCondition( gg_trg_ItemChoose, Condition( function Trig_ItemChoose_Conditions ) )
    call TriggerAddAction( gg_trg_ItemChoose, function Trig_ItemChoose_Actions )
endfunction

