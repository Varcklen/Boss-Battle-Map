function Trig_Bob1_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'n00B'
endfunction

function Trig_Bob1_Actions takes nothing returns nothing
	local unit u = LoadUnitHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "bob" ) )
    local integer v

    call DisableTrigger( GetTriggeringTrigger() )
    call ShowUnit(u, true)
    set Boss_Info[10][3] = 'A19E'
    set v = Boss_Info[10][3]

	call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, u, GetUnitName(u), null, "No! I destroy you all!", bj_TIMETYPE_SET, 3, false )
	if bossbar == GetDyingUnit() then
		set bossbar = u
        call IconFrame( "Last Boss", BlzGetAbilityIcon(v), BlzGetAbilityTooltip(v, 0), BlzGetAbilityExtendedTooltip(v, 0) )
	endif
	if bossbar1 == GetDyingUnit() then
		set bossbar1 = u
        call IconFrame( "second boss", BlzGetAbilityIcon(v), BlzGetAbilityTooltip(v, 0), BlzGetAbilityExtendedTooltip(v, 0) )
	endif
	call AUI_TimerGo()
	call aggro( u )

	call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin" ) )
    
	set u = null
endfunction

//===========================================================================
function InitTrig_Bob1 takes nothing returns nothing
    set gg_trg_Bob1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Bob1 )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bob1, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Bob1, Condition( function Trig_Bob1_Conditions ) )
    call TriggerAddAction( gg_trg_Bob1, function Trig_Bob1_Actions )
endfunction

