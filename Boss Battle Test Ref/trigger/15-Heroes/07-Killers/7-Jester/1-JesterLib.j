library JesterLib requires TextLib, BuffsLibLib, TimebonusLib

function jesterst takes unit u, integer i, integer lvl returns nothing
	local integer g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "jest" ) )
    local real r = 0.03
    local integer lim = 5*lvl 
    local integer k

    if IsUnitType( u, UNIT_TYPE_HERO) then
        if g + i > lim then
            set k = lim - g
            set g = lim
        elseif g + i < 0 then
            set k = -g
            set g = 0
        else
            set k = i
            set g = g + i
        endif
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "jest" ), g )

        if k >= 0 then
            call textst( "|cFF1CE6B9" + I2S(g), u, 64, GetRandomReal( 80, 100 ), 12, 1 )
        endif
        if k != 0 then
            call BlzSetUnitAttackCooldown( u, BlzGetUnitAttackCooldown(u, 0) - r*k, 0 )
            if g > 0 then
                call UnitAddAbility(u, 'A0IE')
            elseif g <= 0 then
                call UnitRemoveAbility(u, 'A0IE')
                call UnitRemoveAbility(u, 'B094')
            endif
        endif
    endif
endfunction

function hpoisonCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "jpsnt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "jpsn" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "jpsn" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "jpsnd" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
    endif
    
    if GetUnitState(target, UNIT_STATE_LIFE) > 0.405 and counter > 0 and GetUnitAbilityLevel( target, 'B095') > 0 then
        call SaveReal( udg_hash, id, StringHash( "jpsnt" ), counter - 1 )
    else
        call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "jpsng" ), 0 )
        call UnitRemoveAbility( target, 'A0JM' )
        call UnitRemoveAbility( target, 'B095' )
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set target = null
    set dummy = null
endfunction

function hpoisonst takes unit caster, unit target, integer i returns nothing
    local unit dummy
    local integer id
    local real dmg
    local real t = timebonus(caster, 10)
    local boolean l = false
    local integer lim = 10 + (2*GetUnitAbilityLevel(caster, 'A0ON'))
    local integer g = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "jpsng" ) )

    if g == 0 then
        set l = true
    endif

    set g = g + i
    if g > lim then
        set g = lim
    endif
    call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "jpsng" ), g )

    call textst( "|cFF20C000" + I2S(g), target, 64, GetRandomReal( 80, 100 ), 12, 1 )

    set dmg = g * 5 * GetUnitSpellPower(caster)
    
    call bufst( caster, target, 'A0JM', 'B095', "jpsn", t )
    call debuffst( caster, target, null, 1, t )
    
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "jpsn" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "jpsn" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "jpsn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "jpsn" ), target )
    call SaveReal( udg_hash, id, StringHash( "jpsnt" ), t )
    call SaveReal( udg_hash, id, StringHash( "jpsn" ), dmg )
    if l then
        call dummyspawn( caster, 0, 0, 0, 0 )
        call SaveUnitHandle( udg_hash, id, StringHash( "jpsnd" ), bj_lastCreatedUnit )
    endif
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "jpsn" ) ), 1, true, function hpoisonCast )
    
    set dummy = null
endfunction

endlibrary