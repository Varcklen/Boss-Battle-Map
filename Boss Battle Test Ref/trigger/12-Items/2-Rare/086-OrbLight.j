function Trig_OrbLight_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0C6'
endfunction

function Trig_OrbLight_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0C6'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", caster, "origin")
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, null, 300 )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_OrbLight takes nothing returns nothing
    set gg_trg_OrbLight = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbLight, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbLight, Condition( function Trig_OrbLight_Conditions ) )
    call TriggerAddAction( gg_trg_OrbLight, function Trig_OrbLight_Actions )
endfunction

