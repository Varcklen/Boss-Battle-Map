function Trig_PredatorQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A15M' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function PredatorQRun takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "prdqc" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "prdq" ) )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "prdq" ) ) + 1
    local real x = LoadReal( udg_hash, id, StringHash( "prdqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "prdqy" ) )
    local real angle = Atan2( y - GetUnitY( u ), x - GetUnitX( u ) )
    local real NewX = GetUnitX( u ) + 30 * Cos( angle )
    local real NewY = GetUnitY( u ) + 30 * Sin( angle )
	local real dmg = LoadReal( udg_hash, id, StringHash( "prdq" ))

    if counter == 8 then
        call SetUnitFlyHeight( u, -600, 1500 )
    endif

    if counter == 16 or GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
		call SetUnitFlyHeight( u, 0, 0 )
		call SetUnitPathing( u, true )
		call UnitRemoveAbility( u, 'Amrf' )
        call pausest( u, -1 )
		if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call dummyspawn( caster, 1, 0, 0, 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
		call FlushChildHashtable( udg_hash, id ) 
        call DestroyTimer( GetExpiredTimer() )
    else 
        call SaveInteger( udg_hash, id, StringHash( "prdq" ), counter )
        if RectContainsCoords(udg_Boss_Rect, NewX, NewY) then
            call SetUnitPosition( u, NewX, NewY )
        endif
    endif
    
    set caster = null
    set u = null
endfunction

function Trig_PredatorQ_Actions takes nothing returns nothing
    local real x 
    local real y
    local real dmg
    local real heal
    local real heals = 0
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    local real angle
    local real NewX
    local real NewY
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A15M'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif
    
    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )
    
    set dmg = 50 + ( 50 * lvl )
    set heal = (10*lvl)+5

    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", x, y ) )
    call GroupEnumUnitsInRange( g, x, y, 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, TARGET_ENEMY ) then
            set heals = heals + heal
            if GetUnitDefaultMoveSpeed(u) != 0 and LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "prdq" ) ) == null then
                call pausest( u, 1 )
                call UnitAddAbility( u, 'Amrf' )
                call SetUnitFlyHeight( u, 600, 1500 )
                call SetUnitPathing( u, false )
            
                set angle = Atan2( GetUnitY( u ) - GetUnitY( caster ), GetUnitX( u ) - GetUnitX( caster ) )
                set NewX = GetUnitX( u ) + 200 * Cos( angle )
                set NewY = GetUnitY( u ) + 200 * Sin( angle )
            
                set id = InvokeTimerWithUnit(u, "prdq", 0.02, true, function PredatorQRun )
                call SaveUnitHandle( udg_hash, id, StringHash( "prdqc" ), caster)
                call SaveReal( udg_hash, id, StringHash( "prdq" ), dmg)
                call SaveReal( udg_hash, id, StringHash( "prdqx" ), NewX )
                call SaveReal( udg_hash, id, StringHash( "prdqy" ), NewY )
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call healst(caster, null, heals )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_PredatorQ takes nothing returns nothing
    set gg_trg_PredatorQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PredatorQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PredatorQ, Condition( function Trig_PredatorQ_Conditions ) )
    call TriggerAddAction( gg_trg_PredatorQ, function Trig_PredatorQ_Actions )
endfunction

