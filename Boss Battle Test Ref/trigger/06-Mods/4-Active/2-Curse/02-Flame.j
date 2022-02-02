function Trig_Flame_Conditions takes nothing returns boolean
    return IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo)
endfunction

function Trig_Flame_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetSpellAbilityUnit(), "origin" ) )
    call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( GetSpellAbilityUnit() ), GetUnitY( GetSpellAbilityUnit() ), 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetSpellAbilityUnit(), "ally" ) and u != GetSpellAbilityUnit() then
            call UnitDamageTarget( bj_lastCreatedUnit, u, 25, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Flame takes nothing returns nothing
    set gg_trg_Flame = CreateTrigger(  )
    call DisableTrigger( gg_trg_Flame )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Flame, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddCondition( gg_trg_Flame, Condition( function Trig_Flame_Conditions ) )
    call TriggerAddAction( gg_trg_Flame, function Trig_Flame_Actions )
endfunction

