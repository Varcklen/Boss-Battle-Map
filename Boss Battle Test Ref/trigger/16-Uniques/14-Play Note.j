function Trig_Play_Note_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CR' or GetSpellAbilityId() == 'A1AK'
endfunction

function Trig_Play_Note_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA
    local real heal
    local real mana
    local integer money
    local real spec
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A0CR'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set spec = udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer(caster)) + 1]
    if IsUniqueUpgraded(caster) then
        set heal = 8 * spec
        set mana = 4 * spec
        set money = 4
    else
        set heal = 4 * spec
        set mana = 2 * spec
        set money = 2
    endif

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and unitst( udg_hero[cyclA], caster, "ally" ) then
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl", udg_hero[cyclA], "origin") )
            call healst( caster, udg_hero[cyclA], heal )
            call manast( caster, udg_hero[cyclA], mana )
            if combat( udg_hero[cyclA], false, 0 ) and not( udg_fightmod[3] ) then
                call moneyst( udg_hero[cyclA], money )
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Play_Note takes nothing returns nothing
    set gg_trg_Play_Note = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Play_Note, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Play_Note, Condition( function Trig_Play_Note_Conditions ) )
    call TriggerAddAction( gg_trg_Play_Note, function Trig_Play_Note_Actions )
endfunction

