function Trig_Arcanology_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19U' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function Trig_Arcanology_Actions takes nothing returns nothing
    local unit caster
    local item newItem
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A19U'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    if UnitInventoryCount(caster) < 6 then
        set newItem = CreateItem( udg_DB_Item_Activate[GetRandomInt(1,udg_Database_NumberItems[31])], GetUnitX(caster), GetUnitY(caster) )
        call UnitAddItem( caster, newItem )
        call BlzSetItemIconPath( newItem, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(newItem) )
    endif
    
    set newItem = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Arcanology takes nothing returns nothing
    set gg_trg_Arcanology = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Arcanology, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Arcanology, Condition( function Trig_Arcanology_Conditions ) )
    call TriggerAddAction( gg_trg_Arcanology, function Trig_Arcanology_Actions )
endfunction

