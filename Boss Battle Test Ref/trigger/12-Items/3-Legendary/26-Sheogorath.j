function Trig_Sheogorath_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17C' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function SheogorathCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "shgrt" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shgr" ) )
    local integer rand

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then 
        set rand = GetRandomInt( 1, 3 )
        if rand == 1 then
            call CastRandomAbility(caster, GetRandomInt( 1, 5 ), udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
        elseif rand == 2 then
            call CastRandomAbility(caster, GetRandomInt( 1, 5 ), udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
        else
            call CastRandomAbility(caster, GetRandomInt( 1, 5 ), udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
        endif
    endif
    if counter > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'A17E' ) > 0 and not( IsUnitLoaded( caster ) ) then
        call SaveReal( udg_hash, id, StringHash( "shgrt" ), counter - 1 )
    else
        call UnitRemoveAbility( caster, 'A17E' )
        call UnitRemoveAbility( caster, 'B07I' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    set caster = null
endfunction

function Trig_Sheogorath_Actions takes nothing returns nothing
    local integer id
    local integer lvl
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A17C'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 10
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )

    call UnitAddAbility( caster, 'A17E' )
    if LoadTimerHandle( udg_hash, id, StringHash( "shgr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "shgr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shgr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shgr" ), caster )
    	call SaveReal( udg_hash, id, StringHash( "shgrt" ), t )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shgr" ) ), 1, true, function SheogorathCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_Sheogorath_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Sheogorath takes nothing returns nothing
    set gg_trg_Sheogorath = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheogorath, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheogorath, Condition( function Trig_Sheogorath_Conditions ) )
    call TriggerAddAction( gg_trg_Sheogorath, function Trig_Sheogorath_Actions )
endfunction

