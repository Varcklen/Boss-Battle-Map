scope RealBroE

    function Trig_RealBroE_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'A1BG' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
    endfunction

    function RealBroECast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "rlbe" ) )
        local integer count = LoadInteger( udg_hash, id, StringHash( "rlbec" ) ) + 1
        local real dmg = LoadReal( udg_hash, id, StringHash( "rlbe" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "rlbe" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "rlbet" ) )
        local real x = GetUnitX( caster )
        local real y = GetUnitY( caster )
        local real xc = GetUnitX( target )
        local real yc = GetUnitY( target )
        local real angle = Atan2( y - yc, x - xc )
        local real NewX = xc + 12 * Cos( angle )
        local real NewY = yc + 12 * Sin( angle )
        local real IfX = ( x - xc ) * ( x - xc )
        local real IfY = ( y - yc ) * ( y - yc )
        
        //RectContainsCoords(udg_Boss_Rect, x, y) and
        if SquareRoot( IfX + IfY ) > 128 and counter < 200 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and combat( caster, false, 0 ) then
            call SetUnitPosition( target, NewX, NewY )
            call SetUnitFacing( target, AngleBetweenUnits(caster, target ) )
            call SaveInteger( udg_hash, id, StringHash( "rlbe" ), counter + 1 )
            if GetUnitTypeId( target ) == 'n030' then
                if count >= 25 then
                    call SaveInteger( udg_hash, id, StringHash( "rlbec" ), 0 )
                    call GroupAoE( caster, null, GetUnitX(target), GetUnitY(target), dmg, 400, "enemy", "", "" )
                else
                    call SaveInteger( udg_hash, id, StringHash( "rlbec" ), count + 1 )
                endif
            endif
        else
            if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and counter < 200 and combat( caster, false, 0 ) then
                call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
                if IsUnitEnemy( target, GetOwningPlayer( caster ) ) then
                    call UnitStun(caster, target, 1.5 )
                endif
            endif
            call SetUnitPathing( target, true )
            call pausest( target, -1 )
            call UnitRemoveAbility( target, 'A0DV' )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
        set target = null
    endfunction
    
    private function IsNotPvP takes unit caster, unit target returns boolean
        local boolean isTrue = true
        
        if (target == udg_unit[57] or target == udg_unit[58]) and IsUnitAlly(target, GetOwningPlayer(caster)) then
            set isTrue = false
        endif
        
        set target = null
        set caster = null
        return isTrue
    endfunction

    function Trig_RealBroE_Actions takes nothing returns nothing
        local integer id 
        local integer lvl
        local unit caster
        local unit target
        local real dmg
        local real x
        local real y
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "enemy", "notcaster", "", "", "" )
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName('A1BG'), caster, 64, 90, 10, 1.5 )
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        endif
        
        if target != null and GetUnitAbilityLevel( target, 'A0DV' ) == 0 and GetUnitDefaultMoveSpeed(target) != 0 and IsNotPvP(caster, target) and caster != target then
            set x = GetUnitX( caster )
            set y = GetUnitY( caster )
            
            set dmg = (20 + ( 10 * lvl )) * GetUnitSpellPower(caster)
            
            if GetUnitAbilityLevel( target, 'A0DV' ) == 0 then
                call pausest( target, 1 )
            endif
            call UnitAddAbility( target, 'A0DV' )
            
            call SetUnitPathing( target, false )
            call SetUnitFacing( target, AngleBetweenUnits(caster, target ) )

            set id = GetHandleId( target )
            if LoadTimerHandle( udg_hash, id, StringHash( "rlbe" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "rlbe" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "rlbe" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "rlbe" ), caster )
            call SaveUnitHandle( udg_hash, id, StringHash( "rlbet" ), target )
            call SaveReal( udg_hash, id, StringHash( "rlbe" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "rlbe" ) ), 0.02, true, function RealBroECast )
        endif
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    function InitTrig_RealBroE takes nothing returns nothing
        set gg_trg_RealBroE = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_RealBroE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_RealBroE, Condition( function Trig_RealBroE_Conditions ) )
        call TriggerAddAction( gg_trg_RealBroE, function Trig_RealBroE_Actions )
    endfunction

endscope