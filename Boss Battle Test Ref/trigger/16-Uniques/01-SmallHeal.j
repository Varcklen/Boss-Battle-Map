function Trig_SmallHeal_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0AG' or GetSpellAbilityId() == 'A02W'
endfunction

function TestExecute takes nothing returns nothing
    call BJDebugMsg("Function is executed!")
endfunction

function Trig_SmallHeal_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0AG'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set heal = 100 * udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer(caster)) + 1]
    if IsUniqueUpgraded(caster) then
        set heal = heal*2
    endif
    call healst( caster, target, heal )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" , target, "origin" ) )
    
    //call TimerExecute( caster, "test", 1, false, function TestExecute )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SmallHeal takes nothing returns nothing
    set gg_trg_SmallHeal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SmallHeal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SmallHeal, Condition( function Trig_SmallHeal_Conditions ) )
    call TriggerAddAction( gg_trg_SmallHeal, function Trig_SmallHeal_Actions )
endfunction

