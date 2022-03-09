function Trig_MarshalWElf_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n015'
endfunction

function Trig_MarshalWElf_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer lvl = IMaxBJ(1, LoadInteger( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "mrswe" ) ) )

    set bj_livingPlayerUnitsTypeId = 'N014'
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( GetDyingUnit() ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin" ) )
        call bufallst( u, u, 'A0F8', 'A0F4', 'A0EM', 0, 0, 'B04Y', "mrsw", timebonus(u, MARSHAL_W_DURATION) )
        call effst( u, u, null, lvl, timebonus(u, MARSHAL_W_DURATION) )
        call SetUnitAbilityLevel( u, 'A0EM', lvl )
        call SetUnitAbilityLevel( u, 'A0F4', lvl )
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
endfunction

function MarshalWElf_BuffDelete takes nothing returns nothing
    if GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'B04Y') > 0 then
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'A0F8' )
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'A0F4' )
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'A0EM' )
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'B04Y' )
    endif
endfunction

//===========================================================================
function InitTrig_MarshalWElf takes nothing returns nothing
    set gg_trg_MarshalWElf = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MarshalWElf, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_MarshalWElf, Condition( function Trig_MarshalWElf_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalWElf, function Trig_MarshalWElf_Actions )
    
    call CreateTrigger_DeleteBuff(function MarshalWElf_BuffDelete)
endfunction

