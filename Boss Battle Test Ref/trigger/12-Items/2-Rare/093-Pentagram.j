function Trig_Pentagram_Conditions takes nothing returns boolean
    return GetUnitState( udg_Event_PlayerMinionSummon_Hero, UNIT_STATE_LIFE) > 0.405 and inv( udg_Event_PlayerMinionSummon_Hero, 'I0DL' ) > 0
endfunction

function Trig_Pentagram_Actions takes nothing returns nothing
	local real hp = BlzGetUnitMaxHP(udg_Event_PlayerMinionSummon_Unit)
    local item it = GetItemOfTypeFromUnitBJ( udg_Event_PlayerMinionSummon_Hero, 'I0DL')
	local integer id = GetHandleId( it )
    local integer s = LoadInteger( udg_hash, id, StringHash( "pent" ) ) + 1
    
    if s >= 4 then
        call SaveInteger( udg_hash, id, StringHash( "pent" ), 0 )

    	call BlzSetUnitMaxHP( udg_Event_PlayerMinionSummon_Unit, R2I(BlzGetUnitMaxHP(udg_Event_PlayerMinionSummon_Unit) + hp ) )
        call SetUnitLifeBJ( udg_Event_PlayerMinionSummon_Unit, GetUnitStateSwap(UNIT_STATE_LIFE, udg_Event_PlayerMinionSummon_Unit) + R2I(hp) )
    	call BlzSetUnitBaseDamage( udg_Event_PlayerMinionSummon_Unit, R2I(BlzGetUnitBaseDamage(udg_Event_PlayerMinionSummon_Unit, 0) * 2), 0 )
    	call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_Event_PlayerMinionSummon_Unit, "origin" ) )
    else
        call SaveInteger( udg_hash, id, StringHash( "pent" ), s )
        call textst( "|c005050FF " + I2S( s ) + "/4", udg_Event_PlayerMinionSummon_Hero, 64, GetRandomReal( 0, 360 ), 7, 1.5 )
    endif
    
    set it = null
endfunction

//===========================================================================
function InitTrig_Pentagram takes nothing returns nothing
    set gg_trg_Pentagram = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Pentagram, "udg_Event_PlayerMinionSummon_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Pentagram, Condition( function Trig_Pentagram_Conditions ) )
    call TriggerAddAction( gg_trg_Pentagram, function Trig_Pentagram_Actions )
endfunction

