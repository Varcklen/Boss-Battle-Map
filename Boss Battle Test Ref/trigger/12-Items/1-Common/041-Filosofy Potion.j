function Trig_Filosofy_Potion_Conditions takes nothing returns boolean
    return ( GetSpellAbilityId() == 'A0EV' ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Filosofy_Potion_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0EV'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        if UnitInventoryCount( caster ) < 6 then
            set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX(caster), GetUnitY(caster))
	    call UnitAddItemSwapped( GetLastCreatedItem(), caster )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", caster, "origin" ) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Filosofy_Potion takes nothing returns nothing
    set gg_trg_Filosofy_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Filosofy_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Filosofy_Potion, Condition( function Trig_Filosofy_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Filosofy_Potion, function Trig_Filosofy_Potion_Actions )
endfunction

