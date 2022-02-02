function Trig_PirateR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07X'
endfunction

function Trig_PirateR_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local group g = CreateGroup()
    local unit u
    local real dur
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07X'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 80 + ( 40 * lvl )
    set dur = 1 + (0.5*lvl)
        
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call UnitStun(caster, u, dur )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PirateR takes nothing returns nothing
    set gg_trg_PirateR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PirateR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PirateR, Condition( function Trig_PirateR_Conditions ) )
    call TriggerAddAction( gg_trg_PirateR, function Trig_PirateR_Actions )
endfunction

