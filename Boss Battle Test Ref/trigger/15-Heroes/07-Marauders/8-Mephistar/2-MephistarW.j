function Trig_MephistarW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A149'
endfunction

function Trig_MephistarW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer rand
    local integer lvl
    local integer i
    local real hp
    local real mp
    local real r
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "notcaster", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A149'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set r = 0.8+(0.2*lvl)
    
    if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
        set i = GetPlayerId( GetOwningPlayer( target ) ) + 1
        set rand = GetRandomInt( 1, 6 )
        if rand == 1 then
            call statst( target, 1, 0, 0, 0, true )
            call textst( "|c00FF2020 +1 strength", target, 64, 90, 10, 1 )
        elseif rand == 2 then
            call statst( target, 0, 1, 0, 0, true )
            call textst( "|c0020FF20 +1 agility", target, 64, 90, 10, 1 )
        elseif rand == 3 then
            call statst( target, 0, 0, 1, 0, true )
            call textst( "|c002020FF +1 intelligence", target, 64, 90, 10, 1 )
        elseif rand == 4 then
            call luckyst( target, 1 )
            call textst( "|cFFFE8A0E +1 luck", target, 64, 90, 10, 1 )
        elseif rand == 5 then
            call spdst( target, 1 )
            call textst( "|cFF7EBFF1 +1"+udg_perc+" spell power", target, 64, 90, 10, 1 )
        elseif rand == 6 then
            call moneyst( target, 75 )
            call textst( "|cFFFFFC01 +75 gold", target, 64, 90, 10, 1 )
        endif
    endif

    set hp = RMinBJ(GetUnitState( target, UNIT_STATE_MAX_LIFE) * 0.15,GetUnitState( target, UNIT_STATE_LIFE) )
    set mp = RMinBJ(GetUnitState( target, UNIT_STATE_MAX_MANA) * 0.15,GetUnitState( target, UNIT_STATE_MANA) )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX(caster), GetUnitY(caster) ) )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX(target), GetUnitY(target) ) )
    
    call SetUnitState( target, UNIT_STATE_LIFE, RMaxBJ(10, GetUnitState( target, UNIT_STATE_LIFE) - RMinBJ(GetUnitState( caster, UNIT_STATE_MAX_LIFE)-GetUnitState( caster, UNIT_STATE_LIFE), hp) ) )
    call SetUnitState( target, UNIT_STATE_MANA, RMaxBJ(10, GetUnitState( target, UNIT_STATE_MANA) - RMinBJ(GetUnitState( caster, UNIT_STATE_MAX_MANA)-GetUnitState( caster, UNIT_STATE_MANA), mp) ) )
    
    call healst( caster, null, hp*r )
    call manast( caster, null, mp*r )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MephistarW takes nothing returns nothing
    set gg_trg_MephistarW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MephistarW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MephistarW, Condition( function Trig_MephistarW_Conditions ) )
    call TriggerAddAction( gg_trg_MephistarW, function Trig_MephistarW_Actions )
endfunction

