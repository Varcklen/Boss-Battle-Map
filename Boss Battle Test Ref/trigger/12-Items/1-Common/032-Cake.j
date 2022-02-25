function Trig_Cake_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0DH') > 0 and IsPotionItemIsUsed() and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1] and not(udg_fightmod[3])
endfunction

function Trig_Cake_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1
    local integer rand = GetRandomInt( 1,4 )

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetSpellAbilityUnit(), "origin" ) )
	if rand == 1 then
		set rand = GetRandomInt( 1,3 )
		if rand == 1 then
            call statst( GetSpellAbilityUnit(), 1, 0, 0, 0, true )
            call textst( "|c00FF2020 +1 strength", GetSpellAbilityUnit(), 64, 90, 10, 1 )
		elseif rand == 2 then
  			call statst( GetSpellAbilityUnit(), 0, 1, 0, 0, true )
            call textst( "|c0020FF20 +1 agility", GetSpellAbilityUnit(), 64, 90, 10, 1 )
		elseif rand == 3 then
  			call statst( GetSpellAbilityUnit(), 0, 0, 1, 0, true )
            call textst( "|c002020FF +1 intelligence", GetSpellAbilityUnit(), 64, 90, 10, 1 )
		endif
	elseif rand == 2 then
		call luckyst( GetSpellAbilityUnit(), 1 )
        call textst( "|cFFFE8A0E +1 luck", GetSpellAbilityUnit(), 64, 90, 10, 1 )
	elseif rand == 3 then
		call spdst( GetSpellAbilityUnit(), 0.5 )
        call textst( "|cFF7EBFF1 +0.5"+udg_perc+" spell power", GetSpellAbilityUnit(), 64, 90, 10, 1 )
	elseif rand == 4 then
		call moneyst( GetSpellAbilityUnit(), 50 )
        call textst( "|cFFFFFC01 +50 gold", GetSpellAbilityUnit(), 64, 90, 10, 1 )
	endif

endfunction

//===========================================================================
function InitTrig_Cake takes nothing returns nothing
    set gg_trg_Cake = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cake, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cake, Condition( function Trig_Cake_Conditions ) )
    call TriggerAddAction( gg_trg_Cake, function Trig_Cake_Actions )
endfunction

