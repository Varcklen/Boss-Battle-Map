function Trig_Sapphire_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0LZ'
endfunction

function Trig_Sapphire_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0LZ'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif 

    set cyclAEnd  = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call manast( caster, null, 40 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", caster, "origin" ) )
        if luckylogic( caster, 25, 1, 100 ) then
            set target = GroupPickRandomUnit(udg_otryad)
            call manast( GetSpellAbilityUnit(), target, 40 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", target, "origin" ) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Sapphire takes nothing returns nothing
    set gg_trg_Sapphire = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sapphire, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sapphire, Condition( function Trig_Sapphire_Conditions ) )
    call TriggerAddAction( gg_trg_Sapphire, function Trig_Sapphire_Actions )
endfunction

