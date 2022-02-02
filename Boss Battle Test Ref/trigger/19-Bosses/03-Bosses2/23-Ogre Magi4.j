//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Ogre_Magi4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 90.
endfunction

function Trig_Ogre_Magi4_Actions takes nothing returns nothing
    call DisableTrigger( GetTriggeringTrigger() )
    if GetOwningPlayer(udg_DamageEventTarget) == Player(10) then
        call dummyspawn ( udg_DamageEventTarget, 1, 'A0W3', 0, 0 )
        call IssuePointOrder( bj_lastCreatedUnit, "silence", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
    endif
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", udg_DamageEventTarget, "origin") )
endfunction

//===========================================================================
function InitTrig_Ogre_Magi4 takes nothing returns nothing
    set gg_trg_Ogre_Magi4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ogre_Magi4 )
    call TriggerRegisterVariableEvent( gg_trg_Ogre_Magi4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ogre_Magi4, Condition( function Trig_Ogre_Magi4_Conditions ) )
    call TriggerAddAction( gg_trg_Ogre_Magi4, function Trig_Ogre_Magi4_Actions )
endfunction

