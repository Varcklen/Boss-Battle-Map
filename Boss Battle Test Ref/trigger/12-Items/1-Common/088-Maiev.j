function Trig_Maiev_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0XJ' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function MaievCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "maiev" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "maievx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "maievy" ) )
    
    call SetUnitPosition( u, x, y )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", u, "origin" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction   

function Trig_Maiev_Actions takes nothing returns nothing
    local unit caster
    local integer id
    local real x 
    local real y 
    local integer n

    if CastLogic() then
        set caster = udg_Target
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0XJ'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    if not( GetRectMinX(udg_Boss_Rect) <= x and x <= GetRectMaxX(udg_Boss_Rect) and GetRectMinY(udg_Boss_Rect) <= y and y <= GetRectMaxY(udg_Boss_Rect) ) then
        set caster = null
        return
    endif

    set n = eyest( caster )
    
    set id = GetHandleId( caster )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "maiev" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "maiev" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "maiev" ), caster )
    call SaveReal( udg_hash, id, StringHash( "maievx" ), x )
    call SaveReal( udg_hash, id, StringHash( "maievy" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "maiev" ) ), 0.01, false, function MaievCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Maiev takes nothing returns nothing
    set gg_trg_Maiev = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Maiev, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Maiev, Condition( function Trig_Maiev_Conditions ) )
    call TriggerAddAction( gg_trg_Maiev, function Trig_Maiev_Actions )
endfunction

