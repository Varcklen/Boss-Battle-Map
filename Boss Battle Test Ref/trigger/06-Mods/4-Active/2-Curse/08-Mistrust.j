scope Mistrust initializer init

    globals
        constant integer MISTRUST_MANABURN = 5
        constant integer MISTRUST_AREA = 250
        
        constant string MISTRUST_ANIMATION = "Abilities\\Spells\\Undead\\DeathPact\\DeathPactCaster.mdl"
    endglobals

    function Trig_Mistrust_Conditions takes nothing returns boolean
        return IsUnitInGroup(GetSpellAbilityUnit(), udg_heroinfo)
    endfunction

    function Trig_Mistrust_Actions takes nothing returns nothing
        local group g = CreateGroup()
        local unit u
        local unit caster = GetSpellAbilityUnit()

        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), MISTRUST_AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and u != caster and IsUnitType( u, UNIT_TYPE_HERO) then
                call DestroyEffect( AddSpecialEffectTarget(MISTRUST_ANIMATION, u, "origin" ) )
                call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( u, UNIT_STATE_MANA) - MISTRUST_MANABURN ))
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction

    private function Conditions takes nothing returns boolean
        return udg_modbad[29]
    endfunction
    
    private function Actions takes nothing returns nothing
        call EnableTrigger( gg_trg_Mistrust )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Mistrust = CreateTrigger()
        call DisableTrigger( gg_trg_Mistrust )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Mistrust, EVENT_PLAYER_UNIT_SPELL_FINISH )
        call TriggerAddCondition( gg_trg_Mistrust, Condition( function Trig_Mistrust_Conditions ) )
        call TriggerAddAction( gg_trg_Mistrust, function Trig_Mistrust_Actions )
        
        call CreateEventTrigger( "Event_Mode_Awake_Real", function Actions, function Conditions )
    endfunction
endscope