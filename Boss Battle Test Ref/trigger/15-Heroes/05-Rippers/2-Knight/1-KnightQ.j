function Trig_KnightQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05N' or GetSpellAbilityId() == 'A0TZ'
endfunction

function Trig_KnightQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set target = randomtarget( caster, 300, "all", "notcaster", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A05N'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    elseif GetSpellAbilityId() == 'A0TZ' then
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "kngeq" ) )
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg =  100 + ( 60 * lvl )
    
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC)
     
    if not(IsUnitType( target, UNIT_TYPE_HERO)) and not(IsUnitType( target, UNIT_TYPE_ANCIENT)) then
        call healst( caster, null, dmg )
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
    endif
     
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_KnightQ takes nothing returns nothing
    set gg_trg_KnightQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KnightQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KnightQ, Condition( function Trig_KnightQ_Conditions ) )
    call TriggerAddAction( gg_trg_KnightQ, function Trig_KnightQ_Actions )
endfunction

