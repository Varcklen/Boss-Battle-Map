function Trig_BarbarianQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A010'
endfunction

function BarbarianQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "barq" ) ), 'A0T4' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "barq" ) ), 'B01S' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_BarbarianQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "all", "pris", "", "", "" )
        set lvl = udg_Level
        set t = 16
        call textst( udg_string[0] + GetObjectName('A010'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 16
    endif
    
    set id = GetHandleId( caster )
    if not( udg_BuffLogic ) then
        set heal = GetUnitState( target, UNIT_STATE_LIFE) * ( 0.25 + ( 0.25 * lvl ) )
        
        call healst( caster, null, heal )

        call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", caster, "origin" ) )
        if not(IsUnitType( target, UNIT_TYPE_ANCIENT)) and not(IsUnitType( target, UNIT_TYPE_HERO)) then
            call KillUnit( target )
        endif
    endif
    
    if IsUnitType( target, UNIT_TYPE_UNDEAD ) or udg_BuffLogic then
        call UnitAddAbility( caster, 'A0T4' )
        call SetUnitAbilityLevel( caster, 'A0DA', lvl )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "barq" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "barq" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "barq" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "barq" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "barq" ) ), t, false, function BarbarianQCast )
        
        call effst( caster, caster, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BarbarianQ takes nothing returns nothing
    set gg_trg_BarbarianQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BarbarianQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BarbarianQ, Condition( function Trig_BarbarianQ_Conditions ) )
    call TriggerAddAction( gg_trg_BarbarianQ, function Trig_BarbarianQ_Actions )
endfunction

