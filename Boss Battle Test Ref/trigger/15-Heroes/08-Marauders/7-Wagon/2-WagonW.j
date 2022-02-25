globals
    constant real MEAT_WAGON_W_DURATION = 20
endglobals

function Trig_WagonW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05G'
endfunction

function WagonWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "wgnw1" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "wgnw1" ) ) 
    local group g = CreateGroup()
    local unit u

    if  GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, GetUnitX(dummy), GetUnitY(dummy), 200, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set dummy = null
endfunction

function WagonWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "wgnwt" ) ) - 1
    local real dmg = LoadReal( udg_hash, id, StringHash( "wgnw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wgnw" ) ) 
    local integer id1

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( caster ) ) then
        call dummyspawn( caster, 15, 'A0N5', 'A0CH', 0 )
        
        set id1 = GetHandleId( bj_lastCreatedUnit )
        if LoadTimerHandle( udg_hash, id1, StringHash( "wgnw1" ) ) == null then
            call SaveTimerHandle( udg_hash, id1, StringHash( "wgnw1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "wgnw1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "wgnw1" ), bj_lastCreatedUnit )
        call SaveReal( udg_hash, id1, StringHash( "wgnw1" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "wgnw1" ) ), 1, true, function WagonWEnd )
    endif

    if counter > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'A08T' ) > 0 and not( IsUnitLoaded( caster ) ) then
        call SaveReal( udg_hash, id, StringHash( "wgnwt" ), counter )
    else
        call UnitRemoveAbility( caster, 'A08T' )
        call UnitRemoveAbility( caster, 'B08D' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set caster = null
endfunction

function Trig_WagonW_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local integer lvl
    local unit caster
    local integer sp
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A05G'), caster, 64, 90, 10, 1.5 )
        set t = MEAT_WAGON_W_DURATION
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = MEAT_WAGON_W_DURATION
    endif
    set t = timebonus(caster, t)
    
    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Human\\HCancelDeath\\HCancelDeath.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    set dmg = (8+(4 * lvl)) * GetUnitSpellPower(caster)
    call UnitAddAbility( caster, 'A08T' )
    
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "wgnw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "wgnw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wgnw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wgnw" ), caster )
    call SaveReal( udg_hash, id, StringHash( "wgnw" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "wgnwt" ), t/3 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "wgnw" ) ), 3, true, function WagonWCast )
    
    if BuffLogic() then
        call effst( caster, caster, null, lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_WagonW takes nothing returns nothing
    set gg_trg_WagonW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WagonW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WagonW, Condition( function Trig_WagonW_Conditions ) )
    call TriggerAddAction( gg_trg_WagonW, function Trig_WagonW_Actions )
endfunction

