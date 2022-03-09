function Trig_Cristal_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'B08V') > 0 and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function Trig_Cristal_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetSpellAbilityUnit() )
    local integer s = LoadInteger( udg_hash, id, StringHash( "crst" ) ) + 1
    
    if s < 5 then
        call textst( "|c0000ccee " + I2S(s), GetSpellAbilityUnit(), 64, GetRandomReal( 45, 135 ), 15, 3 )
		call SaveInteger( udg_hash, id, StringHash( "crst" ), s )
    else
		call SaveInteger( udg_hash, id, StringHash( "crst" ), 0 )
		call textst( "|c0000ccee Double!", GetSpellAbilityUnit(), 64, GetRandomReal( 45, 135 ), 15, 3 )
		set udg_CastLogic = true
		set udg_Caster = GetSpellAbilityUnit()
		set udg_Target = GetSpellTargetUnit()

        set udg_Level = 5
		set udg_Time = 20
        call TriggerExecute( udg_TrigNow )
	endif	
endfunction

//===========================================================================
function InitTrig_Cristal takes nothing returns nothing
    set gg_trg_Cristal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cristal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cristal, Condition( function Trig_Cristal_Conditions ) )
    call TriggerAddAction( gg_trg_Cristal, function Trig_Cristal_Actions )
endfunction

