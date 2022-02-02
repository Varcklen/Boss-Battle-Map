function Trig_Hnum_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A164'
endfunction

function Trig_Hnum_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer x
    local integer id
    local unit caster
    local group g = CreateGroup()
    local unit u
    local integer k = 0
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A164'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    set bj_livingPlayerUnitsTypeId = ID_SHEEP
    call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( caster ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null or k >= 30
        set k = k + 1
        call ReplaceUnitBJ( u, udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], bj_UNIT_STATE_METHOD_RELATIVE )
        call UnitApplyTimedLife( bj_lastReplacedUnit, 'BTLF', 15)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( bj_lastReplacedUnit ), GetUnitY( bj_lastReplacedUnit ) ) )
        call GroupRemoveUnit(g,u)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Hnum takes nothing returns nothing
    set gg_trg_Hnum = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Hnum, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Hnum, Condition( function Trig_Hnum_Conditions ) )
    call TriggerAddAction( gg_trg_Hnum, function Trig_Hnum_Actions )
endfunction

