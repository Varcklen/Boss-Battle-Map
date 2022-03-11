function Trig_ShamanQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0VZ'
endfunction

function Trig_ShamanQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real heal
    local real mana
    local integer dmg

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0VZ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set heal = 100 + ( 40 * lvl )
    set mana = 10 * lvl
    set dmg = 1 + ( 2 * lvl )
    
    call healst( caster, target, heal )
    call manast( caster, target, mana )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl", target, "origin") )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u015', GetUnitX(target), GetUnitY(target), GetRandomReal( 0, 360 ) )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 20 )
    call SetUnitVertexColor( bj_lastCreatedUnit, 255, 255, 255, 200 )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, dmg, 0 )
    call spectimeunit( bj_lastCreatedUnit, "Abilities\\Spells\\Human\\Banish\\BanishTarget.mdl", "origin", 20 )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_ShamanQ takes nothing returns nothing
    set gg_trg_ShamanQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShamanQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShamanQ, Condition( function Trig_ShamanQ_Conditions ) )
    call TriggerAddAction( gg_trg_ShamanQ, function Trig_ShamanQ_Actions )
endfunction

