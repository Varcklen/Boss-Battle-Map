globals
    integer array Enlightenment_SpellPower[5]
    
    constant integer ENLIGMENT_SPELL_POWER_BONUS = 3
endglobals

function Trig_Enlightenment_Conditions takes nothing returns boolean
    return IsHeroHasItem( GetSpellAbilityUnit(), 'I0GQ' ) and combat(GetSpellAbilityUnit(), false, 0)
endfunction

function Trig_Enlightenment_Actions takes nothing returns nothing
    local integer index = GetUnitUserData(GetSpellAbilityUnit())
    
    call spdst( GetSpellAbilityUnit(), ENLIGMENT_SPELL_POWER_BONUS )
    set Enlightenment_SpellPower[index] = Enlightenment_SpellPower[index] + ENLIGMENT_SPELL_POWER_BONUS
endfunction

//===========================================================================
function InitTrig_Enlightenment takes nothing returns nothing
    set gg_trg_Enlightenment = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Enlightenment, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Enlightenment, Condition( function Trig_Enlightenment_Conditions ) )
    call TriggerAddAction( gg_trg_Enlightenment, function Trig_Enlightenment_Actions )
endfunction

scope Enlightenment initializer init
    private function Func_Condition takes nothing returns boolean
        return Enlightenment_SpellPower[GetUnitUserData(udg_FightEnd_Unit)] > 0
    endfunction
    
    private function Action takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local integer index = GetUnitUserData(hero)

        call spdst( hero, -Enlightenment_SpellPower[index] )
        set Enlightenment_SpellPower[index] = 0
        
        set hero = null
    endfunction

    private function init takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i > 4
            set Enlightenment_SpellPower[i] = 0
            set i = i + 1
        endloop
        call CreateEventTrigger( "udg_FightEnd_Real", function Action, function Func_Condition )
    endfunction
endscope