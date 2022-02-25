function Trig_Saronite_Bomb_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OM'
endfunction

function Trig_Saronite_Bomb_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local unit target
    local group g
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0OM'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set g = CreateGroup()
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 250, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and u != target then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 225, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Saronite_Bomb takes nothing returns nothing
    set gg_trg_Saronite_Bomb = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Saronite_Bomb, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Saronite_Bomb, Condition( function Trig_Saronite_Bomb_Conditions ) )
    call TriggerAddAction( gg_trg_Saronite_Bomb, function Trig_Saronite_Bomb_Actions )
endfunction

