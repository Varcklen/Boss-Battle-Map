function Trig_NinjaW_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0LS'
endfunction

function NinjaWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "ninw" ) ) + 1
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "ninw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "ninwc" ) )
    local unit u
    local real NewX = GetUnitX( dummy ) + 42 * Cos( 0.017 * GetUnitFacing( dummy ) )
    local real NewY = GetUnitY( dummy ) + 42 * Sin( 0.017 * GetUnitFacing( dummy ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "ninw" ) )
    local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "ninwg" ) )
    local group g = CreateGroup()

    if counter >= 18 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call GroupClear( nodmg )
        call DestroyGroup( nodmg )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call SetUnitPosition( dummy, NewX, NewY )
        call SaveInteger( udg_hash, id, StringHash( "ninw" ), counter )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 125, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call GroupAddUnit( nodmg, u )
                call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "ninwb" ), true )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set nodmg = null
    set dummy = null
endfunction

function NinjaWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "ninw1" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "ninw1" ) )
    local integer cyclA = 1
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        if not(LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "ninwb" ) )) then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "ninwb" ), false )
            set cyclA = 1
            loop
                exitwhen cyclA > 3
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ) , GetUnitY( caster ), GetUnitFacing( caster ) + ( -70 + ( cyclA * 35 ) ) ) 
                call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
                call UnitAddAbility( bj_lastCreatedUnit, 'A0M8')
                
                set id1 = GetHandleId( bj_lastCreatedUnit )
                call SaveTimerHandle( udg_hash, id1, StringHash( "ninw" ), CreateTimer() )
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "ninw" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "ninw" ), bj_lastCreatedUnit )
                call SaveUnitHandle( udg_hash, id1, StringHash( "ninwc" ), caster )
                call SaveGroupHandle( udg_hash, id1, StringHash( "ninwg" ), CreateGroup() )
                call SaveReal( udg_hash, id1, StringHash( "ninw" ), dmg )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "ninw" ) ), 0.04, true, function NinjaWCast )
                set cyclA = cyclA + 1
            endloop
        endif
    endif
    
    set caster = null
endfunction

function Trig_NinjaW_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local integer id
    local real dmg
    local integer cyclA = 1
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0LS'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = (25+( 10 * lvl )) * GetUnitSpellPower(caster)
    
    loop
        exitwhen cyclA > 3
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ) , GetUnitY( caster ), GetUnitFacing( caster ) + ( -50 + ( cyclA * 25 ) ) ) 
        call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
        call UnitAddAbility( bj_lastCreatedUnit, 'A0M8')
        
        set id = GetHandleId( bj_lastCreatedUnit )
        call SaveTimerHandle( udg_hash, id, StringHash( "ninw" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ninw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "ninw" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "ninwc" ), caster )
        call SaveGroupHandle( udg_hash, id, StringHash( "ninwg" ), CreateGroup() )
        call SaveReal( udg_hash, id, StringHash( "ninw" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "ninw" ) ), 0.04, true, function NinjaWCast )
        set cyclA = cyclA + 1
    endloop

    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "ninw1" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "ninw1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "ninw1" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "ninw1" ), caster )
    call SaveReal( udg_hash, id, StringHash( "ninw1" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "ninw1" ) ), 2, true, function NinjaWEnd )

    set caster = null
endfunction

//===========================================================================
function InitTrig_NinjaW takes nothing returns nothing
    set gg_trg_NinjaW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NinjaW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NinjaW, Condition( function Trig_NinjaW_Conditions ) )
    call TriggerAddAction( gg_trg_NinjaW, function Trig_NinjaW_Actions )
endfunction



