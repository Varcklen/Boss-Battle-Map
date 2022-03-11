function Trig_SkeletonLordQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CL' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function SkeletonLordQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "sklq" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "sklq" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "sklqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "sklqy" ) )
    
    call SetUnitPosition( u, x, y )
    call healst( u, null, heal )
    call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", u, "origin" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_SkeletonLordQ_Actions takes nothing returns nothing
    local integer id
    local real heal
    local unit caster
    local integer lvl
    local real x
    local real y

    if CastLogic() then
        set caster = udg_Target
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
	set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0CL'), caster, 64, 90, 10, 1.5 )
	set lvl = udg_Level
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
	set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    if not( GetRectMinX(udg_Boss_Rect) <= x and x <= GetRectMaxX(udg_Boss_Rect) and GetRectMinY(udg_Boss_Rect) <= y and y <= GetRectMaxY(udg_Boss_Rect) ) then
        set caster = null
        return
    endif

    set id = GetHandleId( caster )
    set heal = (0.04+(0.02*lvl))*GetUnitState( caster, UNIT_STATE_MAX_LIFE)

    	call SaveTimerHandle( udg_hash, id, StringHash( "sklq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sklq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "sklq" ), caster )
	call SaveReal( udg_hash, id, StringHash( "sklq" ), heal )
	call SaveReal( udg_hash, id, StringHash( "sklqx" ), x )
    	call SaveReal( udg_hash, id, StringHash( "sklqy" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sklq" ) ), 0.01, false, function SkeletonLordQCast )

    set caster = null
endfunction

//===========================================================================
function InitTrig_SkeletonLordQ takes nothing returns nothing
    set gg_trg_SkeletonLordQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkeletonLordQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SkeletonLordQ, Condition( function Trig_SkeletonLordQ_Conditions ) )
    call TriggerAddAction( gg_trg_SkeletonLordQ, function Trig_SkeletonLordQ_Actions )
endfunction

