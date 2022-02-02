function Trig_Marine8_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n04N' and GetUnitLifePercent(udg_DamageEventTarget) <= 20
endfunction

function Trig_Marine8_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u

    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "kaBOOM!", bj_TIMETYPE_SET, 3, false )
    call GroupEnumUnitsInRange( g, GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 800, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, udg_DamageEventTarget, "enemy" ) then
            call dummyspawn( udg_DamageEventTarget, 1, 'A0RJ', 0, 0 )
            call IssueTargetOrder( bj_lastCreatedUnit, "thunderbolt", u )
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Marine8 takes nothing returns nothing
    set gg_trg_Marine8 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Marine8 )
    call TriggerRegisterVariableEvent( gg_trg_Marine8, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Marine8, Condition( function Trig_Marine8_Conditions ) )
    call TriggerAddAction( gg_trg_Marine8, function Trig_Marine8_Actions )
endfunction

