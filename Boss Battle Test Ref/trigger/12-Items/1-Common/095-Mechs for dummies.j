function Trig_Mechs_for_dummies_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00G' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction
  
function Trig_Mechs_for_dummies_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A00G'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = eyest(caster)
    loop
        exitwhen cyclA > cyclAEnd
    	set udg_Caster = caster
    	set udg_RandomLogic = true
        set RandomMode = true
        call TriggerExecute( udg_DB_MechUse[GetRandomInt( 1, udg_Database_NumberItems[35])] )
        set RandomMode = false
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Mechs_for_dummies takes nothing returns nothing
    set gg_trg_Mechs_for_dummies = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mechs_for_dummies, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mechs_for_dummies, Condition( function Trig_Mechs_for_dummies_Conditions ) )
    call TriggerAddAction( gg_trg_Mechs_for_dummies, function Trig_Mechs_for_dummies_Actions )
endfunction

