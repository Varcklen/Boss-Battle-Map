library SetDamageLib requires UnitstLib, HealstLib

function CommandoWAtCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "codw" ) ) + 1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "codw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "codwc" ) )
    local unit u
    local real NewX = GetUnitX( dummy ) + 90 * Cos( 0.017 * GetUnitFacing( dummy ) )
    local real NewY = GetUnitY( dummy ) + 90 * Sin( 0.017 * GetUnitFacing( dummy ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "codw" ) )
    local group g = CreateGroup()
    local boolean l = false

    if counter >= 8 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitPosition( dummy, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "codw" ), counter )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                set l = true
            endif
            call GroupRemoveUnit(g,u)
        endloop

        if l then
            call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 150, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, dummy, "enemy" ) then
                    call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
                call GroupRemoveUnit(g,u)
            endloop
            call RemoveUnit( dummy )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set dummy = null
endfunction

function CommandoWAt takes unit caster, real dmg, integer lvl returns nothing
    local integer id
    local integer cyclA = 1
    local integer b = lvl + 4
    local real x = GetUnitX( caster ) + 90 * Cos( 0.017 * GetUnitFacing( caster ) )
    local real y = GetUnitY( caster ) + 90 * Sin( 0.017 * GetUnitFacing( caster ) )

    loop
        exitwhen cyclA > b
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, GetUnitFacing( caster ) + GetRandomReal( -40, 40 ) ) 
        call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
        call UnitAddAbility( bj_lastCreatedUnit, 'A19G')
        
        set id = GetHandleId( bj_lastCreatedUnit )
        call SaveTimerHandle( udg_hash, id, StringHash( "codw" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "codw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "codw" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "codwc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "codw" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "codw" ) ), 0.04, true, function CommandoWAtCast )
        set cyclA = cyclA + 1
    endloop
endfunction

function InfernalE takes unit u, real dmg returns nothing
    local integer id = GetHandleId(u)
    local real dmgdone = LoadReal( udg_hash, id, StringHash( "infe" ) )
    local real dmghp = LoadReal( udg_hash, id, StringHash( "infen" ) )

    set dmgdone = dmgdone + dmg
    if dmgdone >= dmghp then
        set dmgdone = 0
        if GetUnitAbilityLevel(u, 'A1A6') > 1 then
            call platest(u, -1 )
            set bj_lastCreatedItem = CreateItem('I0G8', GetUnitX( u ) + GetRandomReal( -300, 300 ), GetUnitY( u ) + GetRandomReal( -300, 300 ))
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        endif
    endif
    
    call SaveReal( udg_hash, id, StringHash( "infe" ), dmgdone )
endfunction

function MimicRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "mmcrc" ) )
    local unit t = LoadUnitHandle( udg_hash, id, StringHash( "mmcr" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mmcr" ) )

    if GetUnitState( t, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( c, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, t, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
	endif
    
    call FlushChildHashtable( udg_hash, id )
    
    set c = null
    set t = null
endfunction

function CairneCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "crnnc" ) )
    local unit t = LoadUnitHandle( udg_hash, id, StringHash( "crnn" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "crnn" ) )

    if GetUnitState( t, UNIT_STATE_LIFE) > 0.405 then
        call dummyspawn( c, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, t, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
	endif
    
    call FlushChildHashtable( udg_hash, id )
    
    set c = null
    set t = null
endfunction

function MaidenECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mdne" ) )

    call UnitRemoveAbility( u, 'A16P' )
    call UnitRemoveAbility( u, 'B07C' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Channel_Energy takes unit u, real damage returns nothing
    local unit target = LoadUnitHandle( udg_hash, GetHandleId( u ), StringHash( "pckw2" ) )
    local unit caster = LoadUnitHandle( udg_hash, GetHandleId( u ), StringHash( "pckw2c" ) )
    local real percent = LoadReal( udg_hash, GetHandleId( u ), StringHash( "pckw2" ) )

    if target != null then
        call healst(caster, target, percent*damage)
    endif

    set u = null
    set target = null
    set caster = null
endfunction

function MarshalRDamage takes unit hero, integer lvl, real dmg returns nothing
    local real bonusDmg = 0.05+(0.05*lvl)
    local real bonusCritDmg = 5 + lvl
    
    set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*bonusDmg)

    if luckylogic( hero, MARSHAL_R_CHANCE, 1, 100 ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*bonusCritDmg)
        set udg_DamageEventType = udg_DamageTypeCriticalStrike
    endif
    
    set hero = null
endfunction

function EntW_Stun takes unit target, group affected returns nothing
    local unit u 
    loop
        set u = FirstOfGroup(affected)
        exitwhen u == null
        if unitst( u, target, "enemy" ) then
            call UnitStun(target, u, CORRUPTED_ENT_W_DAMAGE_STUN_DURATION )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", u, "origin" ) )
        endif
        call GroupRemoveUnit(affected,u)
    endloop
    set u = null
endfunction

function EntW_Damage takes unit target, unit dealer returns nothing
    local integer unitId = GetHandleId( target )
    local real damage = udg_DamageEventAmount * LoadReal(udg_hash, unitId, StringHash("entw") )
    local real summary = LoadReal(udg_hash, unitId, StringHash("entwsum") ) + damage
    local boolean isWork = LoadBoolean(udg_hash, unitId, StringHash("entwwrk") )
    local group affected = LoadGroupHandle(udg_hash, GetHandleId( target ), StringHash("entwg") )
    
    call SaveReal(udg_hash, unitId, StringHash("entwsum"), summary )
    
    set udg_DamageEventAmount = udg_DamageEventAmount - damage
    call SetUnitState( dealer, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( dealer, UNIT_STATE_LIFE) - damage ))
    
    if IsUnitInGroup(dealer, affected) == false and IsUnitAlive(dealer) then
        call GroupAddUnit(affected, dealer)
    endif
    
    if summary >= CORRUPTED_ENT_W_DAMAGE_STUN_LIMIT and isWork == false then
        call SaveBoolean(udg_hash, unitId, StringHash("entwwrk"), true )
        call EntW_Stun(target, affected)
    endif
endfunction

endlibrary