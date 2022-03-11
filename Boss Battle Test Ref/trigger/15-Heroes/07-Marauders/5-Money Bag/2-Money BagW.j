function Trig_Money_BagW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17V'
endfunction

function Trig_Money_BagW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local unit u
    local integer lvl
    local real mana
    local real bonus
    local real sum
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A17V'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set mana = RMinBJ(50,GetUnitState( target, UNIT_STATE_MANA) )
    set bonus = (lvl-1)*15
    
    set sum = mana+bonus
    
    call SetUnitState( target, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( target, UNIT_STATE_MANA) - mana ))
    call manast( caster, null, sum )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", target, "origin") )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", caster, "origin") )

    set u = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ) )
    if GetUnitAbilityLevel(u, 'A17U') > 0 and target != u then
    	call manast( caster, u, sum )
    	call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", u, "origin") )
    endif
    
    set caster = null
    set target = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Money_BagW takes nothing returns nothing
    set gg_trg_Money_BagW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Money_BagW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Money_BagW, Condition( function Trig_Money_BagW_Conditions ) )
    call TriggerAddAction( gg_trg_Money_BagW, function Trig_Money_BagW_Actions )
endfunction

