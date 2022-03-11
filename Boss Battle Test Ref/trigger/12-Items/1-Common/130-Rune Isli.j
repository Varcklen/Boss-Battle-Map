function Trig_Rune_Isli_Conditions takes nothing returns boolean
    return inv( GetSpellAbilityUnit(), 'I053') > 0
endfunction

function Trig_Rune_Isli_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit())) + 1
    local integer array a
    local boolean array l
    local integer cyclA
    local integer rand

	set a[1] = IMaxBJ( 5, Database_Hero_Abilities[1][udg_HeroNum[i]])
	set a[2] = IMaxBJ( 5, Database_Hero_Abilities[2][udg_HeroNum[i]])
	set a[3] = IMaxBJ( 5, Database_Hero_Abilities[3][udg_HeroNum[i]])
	set a[4] = IMaxBJ( 5, Database_Hero_Abilities[4][udg_HeroNum[i]])

	set cyclA = 1
	loop
		exitwhen cyclA > 4
		if BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(),a[cyclA]) > 5 then
			set l[cyclA] = true
		else
			set l[cyclA] = false
		endif
		set cyclA = cyclA + 1
	endloop

if l[1] or l[2] or l[3] or l[4] then
	set cyclA = 1
	loop
		exitwhen cyclA > 1
		set rand = GetRandomInt( 1, 4 )
		if l[rand] then
    			call BlzStartUnitAbilityCooldown( GetSpellAbilityUnit(), a[rand], RMaxBJ( 5.1,BlzGetUnitAbilityCooldownRemaining(GetSpellAbilityUnit(), a[rand])) - 5 )
		else
			set cyclA = cyclA - 1
		endif
		set cyclA = cyclA + 1
	endloop

	if not(udg_logic[i + 26]) then
    		call SetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MANA, RMaxBJ(0,GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MANA) - (GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_MAX_MANA)*0.03) ))
	endif
endif
endfunction

//===========================================================================
function InitTrig_Rune_Isli takes nothing returns nothing
    set gg_trg_Rune_Isli = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Rune_Isli, EVENT_PLAYER_UNIT_SPELL_FINISH )
    call TriggerAddCondition( gg_trg_Rune_Isli, Condition( function Trig_Rune_Isli_Conditions ) )
    call TriggerAddAction( gg_trg_Rune_Isli, function Trig_Rune_Isli_Actions )
endfunction

