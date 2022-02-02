//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Ogre_Magi3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 25.
endfunction

function Trig_Ogre_Magi3_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    call SetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE, GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE ) )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Ogre_Magi3 takes nothing returns nothing
    set gg_trg_Ogre_Magi3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ogre_Magi3 )
    call TriggerRegisterVariableEvent( gg_trg_Ogre_Magi3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ogre_Magi3, Condition( function Trig_Ogre_Magi3_Conditions ) )
    call TriggerAddAction( gg_trg_Ogre_Magi3, function Trig_Ogre_Magi3_Actions )
endfunction

