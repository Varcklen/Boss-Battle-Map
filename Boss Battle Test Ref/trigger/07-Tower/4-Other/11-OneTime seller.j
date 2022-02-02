function Trig_OneTime_seller_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSellingUnit()) == 'n031'
endfunction

function Trig_OneTime_seller_Actions takes nothing returns nothing
    call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( GetSellingUnit() ), GetUnitY( GetSellingUnit() ) ))
    call RemoveUnit(GetSellingUnit())
endfunction

//===========================================================================
function InitTrig_OneTime_seller takes nothing returns nothing
    set gg_trg_OneTime_seller = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OneTime_seller, EVENT_PLAYER_UNIT_SELL_ITEM )
    call TriggerAddCondition( gg_trg_OneTime_seller, Condition( function Trig_OneTime_seller_Conditions ) )
    call TriggerAddAction( gg_trg_OneTime_seller, function Trig_OneTime_seller_Actions )
endfunction

