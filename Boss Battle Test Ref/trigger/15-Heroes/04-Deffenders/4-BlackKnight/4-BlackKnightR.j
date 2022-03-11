function Trig_BlackKnightR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A100'
endfunction

function BlackKnightRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "blkr" ) )
    
    if GetUnitAbilityLevel( u, 'A107' ) > 0 then
        call pausest( u, -1 )
        call UnitRemoveAbility( u, 'A107' )
        call UnitRemoveAbility( u, 'B04A' )
    endif
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function Trig_BlackKnightR_Actions takes nothing returns nothing 
    local unit caster
    local unit target
    local integer lvl
    local integer id
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A100'), caster, 64, 90, 10, 1.5 )
        set t = 4 + ( 2 * lvl )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 4 + ( 2 * lvl )
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    
    if GetUnitAbilityLevel( target, 'A107' ) == 0 then
        call pausest( target, 1 )
    endif
    call UnitAddAbility( target, 'A107' )
    call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl", target, "chest" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "blkr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "blkr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "blkr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "blkr" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "blkr" ) ), t, false, function BlackKnightRCast )
    
    if BuffLogic() then
        if IsUnitAlly( target, GetOwningPlayer(caster)) then
            call effst( caster, target, "Trig_BlackKnightR_Actions", lvl, t )
        else
            call debuffst( caster, target, "Trig_BlackKnightR_Actions", lvl, t )
        endif
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BlackKnightR takes nothing returns nothing
    set gg_trg_BlackKnightR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BlackKnightR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BlackKnightR, Condition( function Trig_BlackKnightR_Conditions ) )
    call TriggerAddAction( gg_trg_BlackKnightR, function Trig_BlackKnightR_Actions )
endfunction

