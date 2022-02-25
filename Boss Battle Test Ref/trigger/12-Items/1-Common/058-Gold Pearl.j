function Trig_Gold_Pearl_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OW' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Gold_Pearl_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local integer i 
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0OW'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
    set cyclAEnd = eyest( caster )

    loop
        exitwhen cyclA > cyclAEnd
        if not( udg_fightmod[3] ) then
            call moneyst( caster, 50 )
            set udg_Data[i + 36] = udg_Data[i + 36] + 50
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Gold_Pearl takes nothing returns nothing
    set gg_trg_Gold_Pearl = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Gold_Pearl, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Gold_Pearl, Condition( function Trig_Gold_Pearl_Conditions ) )
    call TriggerAddAction( gg_trg_Gold_Pearl, function Trig_Gold_Pearl_Actions )
endfunction

