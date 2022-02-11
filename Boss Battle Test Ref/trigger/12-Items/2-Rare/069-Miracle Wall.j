function Trig_Miracle_Wall_Conditions takes nothing returns boolean
    return combat( udg_DamageEventTarget, false, 0 ) and luckylogic( udg_DamageEventTarget, 8, 1, 100 ) and ( inv(udg_DamageEventTarget, 'I03Z') > 0 or ( inv(udg_DamageEventTarget, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 92] ) )
endfunction

function Trig_Miracle_Wall_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 3 )
    set udg_RandomLogic = true
    set udg_Caster = udg_DamageEventTarget
    set udg_Level = 1
    if rand == 1 then
        call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
    elseif rand == 2 then
        call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
    else
        call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
    endif
endfunction

//===========================================================================
function InitTrig_Miracle_Wall takes nothing returns nothing
    set gg_trg_Miracle_Wall = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Miracle_Wall, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Miracle_Wall, Condition( function Trig_Miracle_Wall_Conditions ) )
    call TriggerAddAction( gg_trg_Miracle_Wall, function Trig_Miracle_Wall_Actions )
endfunction

