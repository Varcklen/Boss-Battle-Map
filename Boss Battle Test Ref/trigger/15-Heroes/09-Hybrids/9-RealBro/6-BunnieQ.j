function Trig_BunnieQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BA'
endfunction

function Trig_BunnieQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target = null
    local real heal
    local real mana
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1BA'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "rlbaq" ) )
    endif

	set heal = 30 + ( 30 * lvl )
    set mana = 10 + ( 5 * lvl )
    
    set target = HeroLessHP(caster)
    if target != null then
        call healst( caster, target, heal )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl", target, "origin" ) )
    endif
    set target = HeroLessMP(caster)
    if target != null then
        call manast( caster, target, mana )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl", target, "origin" ) )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BunnieQ takes nothing returns nothing
    set gg_trg_BunnieQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BunnieQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BunnieQ, Condition( function Trig_BunnieQ_Conditions ) )
    call TriggerAddAction( gg_trg_BunnieQ, function Trig_BunnieQ_Actions )
endfunction

