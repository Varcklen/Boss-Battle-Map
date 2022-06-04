function Trig_ElementalW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0LQ'
endfunction

function Trig_ElementalW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real dmgsum = 0
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0LQ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 100 + ( 50 * lvl )

    if GetUnitAbilityLevel( target, 'A0K8') > 0 then
        set dmgsum = dmgsum + dmg
    endif
    if GetUnitAbilityLevel( target, 'A0LO') > 0 then
        set dmgsum = dmgsum + dmg
    endif
    if GetUnitAbilityLevel( target, 'A0FU') > 0 then
        set dmgsum = dmgsum + dmg
    endif
    call DestroyEffect( AddSpecialEffect( "Acid Ex.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    call DelBuff( target, false )
    if GetUnitAbilityLevel( caster, 'A0LP') > 0 then
        call DestroyEffect( AddSpecialEffect( "Acid Ex.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
        call healst( caster, null, 60 + (40*GetUnitAbilityLevel( caster, 'A0LP')) )
    endif
    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call healst(caster, target, dmgsum )
    else
        call dummyspawn( caster, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmgsum, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif    

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ElementalW takes nothing returns nothing
    set gg_trg_ElementalW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ElementalW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ElementalW, Condition( function Trig_ElementalW_Conditions ) )
    call TriggerAddAction( gg_trg_ElementalW, function Trig_ElementalW_Actions )
endfunction

