function Trig_Jet_Boots_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0PH'
endfunction

function Jet_BootsCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "jtbt" ) ), 'A0PJ' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "jtbt" ) ), 'B04R' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Jet_Boots_Actions takes nothing returns nothing
    local integer id
    local real r
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0PH'), caster, 64, 90, 10, 1.5 )
        set t = 8 + (2*SetCount_GetPieces(caster, SET_MECH))
    else
        set caster = GetSpellAbilityUnit()
        set t = 8 + (2*SetCount_GetPieces(caster, SET_MECH))
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", caster, "origin" ) )
    call UnitAddAbility( caster, 'A0PJ' )
    call SetUnitAbilityLevel( caster, 'A0PI', eyest( caster ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "jtbt" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "jtbt" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "jtbt" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "jtbt" ), caster )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "jtbt" ) ), t, false, function Jet_BootsCast )
    
    if BuffLogic() then
        call effst( caster, caster, null, 1, t )
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_Jet_Boots takes nothing returns nothing
    set gg_trg_Jet_Boots = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Jet_Boots, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Jet_Boots, Condition( function Trig_Jet_Boots_Conditions ) )
    call TriggerAddAction( gg_trg_Jet_Boots, function Trig_Jet_Boots_Actions )
endfunction

