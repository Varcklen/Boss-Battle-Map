function Trig_Yoric_Skull_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YH'
endfunction

function Trig_Yoric_Skull_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer x
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YH'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster )
    call spectimeunit( caster, "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdx", "origin", 5 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally" ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and ( GetUnitAbilityLevel( u, 'Avul') == 0 ) then
            call UnitAddAbility( u, 'A0YJ')
            call GroupAddUnit( udg_YoricSkull, u )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
 
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Yoric_Skull takes nothing returns nothing
    set gg_trg_Yoric_Skull = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Yoric_Skull, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Yoric_Skull, Condition( function Trig_Yoric_Skull_Conditions ) )
    call TriggerAddAction( gg_trg_Yoric_Skull, function Trig_Yoric_Skull_Actions )
endfunction

