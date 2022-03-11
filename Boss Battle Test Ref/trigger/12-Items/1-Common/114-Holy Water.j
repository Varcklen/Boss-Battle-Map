function Trig_Holy_Water_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0G4'
endfunction

function Trig_Holy_Water_Actions takes nothing returns nothing
    local integer cyclA
    local item myItem
    local unit caster = GetSpellAbilityUnit()

    set cyclA = 0
    loop
        exitwhen cyclA > 5
        set myItem = UnitItemInSlot( caster, cyclA )
        if GetSpellTargetItem() == myItem then
            call statst( caster, 1, 1, 1, 0, true )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" , caster, "origin" ) )
            call BlzSetItemExtendedTooltip( myItem, wordscurrent( caster, BlzGetItemExtendedTooltip(myItem), "|cffC71585Cursed|r", "|cFF1CE6B9Cleaned!|r" ) )
            call stazisst( caster, GetItemOfTypeFromUnitBJ( caster, 'I041') )
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set myItem = null
endfunction

//===========================================================================
function InitTrig_Holy_Water takes nothing returns nothing
    set gg_trg_Holy_Water = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Holy_Water, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Holy_Water, Condition( function Trig_Holy_Water_Conditions ) )
    call TriggerAddAction( gg_trg_Holy_Water, function Trig_Holy_Water_Actions )
endfunction

