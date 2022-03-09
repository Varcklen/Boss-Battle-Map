function Trig_AdventurerR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A12T'
endfunction

function AdventurerRSpell takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "advr" ) )

    call UnitRemoveAbility( u, 'A12V' )
    call UnitRemoveAbility( u, 'B05W' )
    call FlushChildHashtable( udg_hash, id )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "advrd" ) )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "advrm" ) )
    
    set u = null
endfunction

function Trig_AdventurerR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A12T'), caster, 64, 90, 10, 1.5 )
        set t = 25
        if target == null then
            set caster = null
            return
        endif
    elseif GetSpellAbilityId() == 'A0UL' then
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = 3
        set t = 25
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 25 
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A12V' )

    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "advr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "advr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "advr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "advr" ), target )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "advrd" ), 1 - (0.07 * lvl) )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "advrm" ), 4 + (4 * lvl) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "advr" ) ), t, false, function AdventurerRSpell )

    if BuffLogic() then
        call effst( caster, target, "Trig_AdventurerR_Actions", lvl, t )
    endif

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AdventurerR takes nothing returns nothing
    set gg_trg_AdventurerR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdventurerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AdventurerR, Condition( function Trig_AdventurerR_Conditions ) )
    call TriggerAddAction( gg_trg_AdventurerR, function Trig_AdventurerR_Actions )
endfunction

