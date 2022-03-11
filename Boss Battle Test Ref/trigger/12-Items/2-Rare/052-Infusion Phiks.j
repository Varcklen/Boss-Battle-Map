function Trig_Infusion_Phiks_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A15H'
endfunction

function Infusion_PhiksCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "ifph" ) ) - 1
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ifph" ) )
    
    if p < 0 or GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set udg_Caster = u
        set udg_RandomLogic = true
        call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt( 1, 10 )] )
    endif

    call SaveInteger( udg_hash, id, StringHash( "ifph" ), p ) 
    set u = null
endfunction

function Trig_Infusion_Phiks_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer cyclA = 0
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A15H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    if AlchemyOnly(caster) then
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "ifph" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "ifph" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ifph" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "ifph" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "ifph" ), 2*cyclAEnd )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "ifph" ) ), 1, true, function Infusion_PhiksCast )
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > cyclAEnd
        set udg_Caster = caster
        set udg_RandomLogic = true
        call TriggerExecute( udg_DB_Trigger_Pot[GetRandomInt( 1, 10 )] )
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Infusion_Phiks takes nothing returns nothing
    set gg_trg_Infusion_Phiks = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Infusion_Phiks, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Infusion_Phiks, Condition( function Trig_Infusion_Phiks_Conditions ) )
    call TriggerAddAction( gg_trg_Infusion_Phiks, function Trig_Infusion_Phiks_Actions )
endfunction

