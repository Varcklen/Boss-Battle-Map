function Trig_MentorPas_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and GetUnitAbilityLevel(udg_DamageEventSource, 'A0NS') > 0 and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and GetUnitTypeId(udg_DamageEventSource) != 'u000'
endfunction

function Trig_MentorPas_Actions takes nothing returns nothing
    local real r = 2* GetUnitAbilityLevel( udg_DamageEventSource, 'A0NS')
    local integer cyclA = 1
    
    if GetUnitState(udg_DamageEventSource, UNIT_STATE_MANA) == GetUnitState(udg_DamageEventSource, UNIT_STATE_MAX_MANA) then
        set r = 1 + GetUnitAbilityLevel( udg_DamageEventSource, 'A0NS')
        loop
            exitwhen cyclA > 4
            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and udg_DamageEventSource != udg_hero[cyclA] and IsUnitAlly(udg_DamageEventSource, Player(cyclA - 1)) and udg_hero[cyclA] != udg_unit[57] and udg_hero[cyclA] != udg_unit[58] then
                call manast( udg_DamageEventSource, udg_hero[cyclA], r )
                call spectimeunit( udg_hero[cyclA], "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", "origin", 2 )
            endif
            set cyclA = cyclA + 1
        endloop
    else
        call manast( udg_DamageEventSource, null, r )
        call spectimeunit( udg_DamageEventSource, "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", "origin", 2 )
    endif
endfunction

//===========================================================================
function InitTrig_MentorPas takes nothing returns nothing
    set gg_trg_MentorPas = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MentorPas, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MentorPas, Condition( function Trig_MentorPas_Conditions ) )
    call TriggerAddAction( gg_trg_MentorPas, function Trig_MentorPas_Actions )
endfunction

