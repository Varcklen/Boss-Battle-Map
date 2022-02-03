function Trig_Rage_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19S'
endfunction

function RageCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "rage" ) )
    local integer r = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "rage" ) )

    call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - r, 0 )
    call UnitRemoveAbility( u, 'A19T' )
    call UnitRemoveAbility( u, 'B038' )
    call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "rage" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Rage_Actions takes nothing returns nothing
    local integer id 
    local integer r
    local integer rsum
    local real b
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A19S'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set t = 20
    endif
    set t = timebonus(caster, t)
    
    call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) - LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rage" ) ), 0 )
    call RemoveSavedInteger( udg_hash, GetHandleId( caster ), StringHash( "rage" ) )

    set b = 0.25
    if LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "kill" ) ) then
        set b = b*2
    endif
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", caster, "origin" ) )
    set r = R2I(GetUnitDamage(caster)*b)
    set rsum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rage" ) ) + r
    call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) + r, 0 )
    call UnitAddAbility( caster, 'A19T')
    
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "rage" ) ) == null then
        call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "rage" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "rage" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "rage" ), caster )
    call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "rage" ), rsum )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "rage" ) ), t, false, function RageCast ) 
    
    call effst( caster, caster, null, 1, t )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Rage takes nothing returns nothing
    set gg_trg_Rage = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Rage, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Rage, Condition( function Trig_Rage_Conditions ) )
    call TriggerAddAction( gg_trg_Rage, function Trig_Rage_Actions )
endfunction

