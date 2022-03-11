function Trig_Time_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0U1' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Time_Actions takes nothing returns nothing
    local integer cyclA = 1
    local unit u 
    
    loop
        exitwhen cyclA > 4
        set u = udg_hero[cyclA]
        if u != null then
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\Sci Teleport.mdx", GetUnitX( u ), GetUnitY( u ) ) )
            call coldstop( u )
            call manast(GetSpellAbilityUnit(), u, GetUnitState(u, UNIT_STATE_MAX_MANA))
        endif
        set cyclA = cyclA + 1
    endloop
    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0B6') )
endfunction

//===========================================================================
function InitTrig_Time takes nothing returns nothing
    set gg_trg_Time = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Time, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Time, Condition( function Trig_Time_Conditions ) )
    call TriggerAddAction( gg_trg_Time, function Trig_Time_Actions )
endfunction

