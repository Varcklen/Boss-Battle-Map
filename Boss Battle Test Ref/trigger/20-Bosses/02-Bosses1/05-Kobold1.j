function Trig_Kobold1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventSource) == 'n00P' and GetRandomInt(1, 5) == 1
endfunction

function Trig_Kobold1_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRange( g, GetUnitX( udg_DamageEventSource ), GetUnitY( udg_DamageEventSource ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, udg_DamageEventSource, "enemy" ) then
    	    call SetUnitState( u, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( u, UNIT_STATE_LIFE) - 40 ))
            call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", u, "origin") )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Kobold1 takes nothing returns nothing
    set gg_trg_Kobold1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Kobold1 )
    call TriggerRegisterVariableEvent( gg_trg_Kobold1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Kobold1, Condition( function Trig_Kobold1_Conditions ) )
    call TriggerAddAction( gg_trg_Kobold1, function Trig_Kobold1_Actions )
endfunction

