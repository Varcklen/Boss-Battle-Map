function Trig_StartFight_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A016'
endfunction

function Trig_StartFight_Actions takes nothing returns nothing
        if udg_logic[71] and ( udg_Boss_LvL == 4 or udg_Boss_LvL == 7 or udg_Boss_LvL == 9 ) and not( udg_logic[33] ) and (not( udg_logic[101] ) or (udg_ArenaLim[0] == 0 and udg_logic[101])) then
            call Between( "start_IA" )
        elseif udg_logic[71] and ( udg_Boss_LvL == 5 or udg_Boss_LvL == 10 ) and not( udg_logic[31] ) and (not( udg_logic[101] ) or (udg_ArenaLim[1] == 0 and udg_logic[101])) then
            call Between( "start_AL" )
        elseif not( udg_fightmod[1] ) then
            call Between( "start_boss" )
        endif
endfunction

//===========================================================================
function InitTrig_StartFight takes nothing returns nothing
    set gg_trg_StartFight = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_StartFight, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_StartFight, Condition( function Trig_StartFight_Conditions ) )
    call TriggerAddAction( gg_trg_StartFight, function Trig_StartFight_Actions )
endfunction

