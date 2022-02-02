globals
    constant real EMOTION_SUPPRESSION_DAMAGE_REDUCTION = 0.1
endglobals

function Trig_Emotion_Suppression_Conditions takes nothing returns boolean
    return udg_modgood[37] and IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO)
endfunction

function Trig_Emotion_Suppression_Actions takes nothing returns nothing
    set udg_DamageEventAmount = udg_DamageEventAmount - (Event_OnDamageChange_StaticDamage*EMOTION_SUPPRESSION_DAMAGE_REDUCTION)
endfunction

//===========================================================================
function InitTrig_Emotion_Suppression takes nothing returns nothing
    call CreateEventTrigger( "Event_OnDamageChange_Real", function Trig_Emotion_Suppression_Actions, function Trig_Emotion_Suppression_Conditions )
endfunction

