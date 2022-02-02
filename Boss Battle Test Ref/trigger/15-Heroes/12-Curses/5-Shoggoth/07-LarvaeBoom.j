function Trig_LarvaeBoom_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n02J'
endfunction

function Trig_LarvaeBoom_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local effect fx

    call ShowUnit(GetDyingUnit(), false)
    set fx = AddSpecialEffect( "Units\\Undead\\Abomination\\AbominationExplosion.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) )
    call BlzSetSpecialEffectOrientation( fx, Deg2Rad(GetUnitFacing(GetDyingUnit())), 0.0, 0.0 )
    call DestroyEffect( fx )
    
    call dummyspawn( GetDyingUnit(), 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetDyingUnit(), "enemy" )  then
            call UnitDamageTarget( bj_lastCreatedUnit, u, 125, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set fx = null
endfunction

//===========================================================================
function InitTrig_LarvaeBoom takes nothing returns nothing
    set gg_trg_LarvaeBoom = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_LarvaeBoom, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_LarvaeBoom, Condition( function Trig_LarvaeBoom_Conditions ) )
    call TriggerAddAction( gg_trg_LarvaeBoom, function Trig_LarvaeBoom_Actions )
endfunction