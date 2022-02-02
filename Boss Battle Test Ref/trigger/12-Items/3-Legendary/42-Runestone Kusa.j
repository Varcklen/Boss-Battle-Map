function Trig_Runestone_Kusa_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I02H' ) > 0 and not(udg_logic[GetUnitUserData(GetSpellAbilityUnit()) + 26])
endfunction

function Runestone_KusaCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "kusa" ) )
    
    set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A014')
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)
    call IssuePointOrder( bj_lastCreatedUnit, "silence", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
    
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_Runestone_Kusa_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetSpellAbilityUnit() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "kusa" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "kusa" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "kusa" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "kusa" ), GetSpellAbilityUnit() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "kusa" ) ), 0.01, false, function Runestone_KusaCast )
endfunction

//===========================================================================
function InitTrig_Runestone_Kusa takes nothing returns nothing
    set gg_trg_Runestone_Kusa = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Runestone_Kusa, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Runestone_Kusa, Condition( function Trig_Runestone_Kusa_Conditions ) )
    call TriggerAddAction( gg_trg_Runestone_Kusa, function Trig_Runestone_Kusa_Actions )
endfunction

