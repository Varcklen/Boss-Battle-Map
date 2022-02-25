function Trig_Salad_of_Wonders_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19X'
endfunction

function Trig_Salad_of_Wonders_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A19X'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call AddSpecialEffectTarget("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", caster, "origin")
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, null, GetRandomReal(1,400) )
        set cyclA = cyclA + 1
    endloop
    if UnitInventoryCount(caster) >= 6 then
        call stazisst( caster, GetItemOfTypeFromUnitBJ( caster, 'I0G6') )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Salad_of_Wonders takes nothing returns nothing
    set gg_trg_Salad_of_Wonders = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Salad_of_Wonders, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Salad_of_Wonders, Condition( function Trig_Salad_of_Wonders_Conditions ) )
    call TriggerAddAction( gg_trg_Salad_of_Wonders, function Trig_Salad_of_Wonders_Actions )
endfunction

