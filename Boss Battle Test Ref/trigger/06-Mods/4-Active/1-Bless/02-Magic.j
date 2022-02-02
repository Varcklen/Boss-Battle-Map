function MagicLogic takes nothing returns boolean
    local integer cyclA = 1
    local integer cyclAEnd = udg_Database_InfoNumberHeroes
    local boolean l = false
    
    loop
        exitwhen cyclA > cyclAEnd
        if GetSpellAbilityId() == udg_DB_Hero_FirstSpell[cyclA] then
            set l = true
        endif
        set cyclA = cyclA  + 1
    endloop
    return l
endfunction

function Trig_Magic_Actions takes nothing returns nothing
    local integer rand
    
    if IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo) and MagicLogic() and combat( GetSpellAbilityUnit(), false, 0 ) then
        set udg_RandomLogic = true
        set udg_Caster = GetSpellAbilityUnit()
        set udg_Level = GetRandomInt( 1, 5 )
        set rand = GetRandomInt( 1, 3 )
        if rand == 1 then
            call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
        elseif rand == 2 then
            call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
        else
            call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Magic takes nothing returns nothing
    set gg_trg_Magic = CreateTrigger(  )
    call DisableTrigger( gg_trg_Magic )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddAction( gg_trg_Magic, function Trig_Magic_Actions )
endfunction

