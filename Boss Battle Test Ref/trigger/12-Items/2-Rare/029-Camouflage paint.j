function Trig_Camouflage_paint_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10B'
endfunction

function CamouflageLog takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "camflc" ) )
    local unit cam = LoadUnitHandle( udg_hash, id, StringHash( "camfl" ) )
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "camfl" ) )
    
    if not(l) then
        call SelectUnitForPlayerSingle( cam, GetOwningPlayer(cam) )
        call SaveBoolean( udg_hash, id, StringHash( "camfl" ), true )
    endif
    if not( IsUnitInTransport( caster, cam ) ) then
        call KillUnit(cam)
        call UnitRemoveAbility( caster, 'Avul' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set cam = null
endfunction

function Trig_Camouflage_paint_Actions takes nothing returns nothing
    local integer x
    local unit caster
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A10B'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    call UnitAddAbility( caster, 'Avul' )
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n059', GetUnitX( caster ), GetUnitY( caster ), 270 )
    set Transport[GetUnitUserData(caster)] = bj_lastCreatedUnit
    
    call IssueTargetOrder( caster, "board", bj_lastCreatedUnit )
    call ClearSelectionForPlayer( GetOwningPlayer(caster) )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
    
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(caster) * 0.5) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, BlzGetUnitBaseDamage(caster, 0), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    call SaveTimerHandle( udg_hash, id, StringHash( "camfl" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "camfl" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "camfl" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "camflc" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "camfl" ) ), 1, true, function CamouflageLog )

    set caster = null
endfunction

//===========================================================================
function InitTrig_Camouflage_paint takes nothing returns nothing
    set gg_trg_Camouflage_paint = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Camouflage_paint, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Camouflage_paint, Condition( function Trig_Camouflage_paint_Conditions ) )
    call TriggerAddAction( gg_trg_Camouflage_paint, function Trig_Camouflage_paint_Actions )
endfunction

