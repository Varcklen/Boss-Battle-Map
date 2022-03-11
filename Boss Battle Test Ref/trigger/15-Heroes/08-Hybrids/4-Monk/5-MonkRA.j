function Trig_MonkRA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'B01O') > 0 and udg_IsDamageSpell == false
endfunction

function Trig_MonkRA_Actions takes nothing returns nothing
    local integer id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mnkr" ) ) ) 
    local integer i = LoadInteger( udg_hash, id, StringHash( "mnkr" ) ) - 1
    
    call SaveInteger( udg_hash, id, StringHash( "mnkr" ), i )

    if i <= 0 then
        call UnitRemoveAbility( udg_DamageEventSource, 'A0KE' )
        call UnitRemoveAbility( udg_DamageEventSource, 'B01O' )
        call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "mnkr" ) ) )
        call FlushChildHashtable( udg_hash, id )
    endif
endfunction

//===========================================================================
function InitTrig_MonkRA takes nothing returns nothing
    call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_MonkRA_Actions, function Trig_MonkRA_Conditions )
endfunction

