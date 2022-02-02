function Trig_Majestic_Mates_Conditions takes nothing returns boolean
    return udg_modgood[36]
endfunction

function Trig_Majestic_Mates_Actions takes nothing returns nothing
    call UnitAddAbility(UNIT_BUFF, 'A14G')
endfunction

//===========================================================================
function InitTrig_Majestic_Mates takes nothing returns nothing
    call CreateEventTrigger( "Event_Mode_Awake_Real", function Trig_Majestic_Mates_Actions, function Trig_Majestic_Mates_Conditions )
endfunction

