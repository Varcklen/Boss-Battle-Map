function Trig_OrbManaburn_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0HN'
endfunction

function Trig_OrbManaburn_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer i
    local unit caster
    local unit target
    local item it
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0HN'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set i = GetPlayerId(GetOwningPlayer(caster) ) + 1
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\ForkedLightningOrange.mdx", GetUnitX( target ), GetUnitY( target ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, target, udg_OrbManaburn[i], true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    if combat( caster, false, 0 ) and not(udg_fightmod[3]) then
        set udg_OrbManaburn[i] = 0
        set it = GetItemOfTypeFromUnitBJ(caster, 'I0AN')
        call BlzSetItemIconPath( it, words( caster, BlzGetItemDescription(it), "|cFF959697(", ")|r", "0/2000" ) )
    endif
    
    set caster = null
    set target = null
    set it = null
endfunction

//===========================================================================
function InitTrig_OrbManaburn takes nothing returns nothing
    set gg_trg_OrbManaburn = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbManaburn, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbManaburn, Condition( function Trig_OrbManaburn_Conditions ) )
    call TriggerAddAction( gg_trg_OrbManaburn, function Trig_OrbManaburn_Actions )
endfunction

