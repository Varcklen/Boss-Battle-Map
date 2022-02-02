function Trig_SkLordSpec_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0IP' or GetSpellAbilityId() == 'A0IQ'
endfunction

function Trig_SkLordSpec_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd = 1

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0IP'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    if IsUniqueUpgraded(caster) then
        set cyclAEnd = 2
    endif
    
    loop
        exitwhen cyclA > cyclAEnd
        call skeletsp( caster, caster )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SkLordSpec takes nothing returns nothing
    set gg_trg_SkLordSpec = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkLordSpec, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SkLordSpec, Condition( function Trig_SkLordSpec_Conditions ) )
    call TriggerAddAction( gg_trg_SkLordSpec, function Trig_SkLordSpec_Actions )
endfunction

