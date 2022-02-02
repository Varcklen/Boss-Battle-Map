function Trig_EmperorKills_Conditions takes nothing returns boolean
    return inv(Event_Hero_Kill_Unit, 'I07Z') > 0
endfunction

function Trig_EmperorKills_Actions takes nothing returns nothing
    local integer kills = LoadInteger( udg_hash, GetHandleId( Event_Hero_Kill_Unit ), StringHash( "kill" ) )
    
    if kills == 50 then
        call ChangeToolItem( Event_Hero_Kill_Unit, 'I07Z', "|cFF959697(", ")|r", "Active!" )
        call textst( "|c00ffffff Emperor upgraded!", Event_Hero_Kill_Unit, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
    elseif kills < 50 then
        call ChangeToolItem( Event_Hero_Kill_Unit, 'I07Z', "|cFF959697(", ")|r", I2S( kills ) + "/50" )
        call textst( "|c00ffffff " + I2S( kills ) + "/50", Event_Hero_Kill_Unit, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
    endif
endfunction

//===========================================================================
function InitTrig_EmperorKills takes nothing returns nothing
    set gg_trg_EmperorKills = CreateTrigger(  )
     call TriggerRegisterVariableEvent( gg_trg_EmperorKills, "Event_Hero_Kill_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_EmperorKills, Condition( function Trig_EmperorKills_Conditions ) )
    call TriggerAddAction( gg_trg_EmperorKills, function Trig_EmperorKills_Actions )
endfunction