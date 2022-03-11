function Trig_ShoggothWcopy_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11Y'
endfunction

function Trig_ShoggothWcopy_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer id
	local integer cyclA = 1
	local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A11Y'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
	set cyclAEnd = lvl + 1
	loop
		exitwhen cyclA > cyclAEnd
		set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n03F', x + GetRandomReal( -225, 225 ), y + GetRandomReal( -225, 225 ), GetRandomReal( 0, 360 ) )
		call UnitAddAbility( bj_lastCreatedUnit, 'A124' )
		call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
		call QueueUnitAnimationBJ( bj_lastCreatedUnit, "stand" )
		call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
		call SaveInteger( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "shgw" ), lvl )
		call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX(  bj_lastCreatedUnit ), GetUnitY(  bj_lastCreatedUnit ) ) )
		set cyclA = cyclA + 1
	endloop
	
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothWcopy takes nothing returns nothing
    set gg_trg_ShoggothWcopy = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothWcopy, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothWcopy, Condition( function Trig_ShoggothWcopy_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothWcopy, function Trig_ShoggothWcopy_Actions )
endfunction

