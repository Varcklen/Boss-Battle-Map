function Trig_DevourerE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0TJ'
endfunction

function Trig_DevourerE_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real mgc
    local real spd
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0TJ'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    
    set mgc = 0.1+(0.1*lvl)
    set spd = 0.5+(0.5*lvl)
    
    call SaveReal( udg_hash, GetHandleId(target), StringHash( "dvre" ), mgc )
    call SaveReal( udg_hash, GetHandleId(target), StringHash( "dvred" ), spd )
    call SaveUnitHandle( udg_hash, GetHandleId(target), StringHash( "dvred" ), caster )
    
    call bufst( caster, target, 'A10I', 'B05Y', "dvre1", t )
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DevourerE takes nothing returns nothing
    set gg_trg_DevourerE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DevourerE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DevourerE, Condition( function Trig_DevourerE_Conditions ) )
    call TriggerAddAction( gg_trg_DevourerE, function Trig_DevourerE_Actions )
endfunction

