globals
    unit heuz = null
endglobals

function Trig_Heuz1_Conditions takes nothing returns boolean
    return heuz != null and GetUnitState( heuz, UNIT_STATE_LIFE) > 0.405 and GetUnitName(GetDyingUnit()) != "dummy"
endfunction

function Trig_Heuz1_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local unit dummy = dummyspawn( heuz, 1, 0, 0, 0 )
    
    call DestroyEffect( AddSpecialEffect( "Acid Ex.mdx", GetUnitX(heuz), GetUnitY(heuz) ) )
    call GroupEnumUnitsInRange( g, GetUnitX(heuz), GetUnitY(heuz), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, heuz, "enemy" ) then
            call DestroyEffect( AddSpecialEffect( "Acid Ex.mdx", GetUnitX(u), GetUnitY(u) ) )
            call UnitDamageTarget( dummy, u, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.08, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

//===========================================================================
function InitTrig_Heuz1 takes nothing returns nothing
    set gg_trg_Heuz1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Heuz1 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Heuz1, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Heuz1, Condition( function Trig_Heuz1_Conditions ) )
    call TriggerAddAction( gg_trg_Heuz1, function Trig_Heuz1_Actions )
endfunction

