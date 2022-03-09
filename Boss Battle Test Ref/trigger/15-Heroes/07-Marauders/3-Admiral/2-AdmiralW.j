function Trig_AdmiralW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0RZ' and ( combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) ) and not( udg_fightmod[3] )
endfunction

function Trig_AdmiralW_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer g
    local integer lvl
    local unit caster
    local real heal
    local real bonus
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0RZ'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif

    set g = 15 + ( 5 * lvl )
    set bonus = 0.05 + ( lvl * 0.03 )

    if GetPlayerState(GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD) >= g then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly( udg_hero[cyclA], GetOwningPlayer( caster ) ) then
                call healst( caster, udg_hero[cyclA], GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * bonus )
                call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            endif
            set cyclA = cyclA + 1
        endloop
        call SetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD) - g ) )
    elseif GetSpellAbilityId() == 'A0RZ' then
        call textst( "NOT ENOUGH GOLD", caster, 64, 90, 10, 1.5 )	
    endif

	set caster = null
endfunction

//===========================================================================
function InitTrig_AdmiralW takes nothing returns nothing
    set gg_trg_AdmiralW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdmiralW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AdmiralW, Condition( function Trig_AdmiralW_Conditions ) )
    call TriggerAddAction( gg_trg_AdmiralW, function Trig_AdmiralW_Actions )
endfunction

