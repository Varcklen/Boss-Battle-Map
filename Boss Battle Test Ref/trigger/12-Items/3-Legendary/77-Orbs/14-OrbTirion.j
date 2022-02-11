function Trig_OrbTirion_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and luckylogic( udg_DamageEventSource, 15, 1, 100 ) and inv( udg_DamageEventSource, 'I0FK') > 0
endfunction

function OrbTirionCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbtr" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "orbtrс" ) ) 
    local integer cyclA = 1
    local group g = CreateGroup()
    local group h = CreateGroup()
    local group n = CreateGroup()
    local unit u
    local real t = timebonus(caster, 4)
    
    call dummyspawn( caster, 1, 0, 0 , 0 )
    loop
        exitwhen cyclA > 1
        call DestroyEffect( AddSpecialEffect("AngelSkinQ.mdx", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, target, 100, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        call taunt( caster, target, t )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 350, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and u != target and not( IsUnitInGroup(u , n ) ) then
                call GroupAddUnit(h, u)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if not( IsUnitGroupEmptyBJ(h) ) then
            set cyclA = cyclA - 1
            set target = GroupPickRandomUnit(h)
            call GroupRemoveUnit(h, target)
            call GroupAddUnit(n, target)
        endif
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( h )
    call DestroyGroup( h )
    call GroupClear( n )
    call DestroyGroup( n )
    set n = null
    set g = null
    set h = null
    set u = null
    set caster = null
    set target = null
endfunction

function Trig_OrbTirion_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "orbtr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "orbtr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbtr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "orbtr" ), udg_DamageEventSource )
    call SaveUnitHandle( udg_hash, id, StringHash( "orbtrс" ), udg_DamageEventTarget )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "orbtr" ) ), 0.01, false, function OrbTirionCast )
endfunction

//===========================================================================
function InitTrig_OrbTirion takes nothing returns nothing
    set gg_trg_OrbTirion = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_OrbTirion, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_OrbTirion, Condition( function Trig_OrbTirion_Conditions ) )
    call TriggerAddAction( gg_trg_OrbTirion, function Trig_OrbTirion_Actions )
endfunction

