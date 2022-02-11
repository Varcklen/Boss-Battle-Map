function Trig_World_Clock_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17R' and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function TimeStopEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )

    call SaveBoolean( udg_hash, GetHandleId( LoadUnitHandle( udg_hash, id, StringHash( "tmst1" ) ) ), StringHash( "tmst1" ), false )
    call PlaySoundFromOffsetBJ( gg_snd_time_resumes, 70, 0 )
    call FlushChildHashtable( udg_hash, id )
endfunction

function TimeStopCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "tmst" ) )

    call SetUnitTimeScale( u, 1 )
    call pausest( u, -1 )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_World_Clock_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local unit caster
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A17R'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    call eyest( caster )
    if not(LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "tmst1" ) )) then
        call PlaySoundFromOffsetBJ( gg_snd_zaowlrd_audiotrimmer, 50, 0 )
    endif
    
    if GetUnitTypeId(caster) == 'N028' and not(LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "vamsec" ) ) ) then
        call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, caster, GetUnitName(caster), null, "This world belongs to ME!", bj_TIMETYPE_SET, 5, false )
        call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "vamsec" ), true )
    endif
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 5000, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "all" ) and u != caster then
            call pausest( u, 1 )
            call SetUnitTimeScale( u, 0 )
            set id = GetHandleId( u )
            
            call SaveTimerHandle( udg_hash, id, StringHash( "tmst" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "tmst" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "tmst" ), u )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "tmst" ) ), 5, false, function TimeStopCast )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Falling Light.mdx", GetUnitX(caster), GetUnitY(caster) ) )
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "tmst1" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "tmst1" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "tmst1" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "tmst1" ), caster )
    call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "tmst1" ), true )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "tmst1" ) ), 4, false, function TimeStopEnd )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_World_Clock takes nothing returns nothing
    set gg_trg_World_Clock = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_World_Clock, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_World_Clock, Condition( function Trig_World_Clock_Conditions ) )
    call TriggerAddAction( gg_trg_World_Clock, function Trig_World_Clock_Actions )
endfunction

