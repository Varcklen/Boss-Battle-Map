//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_PrismBlue_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07G'
endfunction

function Trig_PrismBlue_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A07G'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd  = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 1
        loop
            exitwhen cyclB > 4
            if unitst( udg_hero[cyclB], caster, "ally" ) then
                call manast( caster, udg_hero[cyclB], 100 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", udg_hero[cyclB], "origin" ) )
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_PrismBlue takes nothing returns nothing
    set gg_trg_PrismBlue = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PrismBlue, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PrismBlue, Condition( function Trig_PrismBlue_Conditions ) )
    call TriggerAddAction( gg_trg_PrismBlue, function Trig_PrismBlue_Actions )
endfunction

