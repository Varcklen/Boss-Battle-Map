function Trig_BoomSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A06T'
endfunction

function Trig_BoomSub_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer k
    local integer i
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A06T'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set i = GetPlayerId(GetOwningPlayer(caster)) + 1
    set dmg = 200. * SetCount_GetPieces(caster, SET_MECH)
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call spectime("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", GetUnitX( target ), GetUnitY( target ), 8 )

        if not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), false, 0 ) then
            set k = SetCount_GetPieces(caster, SET_MECH)*10
            call BlzSetUnitMaxHP( caster, ( BlzGetUnitMaxHP(caster) + k ) )
            set udg_Data[i + 40] = udg_Data[i + 40] + k
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BoomSub takes nothing returns nothing
    set gg_trg_BoomSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BoomSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BoomSub, Condition( function Trig_BoomSub_Conditions ) )
    call TriggerAddAction( gg_trg_BoomSub, function Trig_BoomSub_Actions )
endfunction

