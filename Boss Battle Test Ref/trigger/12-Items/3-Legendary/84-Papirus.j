function Trig_Papirus_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0C0'
endfunction

function Trig_Papirus_Actions takes nothing returns nothing
    local integer cyclA = 1
    
    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null then
            call SetHeroLevel( udg_hero[cyclA], GetHeroLevel(udg_hero[cyclA]) + 3, true )
        endif
        set cyclA = cyclA + 1
    endloop
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Papirus takes nothing returns nothing
    set gg_trg_Papirus = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Papirus, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Papirus, Condition( function Trig_Papirus_Conditions ) )
    call TriggerAddAction( gg_trg_Papirus, function Trig_Papirus_Actions )
endfunction

