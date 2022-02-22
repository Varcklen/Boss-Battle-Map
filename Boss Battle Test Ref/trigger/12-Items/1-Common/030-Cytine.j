function Trig_Cytrine_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I0CZ' ) > 0
endfunction

function Trig_Cytrine_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local real r = 0
    
    call GroupEnumUnitsInRange( g, GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()), 500, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetSpellAbilityUnit(), "enemy" ) then
            set r = r + 10
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if r > 0 then
        call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0 , 0 )
        call GroupEnumUnitsInRange( g, GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()), 500, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, GetSpellAbilityUnit(), "enemy" ) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl", u, "origin" ) )
                call UnitDamageTarget( bj_lastCreatedUnit, u, r, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Cytine takes nothing returns nothing
    set gg_trg_Cytine = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cytine, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cytine, Condition( function Trig_Cytrine_Conditions ) )
    call TriggerAddAction( gg_trg_Cytine, function Trig_Cytrine_Actions )
endfunction

