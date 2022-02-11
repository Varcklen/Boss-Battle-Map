scope bobgrat

    function Trig_BobsGratitude_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'AZ06' and IsSetItem(GetItemTypeId(GetSpellTargetItem()),9)
    endfunction

    function Trig_BobsGratitude_Actions takes nothing returns nothing
        local unit u = GetSpellAbilityUnit()
        //local integer h = eyest( u )
        local integer itd = GetItemTypeId(GetSpellTargetItem())

        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call stazisst( u, GetItemOfTypeFromUnitBJ( u, 'IZ02') )
        call UnitAddItem( u, CreateItem(itd, GetUnitX(u), GetUnitY(u) ) )

        set u = null
    endfunction

//===========================================================================
    function InitTrig_BobsGratitude takes nothing returns nothing
        set gg_trg_BobsGratitude = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_BobsGratitude, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_BobsGratitude, Condition( function Trig_BobsGratitude_Conditions ) )
        call TriggerAddAction( gg_trg_BobsGratitude, function Trig_BobsGratitude_Actions )
    endfunction

endscope
