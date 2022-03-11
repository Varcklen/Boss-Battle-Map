function Trig_Ogre_Staff_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) != 'u000' and luckylogic( udg_DamageEventSource, 5, 1, 100 ) and ( inv( udg_DamageEventSource, 'I09F') > 0 or ( inv( udg_DamageEventSource, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1 + 64] ) )
endfunction

function Trig_Ogre_Staff_Actions takes nothing returns nothing
    call manast( udg_DamageEventSource, null, 20 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", udg_DamageEventSource, "origin") )
endfunction

//===========================================================================
function InitTrig_Ogre_Staff takes nothing returns nothing
    set gg_trg_Ogre_Staff = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Ogre_Staff, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ogre_Staff, Condition( function Trig_Ogre_Staff_Conditions ) )
    call TriggerAddAction( gg_trg_Ogre_Staff, function Trig_Ogre_Staff_Actions )
endfunction

