function Trig_Orbs_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13G' or GetSpellAbilityId() == 'A14S'
endfunction

function Trig_Orbs_Actions takes nothing returns nothing
    local unit caster
    local real x
    local real y
    local integer id
    local integer cyclA = 1
    local integer cyclAEnd = 1
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A13G'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

	if IsUniqueUpgraded(caster) then
		set cyclAEnd = 2
	endif
    
	loop
		exitwhen cyclA > cyclAEnd
		set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A04J' )
		set cyclA = cyclA + 1
	endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Orbs takes nothing returns nothing
    set gg_trg_Orbs = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Orbs, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Orbs, Condition( function Trig_Orbs_Conditions ) )
    call TriggerAddAction( gg_trg_Orbs, function Trig_Orbs_Actions )
endfunction

