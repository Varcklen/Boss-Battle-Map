function Trig_AngelR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0BW'
endfunction

function Trig_AngelR_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local integer cyclA = 1
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0BW'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 111 + ( 111 * lvl )
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", target, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    if GetUnitAbilityLevel( caster, 'A0BW') == 5 and luckylogic( caster, 15, 1, 100 ) then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n01N', GetUnitX( target ), GetUnitY( target ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 66.)
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", bj_lastCreatedUnit, "origin" ) )
    endif
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AngelR takes nothing returns nothing
    set gg_trg_AngelR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AngelR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AngelR, Condition( function Trig_AngelR_Conditions ) )
    call TriggerAddAction( gg_trg_AngelR, function Trig_AngelR_Actions )
endfunction

