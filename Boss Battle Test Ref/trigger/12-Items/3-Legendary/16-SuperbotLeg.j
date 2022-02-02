scope SuperbotLeg initializer init

    function Trig_SuperbotLeg_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'A0RD'
    endfunction

    function SuperbotLeg_Logic takes item it returns boolean
        local integer cyclA = 1
        local integer cyclAEnd = udg_DB_SetItems_Num[1]
        local boolean l = false
        
        loop
            exitwhen cyclA > cyclAEnd
            if GetItemTypeId(it) == DB_SetItems[1][cyclA] then
                set l = true
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function Trig_SuperbotLeg_Actions takes nothing returns nothing
        local integer x
        local unit caster
        local integer i = 0
        local integer cyclA = 0
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName('A0RD'), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        
        loop
            exitwhen cyclA > 5
            if GetItemTypeId( UnitItemInSlot( caster, cyclA ) ) == 'I05I' then 
                set i = i + 3
            elseif SuperbotLeg_Logic( UnitItemInSlot( caster, cyclA ) ) then
                set i = i + 1
            endif
            set cyclA = cyclA + 1
        endloop

        set x = eyest( caster )
        if SetCount_GetPieces(caster, SET_MECH) >= 6 or i >= 6 then
            call Superbot( caster )
        else
            call textst( "|c00808080 Conditions not met", caster, 64, 90, 10, 1.5 )
        endif
        
        set caster = null
    endfunction
    
    private function MechAdded_Condition takes nothing returns boolean
        return IsHeroHasItem(Event_MechAdded_Hero, 'I089') or GetUnitAbilityLevel( Event_MechAdded_Hero, 'A0RB') > 0
    endfunction
    
    private function MechAdded takes nothing returns nothing
        local unit hero = Event_MechAdded_Hero

        if GetUnitAbilityLevel( hero, 'A0RB') == 0 and Event_MechAdded_NewCount > Event_MechAdded_OldCount then
            call UnitAddAbility( hero, 'A0RC')
            call SetUnitAbilityLevel( hero, 'A0RB', Event_MechAdded_NewCount )
        elseif Event_MechAdded_NewCount == 0 and GetUnitAbilityLevel( hero, 'A0RB') > 0 then
            call UnitRemoveAbility( hero, 'A0RC')
        else
            call SetUnitAbilityLevel( hero, 'A0RB', Event_MechAdded_NewCount )
        endif
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SuperbotLeg = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SuperbotLeg, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SuperbotLeg, Condition( function Trig_SuperbotLeg_Conditions ) )
        call TriggerAddAction( gg_trg_SuperbotLeg, function Trig_SuperbotLeg_Actions )
        
        call CreateEventTrigger( "Event_MechAdded_Real", function MechAdded, function MechAdded_Condition )
    endfunction

endscope

