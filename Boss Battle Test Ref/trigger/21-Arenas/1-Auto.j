function Trig_Auto_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10N' or GetSpellAbilityId() == 'A10O'
endfunction

function Trig_Auto_Actions takes nothing returns nothing
    local integer cyclA
    local string str
    if not( udg_logic[71] ) then
        set udg_logic[71] = true
        set str = "|cffffcc00'Auto arenas'|r on."
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A0JQ' )
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A08B' )
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A10N' )
        call UnitAddAbility( gg_unit_h00A_0034, 'A10O' )
        call ShowUnitShow( gg_unit_h01Q_0273 )
        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( gg_unit_h01Q_0273 ), GetUnitY( gg_unit_h01Q_0273 ) ) )
    elseif GetSpellAbilityId() == 'A10O' and udg_logic[71] then
        set udg_logic[71] = false
        set str = "|cffffcc00'Auto arenas'|r off."
        call UnitRemoveAbility( gg_unit_h00A_0034, 'A10O' )
        call UnitAddAbility( gg_unit_h00A_0034, 'A10N' )
        if not( udg_logic[31] ) or udg_logic[43] and udg_Boss_LvL != 1 and (not( udg_logic[101] ) or (udg_ArenaLim[1] == 0 and udg_logic[101])) then
            call UnitAddAbility( gg_unit_h00A_0034, 'A0JQ' )
        endif
        if not( udg_logic[33] ) and not( udg_logic[43] ) and udg_Boss_LvL != 1 and (not( udg_logic[101] ) or (udg_ArenaLim[0] == 0 and udg_logic[101])) then
            call UnitAddAbility( gg_unit_h00A_0034, 'A08B' )
        endif
        call DisableTrigger( gg_trg_Auto )
        call IssueImmediateOrder( gg_unit_h00A_0034, "stomp" )
        call EnableTrigger( gg_trg_Auto )
        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( gg_unit_h01Q_0273 ), GetUnitY( gg_unit_h01Q_0273 ) ) )
        call ShowUnit(gg_unit_h01Q_0273, false)
    endif
    set cyclA = 0
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState( Player( cyclA ) ) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer(Player( cyclA ), 0, 0, 5, str )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Auto takes nothing returns nothing
    set gg_trg_Auto = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Auto, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Auto, Condition( function Trig_Auto_Conditions ) )
    call TriggerAddAction( gg_trg_Auto, function Trig_Auto_Actions )
endfunction

