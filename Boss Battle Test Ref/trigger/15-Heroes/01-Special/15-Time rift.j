function Trig_Time_rift_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BV' 
endfunction

function Trig_Time_rift_Actions takes nothing returns nothing
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A1BV'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    call coldstop( caster )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\Sci Teleport.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    if combat( caster, false, 0 ) then
        call NewSpecial( caster, 'A1BW' )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Time_rift takes nothing returns nothing
    set gg_trg_Time_rift = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Time_rift, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Time_rift, Condition( function Trig_Time_rift_Conditions ) )
    call TriggerAddAction( gg_trg_Time_rift, function Trig_Time_rift_Actions )
endfunction

