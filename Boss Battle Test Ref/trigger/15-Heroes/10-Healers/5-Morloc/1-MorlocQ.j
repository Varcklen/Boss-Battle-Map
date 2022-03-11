function Trig_MorlocQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TH'
endfunction

function Trig_MorlocQ_Actions takes nothing returns nothing
    local real vam
    local unit caster
    local unit target
    local unit old
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, TARGET_ALLY, "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0TH'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set old = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mrlq" ) )
    if old != null then
        call UnitRemoveAbility( old, 'A0TD' )
        call UnitRemoveAbility( old, 'B024' )
    endif
    
    set vam = 0.1 + ( 0.15 * lvl )
    
    call UnitAddAbility( target, 'A0TD' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Devour\\DevourEffectArt.mdl", target, "origin" ) )
    call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mrlq" ), target )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "mrlqv" ), vam )
    
    call effst( caster, target, null, lvl, 1 )

    set caster = null
    set target = null
    set old = null
endfunction

//===========================================================================
function InitTrig_MorlocQ takes nothing returns nothing
    set gg_trg_MorlocQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MorlocQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MorlocQ, Condition( function Trig_MorlocQ_Conditions ) )
    call TriggerAddAction( gg_trg_MorlocQ, function Trig_MorlocQ_Actions )
endfunction

