function Trig_Mixology_Conditions takes nothing returns boolean
    return (GetSpellAbilityId() == 'A13I' or GetSpellAbilityId() == 'A13J' ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Mixology_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd = 1
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A13I'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    if IsUniqueUpgraded(caster) then
        set cyclAEnd = 2
    endif
    
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", caster, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        if UnitInventoryCount(caster) < 6 and IsUnitType( caster, UNIT_TYPE_HERO) then
            set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1, udg_Database_NumberItems[9])], GetUnitX( caster ), GetUnitY(caster))
            call UnitAddItem(caster, bj_lastCreatedItem )
        endif
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Mixology takes nothing returns nothing
    set gg_trg_Mixology = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mixology, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mixology, Condition( function Trig_Mixology_Conditions ) )
    call TriggerAddAction( gg_trg_Mixology, function Trig_Mixology_Actions )
endfunction

