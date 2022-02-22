function Trig_Pendant_of_Knowledge_Conditions takes nothing returns boolean
    return combat( GetSpellAbilityUnit(), false, 0 ) and not( udg_fightmod[3] ) and inv( GetSpellAbilityUnit(), 'I084') > 0
endfunction

function Trig_Pendant_of_Knowledge_Actions takes nothing returns nothing
    local unit u = GetSpellAbilityUnit()
    local item it = GetItemOfTypeFromUnitBJ( u, 'I084')
    local integer id = GetHandleId( it )
    local integer s = LoadInteger( udg_hash, id, StringHash( "cgnt" ) ) + 1
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "cgntlvl" ) )
    
	if lvl < 4 then
		call SaveInteger( udg_hash, id, StringHash( "cgnt" ), s )
        if s < 20 then
            call textst( "|c005050FF " + I2S(s) + "/20", u, 64, GetRandomReal( 0, 360 ), 7, 1.5 )
        else
			if lvl == 3 then
				call BlzSetItemIconPath( it, "|cff373ec3Rare|r\nIncreases stats by 15." )
			else
                call BlzSetItemIconPath( it, words( u, BlzGetItemDescription(it), "|cffffffff", "|r", I2S(lvl+2) ) )
			endif
            call BlzItemRemoveAbility( it, 'A1H1' + lvl )
            call BlzItemAddAbility( it, 'A1H2' + lvl )
            call textst( "|c005050FF Pendant of Knowledge improved!", u, 64, 90, 10, 1.5 )
            call SaveInteger( udg_hash, id, StringHash( "cgnt" ), 0 )
            call SaveInteger( udg_hash, id, StringHash( "cgntlvl" ), lvl+1 )
            call DestroyEffect( AddSpecialEffect("war3mapImported\\SoulRitual.mdx", GetUnitX( u ), GetUnitY( u ) ) )
        endif
	endif
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Pendant_of_Knowledge takes nothing returns nothing
    set gg_trg_Pendant_of_Knowledge = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pendant_of_Knowledge, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Pendant_of_Knowledge, Condition( function Trig_Pendant_of_Knowledge_Conditions ) )
    call TriggerAddAction( gg_trg_Pendant_of_Knowledge, function Trig_Pendant_of_Knowledge_Actions )
endfunction

