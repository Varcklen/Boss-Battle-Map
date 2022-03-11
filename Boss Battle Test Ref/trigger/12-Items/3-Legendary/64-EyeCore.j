function Trig_EyeCore_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0Q9'
endfunction

function Trig_EyeCore_Actions takes nothing returns nothing
    local integer cyclA 
    local integer cyclB = 1
    local integer cyclBEnd
    local unit caster
    local real hp
    local real mp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0Q9'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclBEnd = eyest( caster )
    loop
        exitwhen cyclB > cyclBEnd
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(caster)) then
                if IsUnitInvisible( udg_hero[cyclA], Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
                    set hp = GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE)
                    set mp = GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA)
                    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",  udg_hero[cyclA], "origin" ) )
                else
                    set hp = GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * 0.1
                    set mp = GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) * 0.1
                endif
                call healst( caster, udg_hero[cyclA], hp )
                call manast( caster, udg_hero[cyclA], mp )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl",  udg_hero[cyclA], "origin" ) )
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclB = cyclB + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_EyeCore takes nothing returns nothing
    set gg_trg_EyeCore = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EyeCore, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EyeCore, Condition( function Trig_EyeCore_Conditions ) )
    call TriggerAddAction( gg_trg_EyeCore, function Trig_EyeCore_Actions )
endfunction

