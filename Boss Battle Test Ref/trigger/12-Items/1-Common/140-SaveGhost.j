//TESH.scrollpos=27
//TESH.alwaysfold=0
function Trig_SaveGhost_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TU'
endfunction

function SaveGhostCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "svght" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "svgh" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "svgh" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call healst( target, null, heal )
    endif
    
    if counter > 1 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SaveReal( udg_hash, id, StringHash( "svght" ), counter - 1 )
    else
        call UnitRemoveAbility( target, 'A0TW' )
        call UnitRemoveAbility( target, 'B008' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set target = null
endfunction

function Trig_SaveGhost_Actions takes nothing returns nothing
    local integer id
    local real r 
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time        
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0TU'), caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set t = 5
    endif 
    set t = timebonus(caster, t)

    set r = 40 * eyest( caster )
    set id = GetHandleId( caster )

    call UnitAddAbility( caster, 'A0TW' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "svgh" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "svgh" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "svgh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "svgh" ), caster )
    call SaveReal( udg_hash, id, StringHash( "svght" ), t )
    call SaveReal( udg_hash, id, StringHash( "svgh" ), r )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "svgh" ) ), 1, true, function SaveGhostCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_SaveGhost_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SaveGhost takes nothing returns nothing
    set gg_trg_SaveGhost = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SaveGhost, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SaveGhost, Condition( function Trig_SaveGhost_Conditions ) )
    call TriggerAddAction( gg_trg_SaveGhost, function Trig_SaveGhost_Actions )
endfunction

