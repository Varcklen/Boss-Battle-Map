function HronoSpeed takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitResetCooldown( LoadUnitHandle( udg_hash, id, StringHash( "hrspeed" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Hronospeed_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetSpellAbilityUnit() )

    if IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo) and 4 >= GetRandomInt( 1, 100 ) then
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\Sci Teleport.mdx", GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ) ) )

        if LoadTimerHandle( udg_hash, id, StringHash( "hrspeed" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "hrspeed" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrspeed" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "hrspeed" ), GetSpellAbilityUnit() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "hrspeed" ) ), 0.1, false, function HronoSpeed ) 
    endif
endfunction

//===========================================================================
function InitTrig_Hronospeed takes nothing returns nothing
    set gg_trg_Hronospeed = CreateTrigger(  )
    call DisableTrigger( gg_trg_Hronospeed )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Hronospeed, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddAction( gg_trg_Hronospeed, function Trig_Hronospeed_Actions )
endfunction

