function Trig_Banshi3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03M' and GetUnitLifePercent(udg_DamageEventTarget) <= 50. and IsUnitVisible( udg_DamageEventTarget, Player(PLAYER_NEUTRAL_AGGRESSIVE))
endfunction

function Trig_Banshi3_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local unit target = randomtarget( udg_DamageEventTarget, 600, "enemy", "hero", "", "", "" )
           
    if target != null then
        call DisableTrigger( GetTriggeringTrigger() )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ) ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call ShowUnit( udg_DamageEventTarget, false )
        call SetUnitPosition( udg_DamageEventTarget, GetRectCenterX( gg_rct_HeroesTp ), GetRectCenterY( gg_rct_HeroesTp ) ) 
        call IssueImmediateOrder( udg_DamageEventTarget, "stop" )

        if LoadTimerHandle( udg_hash, id, StringHash( "bswf" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bswf" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswf" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bswf" ), udg_DamageEventTarget )
        call SaveUnitHandle( udg_hash, id, StringHash( "bswft" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bswf" ) ), 0.5, true, function Banshi2Cast )
        
        call berserk( target, 1 )
    endif
endfunction

//===========================================================================
function InitTrig_Banshi3 takes nothing returns nothing
    set gg_trg_Banshi3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Banshi3 )
    call TriggerRegisterVariableEvent( gg_trg_Banshi3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Banshi3, Condition( function Trig_Banshi3_Conditions ) )
    call TriggerAddAction( gg_trg_Banshi3, function Trig_Banshi3_Actions )
endfunction

