function Trig_BattleRessurect_Conditions takes nothing returns boolean
    return not(udg_fightmod[3]) and udg_fightmod[0] and GetUnitAbilityLevel(GetDyingUnit(), 'A05X') == 0 and not( IsUnitInGroup(GetDyingUnit(), udg_Return) ) and GetPlayerSlotState(GetOwningPlayer(GetDyingUnit())) == PLAYER_SLOT_STATE_PLAYING and IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and udg_Heroes_Ressurect_Battle > 0
endfunction

function BattleRessurectCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ress" ) )

    if udg_fightmod[0] then
        call ReviveHeroLoc( u, GetUnitLoc( u ), true )
        call GroupAddUnit( udg_otryad, u )
        call PauseUnit( u, false )
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.5)
        call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.5)
        if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
            set udg_Heroes_Deaths = udg_Heroes_Deaths + 1
        endif
    endif
    call UnitRemoveAbility( u, 'A0EX' )
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Trig_BattleRessurect_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetDyingUnit() )
    
    call RessurectionPoints( -1, false )
    call textst( "|c00FF6000Resurrections left: " + I2S(udg_Heroes_Ressurect_Battle), GetDyingUnit(), 64, 90, 15, 2 )
    
    set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )

    call UnitAddAbility( GetDyingUnit(), 'A0EX' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "ress" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "ress" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ress" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "ress" ), GetDyingUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "ress" ) ), 3, false, function BattleRessurectCast )
endfunction

//===========================================================================
function InitTrig_BattleRessurect takes nothing returns nothing
    set gg_trg_BattleRessurect = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BattleRessurect, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_BattleRessurect, Condition( function Trig_BattleRessurect_Conditions ) )
    call TriggerAddAction( gg_trg_BattleRessurect, function Trig_BattleRessurect_Actions )
endfunction

