function Trig_HronoECast_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A00P') > 0
endfunction

function Trig_HronoECast_Actions takes nothing returns nothing
    local unit caster = GetSpellAbilityUnit()
    local integer unitId = GetHandleId( caster )
    local real c = LoadReal( udg_hash, unitId, StringHash( "hrnec" ) ) - CHRONOMANCER_E_REDUCTION

    call SaveReal( udg_hash, unitId, StringHash( "hrnec" ), c )
    call BlzStartUnitAbilityCooldown( caster, 'A00P', RMaxBJ( 1,c) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_HronoECast takes nothing returns nothing
    set gg_trg_HronoECast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HronoECast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HronoECast, Condition( function Trig_HronoECast_Conditions ) )
    call TriggerAddAction( gg_trg_HronoECast, function Trig_HronoECast_Actions )
endfunction

