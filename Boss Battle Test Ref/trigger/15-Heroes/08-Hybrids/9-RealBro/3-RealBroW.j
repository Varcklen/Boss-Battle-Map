function Trig_RealBroW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BF'
endfunction

function Trig_RealBroW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real hpc
    local real hpt
    local real amount
    local real dmg
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1BF'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl" , caster, "origin" ) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl" , target, "origin" ) )
    set hpc = GetUnitState(caster, UNIT_STATE_LIFE)/RMaxBJ(1,GetUnitState(caster, UNIT_STATE_MAX_LIFE))
    set hpt = GetUnitState(target, UNIT_STATE_LIFE)/RMaxBJ(1,GetUnitState(target, UNIT_STATE_MAX_LIFE))
    
    if IsUnitEnemy( target, GetOwningPlayer( caster ) ) then
        set amount = 75+(75*lvl)
        if hpc > hpt then
            call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - amount ) )
            call SetUnitState( target, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( target, UNIT_STATE_LIFE) + amount ) )
        else
            call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) + amount ) )
            call SetUnitState( target, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( target, UNIT_STATE_LIFE) - amount ) )
        endif
    else
        call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * hpt )
        call SetUnitState( target, UNIT_STATE_LIFE, GetUnitState( target, UNIT_STATE_MAX_LIFE) * hpc )
    endif
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set dmg = 30+(30*lvl)
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", GetUnitX(u), GetUnitY(u) ) )
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_RealBroW takes nothing returns nothing
    set gg_trg_RealBroW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RealBroW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_RealBroW, Condition( function Trig_RealBroW_Conditions ) )
    call TriggerAddAction( gg_trg_RealBroW, function Trig_RealBroW_Actions )
endfunction

