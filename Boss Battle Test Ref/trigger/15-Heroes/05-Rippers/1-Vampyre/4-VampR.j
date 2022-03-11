function Trig_VampR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0K4' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) 
endfunction

function VampRData takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "vamr" ) )
    local integer i = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) )
    local real hp = GetUnitState( u, UNIT_STATE_LIFE) / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_LIFE))
    local real mp = GetUnitState( u, UNIT_STATE_MANA) / RMaxBJ(0,GetUnitState( u, UNIT_STATE_MAX_MANA))

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call statst( u, -i, -i, -i, 0, false )
        
        call UnitRemoveAbility( u, 'A0K6' )
        call UnitRemoveAbility( u, 'B00Q' )
        
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * hp)
        call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * mp)
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "vamr" ) )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_VampR_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local integer i
    local integer isum
    local unit caster
    local real hp
    local real mp
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0K4'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    call DestroyEffect(AddSpecialEffectTarget("Blood Explosion.mdx", caster, "origin") )

    if IsUnitType( caster, UNIT_TYPE_HERO) then
        set hp = GetUnitState( caster, UNIT_STATE_LIFE)
        set mp = GetUnitState( caster, UNIT_STATE_MANA)
    
        call UnitAddAbility( caster, 'A0K6')
        set i = 8 + ( 8 * lvl )
        set isum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "vamr" ) ) + i
        call statst( caster, i, i, i, 0, false )
        
        set id = GetHandleId( caster )
        
        if LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "vamr" ) ) == null then
            call SaveTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "vamr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "vamr" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "vamr" ), caster )
        call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "vamr" ), isum )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "vamr" ) ), t, false, function VampRData ) 
        
        call effst( caster, caster, null, lvl, t )
        
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ( 0, hp - 300 ) )
        call SetUnitState( caster, UNIT_STATE_MANA, mp )
    endif
    
    set caster = null
endfunction


//===========================================================================
function InitTrig_VampR takes nothing returns nothing
    set gg_trg_VampR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_VampR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_VampR, Condition( function Trig_VampR_Conditions ) )
    call TriggerAddAction( gg_trg_VampR, function Trig_VampR_Actions )
endfunction

