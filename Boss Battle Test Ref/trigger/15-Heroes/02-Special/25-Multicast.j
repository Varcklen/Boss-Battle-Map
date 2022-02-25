globals
    constant integer MULTICAST_BONUS = 1
    
    integer array Multicast_Bonus[5]
endglobals

function Trig_Multicast_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GT' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Multicast_Actions takes nothing returns nothing
    local unit caster
    local integer index
    local integer bonus = 0
    local integer i

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0GT'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set index = GetUnitUserData(caster)

    set i = 1
    loop
        exitwhen i > SETS_COUNT
        if SetCount_GetPieces(caster, i) > 0 then
            set bonus = bonus + MULTICAST_BONUS
        endif
        set i = i + 1
    endloop
    
    call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) + bonus, 0 )
    call spdst(caster, bonus)
    set Multicast_Bonus[index] = Multicast_Bonus[index] + bonus
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\UnholyFrenzyAOE\\UnholyFrenzyAOETarget.mdl", caster, "origin" ) )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Multicast takes nothing returns nothing
    set gg_trg_Multicast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Multicast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Multicast, Condition( function Trig_Multicast_Conditions ) )
    call TriggerAddAction( gg_trg_Multicast, function Trig_Multicast_Actions )
endfunction

scope Multicast initializer Triggs
    private function StartFight_Conditions takes nothing returns boolean
        return Multicast_Bonus[GetUnitUserData(udg_FightEnd_Unit)] > 0
    endfunction
    
    private function StartFight takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local integer index = GetUnitUserData(hero)

        call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) - Multicast_Bonus[index], 0 )
        call spdst(hero, -Multicast_Bonus[index])
        set Multicast_Bonus[index] = 0
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()

        call TriggerRegisterVariableEvent( trig, "udg_FightEnd_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function StartFight_Conditions ) )
        call TriggerAddAction( trig, function StartFight)
        
        set trig = null
    endfunction
endscope

