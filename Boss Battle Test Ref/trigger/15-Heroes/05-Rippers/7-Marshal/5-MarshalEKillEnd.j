function Trig_MarshalEKillEnd_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_FightEnd_Unit, 'A0F7') > 0 and GetUnitAbilityLevel( udg_FightEnd_Unit, 'A0G0') > 0 and not(udg_fightmod[3])
endfunction

function Trig_MarshalEKillEnd_Actions takes nothing returns nothing
    local integer lvl = GetUnitAbilityLevel( udg_FightEnd_Unit, 'A0F7')
    local integer bonus = lvl
    
    if LoadInteger( udg_hash, GetHandleId( udg_FightEnd_Unit ), StringHash( "kill" ) ) == 0 then
        set bonus = bonus * 2
    endif
    
    call UnitRemoveAbility(udg_FightEnd_Unit, 'A0G0')
    call UnitRemoveAbility(udg_FightEnd_Unit, 'B06B')
    call statst( udg_FightEnd_Unit, bonus, bonus, 0, 0, true )
    call textst( "Humanity rises! +" + I2S(bonus), udg_FightEnd_Unit, 64, GetRandomInt( 45, 135 ), 10, 4 )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", udg_FightEnd_Unit, "origin" ) )
endfunction

//===========================================================================
function InitTrig_MarshalEKillEnd takes nothing returns nothing
    set gg_trg_MarshalEKillEnd = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_MarshalEKillEnd, "udg_FightEnd_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MarshalEKillEnd, Condition( function Trig_MarshalEKillEnd_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalEKillEnd, function Trig_MarshalEKillEnd_Actions )
endfunction