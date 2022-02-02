globals
    constant integer CORRUPTED_ENT_W_DURATION_FIRST_LEVEL = 5
    constant integer CORRUPTED_ENT_W_DURATION_LEVEL_BONUS = 1
    
    constant real CORRUPTED_ENT_W_REDUCTION_BONUS_FIRST_LEVEL = 0.3
    constant real CORRUPTED_ENT_W_REDUCTION_BONUS_LEVEL_BONUS = 0.1
    
    constant integer CORRUPTED_ENT_W_BONUS_DURATION = 2
    
    constant integer CORRUPTED_ENT_W_DAMAGE_STUN_LIMIT = 200
    constant integer CORRUPTED_ENT_W_DAMAGE_STUN_DURATION = 3
endglobals

function Trig_Corrupted_EntW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OF'
endfunction

function Corrupted_EntWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "entw" ) )
    local integer unitId = GetHandleId( caster )
    local integer bonusTime = LoadInteger( udg_hash, unitId, StringHash( "entw" ) )

    call DestroyTimer( GetExpiredTimer() )
    if bonusTime > 0 and GetUnitAbilityLevel( caster, 'A0OG' ) > 0 then
        call InvokeTimerWithUnit( caster, "entw", bonusTime, false, function Corrupted_EntWCast )
    else
        call UnitRemoveAbility(caster, 'A0OG')
        call UnitRemoveAbility(caster, 'B09Y')
    endif
    call SaveInteger( udg_hash, unitId, StringHash( "entw" ), 0 )
    
    set caster = null
endfunction

function Trig_Corrupted_EntW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real t
    local integer id
    local real reduction
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        set t = CORRUPTED_ENT_W_DURATION_FIRST_LEVEL + (lvl * CORRUPTED_ENT_W_DURATION_LEVEL_BONUS)
        call textst( udg_string[0] + GetObjectName('A0OF'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = CORRUPTED_ENT_W_DURATION_FIRST_LEVEL + (lvl * CORRUPTED_ENT_W_DURATION_LEVEL_BONUS)
    endif
    
    set reduction = CORRUPTED_ENT_W_REDUCTION_BONUS_FIRST_LEVEL + (lvl * CORRUPTED_ENT_W_REDUCTION_BONUS_LEVEL_BONUS)

    call UnitAddAbility(target, 'A0OG')
    set id = InvokeTimerWithUnit( target, "entw", t, false, function Corrupted_EntWCast )
    call SaveReal(udg_hash, GetHandleId( target ), StringHash("entw"), reduction )
    call SaveGroupHandle(udg_hash, GetHandleId( target ), StringHash("entwg"), CreateGroup())

    call effst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Corrupted_EntW takes nothing returns nothing
    set gg_trg_Corrupted_EntW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Corrupted_EntW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Corrupted_EntW, Condition( function Trig_Corrupted_EntW_Conditions ) )
    call TriggerAddAction( gg_trg_Corrupted_EntW, function Trig_Corrupted_EntW_Actions )
endfunction

scope CorruptedEntW initializer Triggs
    private function BuffDelete takes nothing returns nothing
        if GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0OG') > 0 then
            call UnitRemoveAbility(Event_DeleteBuff_Unit, 'A0OG')
            call UnitRemoveAbility(Event_DeleteBuff_Unit, 'B09Y')
        endif
    endfunction

    private function Use_Condition takes nothing returns boolean
        return GetUnitAbilityLevel( Event_Corrupted_End_Q_Unit, 'A0OG') > 0
    endfunction
    
    private function Use takes nothing returns nothing
        local integer unitId = GetHandleId( Event_Corrupted_End_Q_Unit )
        local integer bonusTime = LoadInteger( udg_hash, unitId, StringHash( "entw" ) )

        call SaveInteger( udg_hash, unitId, StringHash( "entw" ), bonusTime + CORRUPTED_ENT_W_BONUS_DURATION )
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "Event_Corrupted_End_Q_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function Use_Condition ) )
        call TriggerAddAction( trig, function Use)
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "Event_DeleteBuff_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function BuffDelete)
        
        set trig = null
    endfunction
endscope
