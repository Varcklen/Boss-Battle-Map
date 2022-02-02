function Trig_Inferno_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0Q6'
endfunction

function Trig_Inferno_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd
    local integer i = 0
    local unit caster
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0Q6'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

	set cyclAEnd = eyest( caster )
	loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, x, y, 425, null )
		loop
			set u = FirstOfGroup(g)
			exitwhen u == null
			if unitst( u, caster, "all" ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) then
				call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(u), GetUnitY(u) ) )
				call KillUnit(u)
				set i = i + 1
				if i >= 5 then
					set i = 0
					set bj_lastCreatedUnit = CreateUnit( Player(4), 'u000', x+GetRandomReal(-300,300), y+GetRandomReal(-300,300), 270 )
					call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1 )
					call UnitAddAbility( bj_lastCreatedUnit, 'A0Q7' )
					call IssuePointOrder( bj_lastCreatedUnit, "dreadlordinferno", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
				endif
			endif
			call GroupRemoveUnit(g,u)
			set u = FirstOfGroup(g)
		endloop
        set cyclA = cyclA + 1
    endloop
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Inferno takes nothing returns nothing
    set gg_trg_Inferno = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Inferno, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Inferno, Condition( function Trig_Inferno_Conditions ) )
    call TriggerAddAction( gg_trg_Inferno, function Trig_Inferno_Actions )
endfunction