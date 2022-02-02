function Trig_Clock_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0C6') > 0
endfunction

function ClockCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call coldstop( LoadUnitHandle( udg_hash, id, StringHash( "clck" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Clock_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1
    local integer id = GetHandleId( GetSpellAbilityUnit() )
    local integer s = LoadInteger( udg_hash, id, StringHash( "clck" ) ) 
    
    call SaveInteger( udg_hash, id, StringHash( "clck" ), s + 1 )
    set s = LoadInteger( udg_hash, id, StringHash( "clck" ) ) 
    if s < 15 then
        call textst( "|c00FFFF00 " + I2S(s), GetSpellAbilityUnit(), 64, 90, 15, 1.5 )
    else
        call textst( "|c00808040 RESET", GetSpellAbilityUnit(), 64, 90, 15, 1.5 )
        call SaveInteger( udg_hash, id, StringHash( "clck" ), 0 )
        call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\Sci Teleport.mdx", GetSpellAbilityUnit(), "origin"))
        
        call SaveTimerHandle( udg_hash, id, StringHash( "clck" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "clck" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "clck" ), GetSpellAbilityUnit() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "clck" ) ), 0.1, false, function ClockCast )
    endif      
endfunction

//===========================================================================
function InitTrig_Clock takes nothing returns nothing
    set gg_trg_Clock = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Clock, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Clock, Condition( function Trig_Clock_Conditions ) )
    call TriggerAddAction( gg_trg_Clock, function Trig_Clock_Actions )
endfunction

