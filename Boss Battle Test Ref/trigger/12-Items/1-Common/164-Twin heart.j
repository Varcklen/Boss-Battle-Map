function Trig_Twin_heart_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00X'
endfunction

function Twin_heartMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "twhh" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "twhht" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "twhh" ) ) + 1
    local unit u = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "twhhtt" ) )
    local real x
    local real y
    local lightning l = LoadLightningHandle( udg_hash, GetHandleId( target ), StringHash( "twhhl" ) )
    local unit umax
    local unit umin
    local real hpc
    local real hpt
    local real hp

    if DistanceBetweenUnits(caster, target) < 900 and u == target and caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(caster, 'A013') > 0 and GetUnitAbilityLevel(target, 'A013') > 0 then
        call MoveLightningUnits( l, caster, target )
        if c >= 50 then
                set hpc = GetUnitState( caster, UNIT_STATE_LIFE) / GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 100
                set hpt = GetUnitState( target, UNIT_STATE_LIFE) / GetUnitState( target, UNIT_STATE_MAX_LIFE) * 100
                if hpc >= hpt then
                    set umax = caster
                    set umin = target
                else
                    set umin = caster
                    set umax = target
                endif
                set hp = 0.02*GetUnitState( umax, UNIT_STATE_MAX_LIFE)
                call SetUnitState( umin, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( umin, UNIT_STATE_LIFE) + hp ))
                call SetUnitState( umax, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( umax, UNIT_STATE_LIFE) - hp ))
                call SaveInteger( udg_hash, id, StringHash( "twhh" ), 0 )
        else
                call SaveInteger( udg_hash, id, StringHash( "twhh" ), c )
        endif
        else
            call UnitRemoveAbility( target, 'A013' )
            call UnitRemoveAbility( target, 'B04E' )

        if u == target then
                call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "twhhtt" ), caster )
        endif
        call UnitRemoveAbility( caster, 'A013' )
            call UnitRemoveAbility( caster, 'B04E' )
            call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
    set u = null
    set umax = null
    set umin = null
endfunction

function Trig_Twin_heart_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer sk
    local integer x
    local unit u
    local lightning l
    local boolean b = true
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "notcaster", "", "" )
        call textst( udg_string[0] + GetObjectName('A00X'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set x = eyest( caster )
	set u = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "twhhtt" ) )
	if u == target then
		set b = false
	endif
    call dummyspawn( caster, 1, 0, 0, 0 )
	call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "twhhtt" ), bj_lastCreatedUnit )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "twhh" ) ), 0, false, function Twin_heartMove )

    if b and caster != target and IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call UnitAddAbility( target, 'A013' )
        call UnitAddAbility( caster, 'A013' )

        set l = AddLightningEx("PISU", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster), GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target))

    	set id = GetHandleId( target )
    	if LoadTimerHandle( udg_hash, id, StringHash( "twhh" ) ) == null  then
    		call SaveTimerHandle( udg_hash, id, StringHash( "twhh" ), CreateTimer() )
    	endif
    	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "twhh" ) ) ) 
    	call SaveUnitHandle( udg_hash, id, StringHash( "twhh" ), caster )
    	call SaveUnitHandle( udg_hash, id, StringHash( "twhht" ), target )
        call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "twhhtt" ), target )
    	call SaveLightningHandle( udg_hash, GetHandleId( target ), StringHash( "twhhl" ), l )
    	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "twhh" ) ), 0.02, true, function Twin_heartMove )
    endif  

    set caster = null
    set target = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Twin_heart takes nothing returns nothing
    set gg_trg_Twin_heart = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Twin_heart, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Twin_heart, Condition( function Trig_Twin_heart_Conditions ) )
    call TriggerAddAction( gg_trg_Twin_heart, function Trig_Twin_heart_Actions )
endfunction