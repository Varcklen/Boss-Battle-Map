function Trig_RealBroR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BH' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function RealBroRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "rlbrc" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "rlbrt" ) )
    local real h = LoadReal( udg_hash, id, StringHash( "rlbrh" ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "rlbr" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "rlbrx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "rlbry" ) )
    local real xc = GetUnitX( n )
    local real yc = GetUnitY( n )
    local real angle = Atan2( y - yc, x - xc )
    local real NewX = xc + 30 * Cos( angle )
    local real NewY = yc + 30 * Sin( angle )
	local real dmg = LoadReal( udg_hash, id, StringHash( "rlbr" ))
    local real IfX = ( x - xc ) * ( x - xc )
    local real IfY = ( y - yc ) * ( y - yc )
    local real IfS = SquareRoot( IfX + IfY )
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "rlbr" ))
    local real halftime = LoadReal( udg_hash, id, StringHash( "rlbrht" ) )
    local real time = LoadReal( udg_hash, id, StringHash( "rlbrp" ) ) + 0.02

    if IfS < 50 or GetUnitState( n, UNIT_STATE_LIFE) <= 0.405 or not(combat( caster, false, 0 )) then
        call SetUnitFlyHeight( n, h, 0 )
		call SetUnitPathing( n, true )
		call UnitRemoveAbility( n, 'Amrf' )
		call pausest( n, -1 )
        call UnitRemoveAbility(n, 'A1BI')
        if GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
            call GroupAoE( caster, null, xc, yc, dmg, 400, "enemy", "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", "" )
        endif
        call FlushChildHashtable( udg_hash, id ) 
        call DestroyTimer( GetExpiredTimer() )
    else 
        call SetUnitPosition( n, NewX, NewY )
    endif
    if time >= halftime and not(l) then
        call SetUnitFlyHeight( n, -600, 1500 )
        call SaveBoolean( udg_hash, id, StringHash( "rlbr" ), true )
    else
        call SaveReal( udg_hash, id, StringHash( "rlbrp" ), time )
    endif
    
    set n = null
    set caster = null
endfunction

function Trig_RealBroR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local unit u = null
    local real dmg
    local real h
    local group g = CreateGroup()
    local unit n
    local integer lvl
    local real halftime
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1BH'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    //if udg_fightmod[3] and not( RectContainsUnit(udg_Boss_Rect, target) ) then
        //set caster = null
        //set target = null
        //return
    //endif
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
    loop
        set n = FirstOfGroup(g)
        exitwhen n == null
        if GetUnitTypeId( n ) == 'n030' then
            set u = n
        endif
        call GroupRemoveUnit(g,n)
    endloop
    
    if u == null then
        set u = randomtarget( caster, 300, "all", "notcaster", "notstand", "", "" )
    endif
    if u != null then
        set dmg = 100 + (lvl*50)
        
        set h = GetUnitDefaultFlyHeight(u)
        set halftime = 0.02*0.5*(DistanceBetweenUnits(target,u)/30)//0.02-время,0.5-половина времени,30-скорость полета.

        if GetUnitAbilityLevel(u, 'A1BI') == 0 then
            call pausest( u, 1 )
        endif
        call UnitAddAbility(u, 'A1BI')
        call UnitAddAbility( u, 'Amrf' )
        call SetUnitFlyHeight( u, 600, 1500 )
        call SetUnitPathing( u, false )
        
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, StringHash( "rlbr" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "rlbr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "rlbr" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "rlbr" ), u)
        call SaveUnitHandle( udg_hash, id, StringHash( "rlbrc" ),caster)
        call SaveReal( udg_hash, id, StringHash( "rlbrx" ), GetUnitX(target))
        call SaveReal( udg_hash, id, StringHash( "rlbry" ), GetUnitY(target))
        call SaveReal( udg_hash, id, StringHash( "rlbr" ), dmg)
        call SaveReal( udg_hash, id, StringHash( "rlbrht" ), halftime )
        call SaveReal( udg_hash, id, StringHash( "rlbrh" ), h)
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "rlbr" ) ), 0.02, true, function RealBroRCast ) 
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set n = null
    set g = null
    set caster = null
    set target = null
    set u = null
endfunction

//===========================================================================
function InitTrig_RealBroR takes nothing returns nothing
    set gg_trg_RealBroR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RealBroR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_RealBroR, Condition( function Trig_RealBroR_Conditions ) )
    call TriggerAddAction( gg_trg_RealBroR, function Trig_RealBroR_Actions )
endfunction

