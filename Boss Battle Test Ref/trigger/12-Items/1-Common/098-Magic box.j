function Trig_Magic_box_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0NE' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function Trig_Magic_box_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0NE'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        if UnitInventoryCount(caster) < 6 then
            call ItemRandomizerAll( caster, 0 )
            call BlzSetItemIconPath( bj_lastCreatedItem, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(bj_lastCreatedItem) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Magic_box takes nothing returns nothing
    set gg_trg_Magic_box = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_box, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Magic_box, Condition( function Trig_Magic_box_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_box, function Trig_Magic_box_Actions )
endfunction

