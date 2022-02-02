function Trig_Gnomish_Soulspin_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A18G' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Gnomish_SoulspinEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "gmsp" ) )
    local integer cyclA 
    local integer cyclB = 1
    local integer cyclBEnd = LoadInteger( udg_hash, id, StringHash( "gmspcast" ) )
    
    loop
        exitwhen cyclB > cyclBEnd
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(u)) then
                call healst( u, udg_hero[cyclA], GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * 0.4 )
                call manast( u, udg_hero[cyclA], GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) * 0.4 )
            endif
            set cyclA = cyclA + 1
        endloop
        set cyclB = cyclB + 1
    endloop
    call heroswap()
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Trig_Gnomish_Soulspin_Actions takes nothing returns nothing
    local unit caster
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A18G'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    if not(udg_fightmod[3]) then
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "gmsp" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "gmsp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gmsp" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "gmsp" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "gmspcast" ), eyest( caster ) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId(caster), StringHash( "gmsp" ) ), 0.01, false, function Gnomish_SoulspinEnd )
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_Gnomish_Soulspin takes nothing returns nothing
    set gg_trg_Gnomish_Soulspin = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Gnomish_Soulspin, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Gnomish_Soulspin, Condition( function Trig_Gnomish_Soulspin_Conditions ) )
    call TriggerAddAction( gg_trg_Gnomish_Soulspin, function Trig_Gnomish_Soulspin_Actions )
endfunction

