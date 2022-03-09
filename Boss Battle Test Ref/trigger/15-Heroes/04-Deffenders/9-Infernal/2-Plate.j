function Trig_Plate_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0G8' 
endfunction

function Trig_Plate_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()

    if GetUnitAbilityLevel(u, 'A1A5') > 0 then
        call platest(u, 1 )
        call healst( u, null, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.05 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( GetManipulatedItem() ), GetItemY( GetManipulatedItem() ) ) )
    else
        set bj_lastCreatedItem = CreateItem('I0G8', GetItemX( GetManipulatedItem() ), GetItemY( GetManipulatedItem() ))
    endif

    set u = null
endfunction

//===========================================================================
function InitTrig_Plate takes nothing returns nothing
    set gg_trg_Plate = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Plate, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_Plate, Condition( function Trig_Plate_Conditions ) )
    call TriggerAddAction( gg_trg_Plate, function Trig_Plate_Actions )
endfunction

