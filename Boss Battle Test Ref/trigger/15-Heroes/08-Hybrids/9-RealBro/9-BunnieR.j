function Trig_BunnieR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BC'
endfunction

function Trig_BunnieR_Actions takes nothing returns nothing
    local unit caster
    local unit owner
    local real time
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1BC'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rlbar" ) )
    endif
    
    set owner = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "rlbqac" ) )
    if GetUnitState( owner, UNIT_STATE_LIFE) > 0.405 then
        set time = 0.25+(0.25*lvl)
        call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\TimeUpheaval.mdx", owner, "origin" ) )
        call UnitReduceCooldown( owner, time )
    endif
    
    set caster = null
    set owner = null
endfunction

//===========================================================================
function InitTrig_BunnieR takes nothing returns nothing
    set gg_trg_BunnieR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BunnieR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BunnieR, Condition( function Trig_BunnieR_Conditions ) )
    call TriggerAddAction( gg_trg_BunnieR, function Trig_BunnieR_Actions )
endfunction

