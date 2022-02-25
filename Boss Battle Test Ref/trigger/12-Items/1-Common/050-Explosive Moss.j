function Trig_Explosive_Moss_Conditions takes nothing returns boolean
    return inv( GetDyingUnit(), 'I073') > 0
endfunction

function Trig_Explosive_Moss_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    
    call dummyspawn( GetDyingUnit(), 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "Units\\Undead\\Abomination\\AbominationExplosion.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetDyingUnit(), "enemy" )  then
            call UnitDamageTarget( bj_lastCreatedUnit, u, 750, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
endfunction

//===========================================================================
function InitTrig_Explosive_Moss takes nothing returns nothing
    set gg_trg_Explosive_Moss = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Explosive_Moss, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Explosive_Moss, Condition( function Trig_Explosive_Moss_Conditions ) )
    call TriggerAddAction( gg_trg_Explosive_Moss, function Trig_Explosive_Moss_Actions )
endfunction

