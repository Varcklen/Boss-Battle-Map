function Trig_MagnataurQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UF'
endfunction

function Trig_MagnataurQ_Actions takes nothing returns nothing
    local group g
    local unit u
    local unit caster
    local unit target
    local integer lvl
    local integer i = 0
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0UF'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set g = CreateGroup()
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally" ) and u != caster then
            set i = i + 1
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    set dmg = 100 + ( 50 * lvl ) + ( ( 5 + ( 5 * lvl ) ) * i )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", target, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)

    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MagnataurQ takes nothing returns nothing
    set gg_trg_MagnataurQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MagnataurQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MagnataurQ, Condition( function Trig_MagnataurQ_Conditions ) )
    call TriggerAddAction( gg_trg_MagnataurQ, function Trig_MagnataurQ_Actions )
endfunction

