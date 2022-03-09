function Trig_Mehanic5_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n012'
endfunction

function Trig_Mehanic5_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
    call dummyspawn( GetDyingUnit(), 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetDyingUnit(), "enemy" )  then
            call UnitDamageTarget( bj_lastCreatedUnit, u, 300, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Mehanic5 takes nothing returns nothing
    set gg_trg_Mehanic5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Mehanic5 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mehanic5, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Mehanic5, Condition( function Trig_Mehanic5_Conditions ) )
    call TriggerAddAction( gg_trg_Mehanic5, function Trig_Mehanic5_Actions )
endfunction

