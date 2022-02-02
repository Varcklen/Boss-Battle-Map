function Trig_AbomDeath_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetDyingUnit(), 'A0D0' ) > 0
endfunction

function Trig_AbomDeath_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local real dmg = 0
    local integer cyclA = 1
    local effect fx
    
    loop
        exitwhen cyclA > 6
        if GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[cyclA+18] then
            set dmg = 75+(cyclA*75)
            set cyclA = 6
        endif
        set cyclA = cyclA + 1
    endloop

    call ShowUnit(GetDyingUnit(), false)
    set fx = AddSpecialEffect( "Units\\Undead\\Abomination\\AbominationExplosion.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) )
    call BlzSetSpecialEffectOrientation( fx, Deg2Rad(GetUnitFacing(GetDyingUnit())), 0.0, 0.0 )
    call DestroyEffect( fx )
    
    call dummyspawn( GetDyingUnit(), 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetDyingUnit(), "enemy" ) then
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_AbomDeath takes nothing returns nothing
    set gg_trg_AbomDeath = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AbomDeath, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_AbomDeath, Condition( function Trig_AbomDeath_Conditions ) )
    call TriggerAddAction( gg_trg_AbomDeath, function Trig_AbomDeath_Actions )
endfunction