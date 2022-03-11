globals
    constant integer CUT_DIAMOND_SHIELD = 100
    constant integer CUT_DIAMOND_DURATION = 60
endglobals

function Trig_Cut_Diamond_Conditions takes nothing returns boolean
    return inv(udg_FightStart_Unit, 'I0GF') > 0 
endfunction

function Trig_Cut_Diamond_Actions takes nothing returns nothing
    local unit hero = udg_FightStart_Unit
    
    call shield(hero, null, CUT_DIAMOND_SHIELD, CUT_DIAMOND_DURATION )
    call UnitAddAbility(hero, 'A10G')
    
    set hero = null
endfunction

//===========================================================================
function InitTrig_Cut_Diamond takes nothing returns nothing
    call CreateEventTrigger( "udg_FightStart_Real", function Trig_Cut_Diamond_Actions, function Trig_Cut_Diamond_Conditions )
endfunction

scope CutDiamond initializer init
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A10G') > 0
    endfunction
    
    private function Action takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'A10G' )
        call UnitRemoveAbility( hero, 'B0A1' )
        
        set hero = null
    endfunction

    private function ShieldDestroyed_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_ShieldDestroyed_Hero, 'A10G') > 0
    endfunction
    
    private function ShieldDestroyed takes nothing returns nothing
        local unit hero = Event_ShieldDestroyed_Hero
        local group otherHeroes = CreateGroup()
        local unit newTarget
        
        call GroupAddGroup( udg_otryad, otherHeroes )
        call GroupRemoveUnit(otherHeroes, hero)
        
        call UnitRemoveAbility( hero, 'A10G' )
        call UnitRemoveAbility( hero, 'B0A1' )
        
        set newTarget = GroupPickRandomUnit(otherHeroes)
        if newTarget != null then
            call shield(newTarget, null, CUT_DIAMOND_SHIELD, CUT_DIAMOND_DURATION )
            call UnitAddAbility(newTarget, 'A10G')
        endif
        
        call GroupClear( otherHeroes )
        call DestroyGroup( otherHeroes )
        set otherHeroes = null
        set newTarget = null
        set hero = null
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function Action, function Conditions )
        call CreateEventTrigger( "Event_ShieldDestroyed_Real", function ShieldDestroyed, function ShieldDestroyed_Conditions )
    endfunction
endscope