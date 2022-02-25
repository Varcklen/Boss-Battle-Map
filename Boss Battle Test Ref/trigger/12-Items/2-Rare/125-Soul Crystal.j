function Trig_Soul_Crystal_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13M'
endfunction

function Trig_Soul_Crystal_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local unit caster
    local unit target
    local real dmg
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A13M'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set i = GetPlayerId(GetOwningPlayer( caster ) ) + 1
    set dmg = 200 + udg_Item_Souls[i]
    if udg_combatlogic[i] and not(udg_fightmod[3]) then
        set udg_Item_Souls[i] = 0
    endif
    
    call ChangeToolItem( caster, 'I0BR', "|cffbe81f2", "|r", "200" )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ForkedLightningOrange.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    set cyclA = 1
    set cyclAEnd = eyest(caster)
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Soul_Crystal takes nothing returns nothing
    set gg_trg_Soul_Crystal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Soul_Crystal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Soul_Crystal, Condition( function Trig_Soul_Crystal_Conditions ) )
    call TriggerAddAction( gg_trg_Soul_Crystal, function Trig_Soul_Crystal_Actions )
endfunction

