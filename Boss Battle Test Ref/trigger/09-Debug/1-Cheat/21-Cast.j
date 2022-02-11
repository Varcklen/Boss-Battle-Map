function Trig_Cast_Conditions takes nothing returns boolean
    return SubString(GetEventPlayerChatString(), 0, 6) == "-casts" 
endfunction

function Trig_Cast_Actions takes nothing returns nothing
    local string ket1S = SubString(GetEventPlayerChatString(), 7, 9)
    local string ket2S = SubString(GetEventPlayerChatString(), 10, 12)
    local integer key1 = S2I(ket1S)
    local integer key2 = S2I(ket2S)
    local trigger trig = null
    
    call BJDebugMsg("===================================")
    call BJDebugMsg("Ability: key1: " + ket1S + " key2: " + ket2S )
    if udg_hero[1] == null then
        call BJDebugMsg("udg_hero[1] is null.")
        return
    endif
    if key2 == 1 then
        set trig = udg_DB_Trigger_One[key1]
    elseif key2 == 2 then
        set trig = udg_DB_Trigger_Two[key1]
    elseif key2 == 3 then
        set trig = udg_DB_Trigger_Three[key1]
    endif
    set udg_combatlogic[1] = true
    set udg_fightmod[0] = true
    call CastRandomAbility(udg_hero[1], 5, trig )
    
    set trig = null
endfunction

//===========================================================================
function InitTrig_Cast takes nothing returns nothing
    set gg_trg_Cast = CreateTrigger()
    call DisableTrigger( gg_trg_Cast )
    call TriggerRegisterPlayerChatEvent( gg_trg_Cast, Player(0), "-casts", false )
    call TriggerAddCondition( gg_trg_Cast, Condition( function Trig_Cast_Conditions ) )
    call TriggerAddAction( gg_trg_Cast, function Trig_Cast_Actions )
endfunction

