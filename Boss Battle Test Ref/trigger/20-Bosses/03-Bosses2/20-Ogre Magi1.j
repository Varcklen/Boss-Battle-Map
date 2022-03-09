function Trig_Ogre_Magi1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Q'
endfunction

function Trig_Ogre_Magi1_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call UnitAddAbility( udg_DamageEventTarget, 'A0W2' )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Ogre_Magi1 takes nothing returns nothing
    set gg_trg_Ogre_Magi1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ogre_Magi1 )
    call TriggerRegisterVariableEvent( gg_trg_Ogre_Magi1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ogre_Magi1, Condition( function Trig_Ogre_Magi1_Conditions ) )
    call TriggerAddAction( gg_trg_Ogre_Magi1, function Trig_Ogre_Magi1_Actions )
endfunction

