function Trig_InfoFrameData_Actions takes nothing returns nothing
    set udg_DB_InfoFrame_Number = 3
    set udg_DB_InfoFrame_Name[1] = "|cffffcc00Gold|r"
    set udg_DB_InfoFrame_Name[2] = "|cffbe81f7Spell power|r"
    set udg_DB_InfoFrame_Name[3] = "|cffd7df01Luck|r"
    set udg_DB_InfoFrame_Tooltip[1] = "Gold can be obtained for killing bosses, from certain items and abilities, as well as in arenas at Cute Bob."
    set udg_DB_InfoFrame_Tooltip[2] = "The power of abilities increases the damage from your spells, and also restores additional health and mana. If the strength of an ability affects an ability or item, its value is colored in |cffbe81f7purple|r color.|n|n|cffffcc00Example:|r |cffbe81f7100|r damage + 30% spell power = 130 damage."
    set udg_DB_InfoFrame_Tooltip[3] = "Luck increases the chance of triggering values with a random effect. If luck affects an ability or item, the value is colored in |cffd7df01yellow|r color.|n|n|cffffcc00Example:|r |cffd7df012%|r chance + 5% luck = 7%."
endfunction

//===========================================================================
function InitTrig_InfoFrameData takes nothing returns nothing
    set gg_trg_InfoFrameData = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_InfoFrameData, udg_StartTimer )
    call TriggerAddAction( gg_trg_InfoFrameData, function Trig_InfoFrameData_Actions )
endfunction

