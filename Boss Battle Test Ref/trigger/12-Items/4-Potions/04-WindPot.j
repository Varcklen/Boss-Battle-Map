function Trig_WindPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0K3'
endfunction

function Trig_WindPot_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "Air", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set i = GetPlayerId( GetOwningPlayer( caster ) ) + 1

    call potionst( caster )
    loop
        exitwhen cyclA > 2
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u016', GetUnitX( caster ), GetUnitY( caster ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 30 )
	call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)*udg_SpellDamagePotion[i]), 0 )
	call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)*udg_SpellDamagePotion[i]) )
	call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_WindPot takes nothing returns nothing
    set gg_trg_WindPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WindPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WindPot, Condition( function Trig_WindPot_Conditions ) )
    call TriggerAddAction( gg_trg_WindPot, function Trig_WindPot_Actions )
endfunction

