function Trig_Repeller_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A001' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction
  
function RepellerCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "repl" ) ) + 1
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "repl" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "replt" ) )
    local real x1 = GetUnitX( caster )
    local real y1 = GetUnitY( caster )
    local real x2 = GetUnitX( target )
    local real y2 = GetUnitY( target )
    local real angle = Atan2( y2 - y1, x2 - x1 )
    local real NewX = x2 + 20 * Cos( angle )
    local real NewY = y2 + 20 * Sin( angle )

    if counter < 20 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and RectContainsUnit( udg_Boss_Rect, target) then
        call SetUnitX(target, NewX )
        call SetUnitY(target, NewY )
        call SaveInteger( udg_hash, id, StringHash( "repl" ), counter )
    else
        call SetUnitPathing( target, true )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_Repeller_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A001'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
      
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if caster != u and unitst( u, caster, "all" ) and GetUnitDefaultMoveSpeed(u) != 0 then
        	call SetUnitPathing( u, false )

    		set id = GetHandleId( u )
    		if LoadTimerHandle( udg_hash, id, StringHash( "repl" ) ) == null then
    			call SaveTimerHandle( udg_hash, id, StringHash( "repl" ), CreateTimer() )
    		endif
    		set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "repl" ) ) ) 
    		call SaveUnitHandle( udg_hash, id, StringHash( "repl" ), caster )
    		call SaveUnitHandle( udg_hash, id, StringHash( "replt" ), u )
    		call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "repl" ) ), 0.02, true, function RepellerCast )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    set cyclAEnd = 8*eyest(caster)
    loop
        exitwhen cyclA > cyclAEnd
        set x = GetUnitX(caster) + 175 * Cos(45 * cyclA * bj_DEGTORAD)
        set y = GetUnitY(caster) + 175 * Sin(45 * cyclA * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit( Player(4), 'h01Y', x, y, 270 )
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 10 )
        set cyclA = cyclA + 1
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Repeller takes nothing returns nothing
    set gg_trg_Repeller = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Repeller, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Repeller, Condition( function Trig_Repeller_Conditions ) )
    call TriggerAddAction( gg_trg_Repeller, function Trig_Repeller_Actions )
endfunction

