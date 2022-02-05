//TESH.scrollpos=7
//TESH.alwaysfold=0
function Trig_ResMag_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0WY'
endfunction

function ResMagCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "rsmg" ) ), 'A0WX' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "rsmg" ) ), 'B05E' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_ResMag_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0WY'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set t = 10
    endif
    set id = GetHandleId( caster )
    
    call UnitAddAbility( caster, 'A0WX' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "rsmg" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "rsmg" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "rsmg" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "rsmg" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "rsmg" ) ), t, false, function ResMagCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_ResMag_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ResMag takes nothing returns nothing
    set gg_trg_ResMag = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ResMag, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ResMag, Condition( function Trig_ResMag_Conditions ) )
    call TriggerAddAction( gg_trg_ResMag, function Trig_ResMag_Actions )
endfunction

