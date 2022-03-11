globals
    constant real SAMURAI_R_HEAL_BONUS_LEVEL_BONUS = 0.1
    constant integer SAMURAI_R_DURATION_FIRST_LEVEL = 2
    constant integer SAMURAI_R_DURATION_LEVEL_BONUS = 2
    
    constant integer SAMURAI_R_DURATION_BONUS_ALTERNATIVE = 2
endglobals

function Trig_SamuraiR_Conditions takes nothing returns boolean
    local integer playerIndex = GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1
    local unit hero = udg_hero[playerIndex]
    local unit target = GetDyingUnit()
    local boolean isWork = true
    
    if GetUnitTypeId(target) == 'u000' then
        set isWork = false
    elseif IsUnitAlly(target, GetOwningPlayer(hero)) then
        set isWork = false
    elseif GetUnitAbilityLevel( hero, 'A0VT') == 0 then
        set isWork = false
    elseif not( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == hero ) then
        set isWork = false
    endif
    
    set target = null
    set hero = null
    return isWork
endfunction

function SamuraiR_Alternative takes unit caster, real duration returns nothing
    set duration = duration * SAMURAI_R_DURATION_BONUS_ALTERNATIVE

    call bufallst( caster, null, 'A0VV', 0, 0, 0, 0, 'B04B', "smrw", duration )
    call effst( caster, caster, null, 1, duration )

    set caster = null
endfunction

function SamuraiR takes unit caster, real duration returns nothing
    call bufallst( caster, null, 'A0VV', 0, 0, 0, 0, 'B04B', "smrw", duration )
    call effst( caster, caster, null, 1, duration )

    set caster = null
endfunction

function Trig_SamuraiR_Actions takes nothing returns nothing
    local unit caster = udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1]
    local real duration
    
    set duration = SAMURAI_R_DURATION_FIRST_LEVEL + ( SAMURAI_R_DURATION_LEVEL_BONUS * GetUnitAbilityLevel( caster, 'A0VT') )

    if Aspects_IsHeroAspectActive(caster, ASPECT_03 ) then
        call SamuraiR_Alternative( caster, duration)
    else
        call SamuraiR( caster, duration )
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_SamuraiR takes nothing returns nothing
    set gg_trg_SamuraiR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SamuraiR, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_SamuraiR, Condition( function Trig_SamuraiR_Conditions ) )
    call TriggerAddAction( gg_trg_SamuraiR, function Trig_SamuraiR_Actions )
endfunction

scope SamuraiR initializer init
    //OnHealChange
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_OnHealChange_Caster, 'A0VT') > 0 and Aspects_IsHeroAspectActive(Event_OnHealChange_Caster, ASPECT_03 ) == false
    endfunction
    
    private function Action takes nothing returns nothing
        set Event_OnHealChange_Heal = Event_OnHealChange_Heal + ( Event_OnHealChange_StaticHeal * ( SAMURAI_R_HEAL_BONUS_LEVEL_BONUS * GetUnitAbilityLevel( Event_OnHealChange_Caster, 'A0VT') ) )
    endfunction

    //DeleteBuff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0VV') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'A0VV' )
        call UnitRemoveAbility( hero, 'B04B' )
        
        set hero = null
    endfunction

    //Init
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_OnHealChange_Real", function Action, function Conditions )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

