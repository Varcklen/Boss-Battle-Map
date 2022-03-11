function Trig_ItemChoise_Conditions takes nothing returns boolean
   local integer cyclA = 1
    local boolean l = false
    
    loop
        exitwhen cyclA > 12
        if GetManipulatedItem() == udg_item[cyclA] then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function AfterItemChoise takes player p returns nothing
    local integer i = GetPlayerId(p) + 1
    local integer k = 0
    local integer cyclA

    set cyclA = 0
    loop
        exitwhen cyclA > 2
        if udg_item[( 3 * i ) - cyclA] == null then
            set k = k + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    set udg_ItemGetChoosed[i] = true
    if GetLocalPlayer() == p then
        call BlzFrameSetVisible( refbk,false)
    endif
    if k >= 3 then
        set udg_ItemGetActive[i] = false
        if GetLocalPlayer() == p then
        	call BlzFrameSetVisible( sklbk,false)
            if udg_Heroes_Amount > 1 and udg_number[69 + i] > 0 then 
                call BlzFrameSetVisible( pvpbk,true)
            endif
        endif
    endif
    
    set p = null
endfunction

function Trig_ItemChoise_Actions takes nothing returns nothing
    local player p = GetOwningPlayer(GetManipulatingUnit())
    local integer i = GetPlayerId(p) + 1
    local integer cyclA
    local integer j

    if GetManipulatedItem() == udg_item[( 3 * i ) - 2] or GetManipulatedItem() == udg_item[( 3 * i ) - 1] or GetManipulatedItem() == udg_item[3 * i] then
        set cyclA = 0
        loop
            exitwhen cyclA > 2
            set j = ( 3 * i ) - cyclA
            if GetManipulatedItem() != udg_item[j] and (inv( udg_hero[i], 'I0D2' ) == 0 or GetItemTypeId(GetManipulatedItem()) == 'I0D2') then
                call DestroyEffect( AddSpecialEffectLoc( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", Location(GetItemX(udg_item[j]), GetItemY(udg_item[j])) ) )
                call RemoveItem( udg_item[j] )
                set udg_item[j] = null
            elseif GetManipulatedItem() == udg_item[j] then
                set udg_item[j] = null
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    call AfterItemChoise(p)
    
    set p = null
endfunction

//===========================================================================
function InitTrig_ItemChoise takes nothing returns nothing
    set gg_trg_ItemChoise = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ItemChoise, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_ItemChoise, Condition( function Trig_ItemChoise_Conditions ) )
    call TriggerAddAction( gg_trg_ItemChoise, function Trig_ItemChoise_Actions )
endfunction