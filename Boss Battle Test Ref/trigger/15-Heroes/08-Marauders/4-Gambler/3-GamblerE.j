function Trig_GamblerE_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and ( GetUnitAbilityLevel(udg_DamageEventSource, 'A10M') > 0 or GetUnitAbilityLevel( udg_DamageEventSource, 'A10M' ) > 0 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) and luckylogic( udg_DamageEventSource, 30, 1, 100 )
endfunction

function GamblerECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "gmbe" ) ), 'A11H' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "gmbe" ) ), 'B06R' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_GamblerE_Actions takes nothing returns nothing
    local integer lvl
    local integer rand = GetRandomInt( 1, 5 )
    local integer id
    local integer p

    if GetUnitAbilityLevel( udg_DamageEventSource, 'A11T' ) > 0 then
		set lvl = LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "gmbwe" ) )
    else
		set lvl = GetUnitAbilityLevel(udg_DamageEventSource, 'A10M')
    endif
    
	call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( udg_DamageEventSource ), GetUnitY( udg_DamageEventSource ) ) )
	if rand == 1 then
        set p = 15+(4*lvl)
		call manast( udg_DamageEventSource, null, p )
        call textst( "|c002020FF +" + I2S(p) + " mana", udg_DamageEventSource, 64, 90, 10, 1 )
	elseif rand == 2 then
        set p = 13+(13*lvl)
		call healst( udg_DamageEventSource, null, p )
        call textst( "|c0020FF20 +" + I2S(p) + " health" , udg_DamageEventSource, 64, 90, 10, 1 )
	elseif rand == 3 and combat( udg_DamageEventSource, false, 0 ) and not( udg_fightmod[3] ) then
        set p = 7*lvl
		call moneyst( udg_DamageEventSource, p )
        call textst( "|cFFFFFC01 +" + I2S(p) + " gold" , udg_DamageEventSource, 64, 90, 10, 1 )
	elseif rand == 4 then
        call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 0.25*lvl )
        call textst( "|cFF7EBFF1stun" , udg_DamageEventSource, 64, 90, 10, 1 )
	elseif rand == 5 then
		call UnitAddAbility( udg_DamageEventTarget, 'A11H' )
		call SetUnitAbilityLevel( udg_DamageEventTarget, 'A111', lvl )
        call textst( "armor" , udg_DamageEventSource, 64, 90, 10, 1 )
		
		set id = GetHandleId( udg_DamageEventTarget )
		if LoadTimerHandle( udg_hash, id, StringHash( "gmbe" ) ) == null  then
			call SaveTimerHandle( udg_hash, id, StringHash( "gmbe" ), CreateTimer() )
		endif
		set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "gmbe" ) ) ) 
		call SaveUnitHandle( udg_hash, id, StringHash( "gmbe" ), udg_DamageEventTarget )
		call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "gmbe" ) ), 10, false, function GamblerECast )

		if BuffLogic() then
			call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, 10 )
		endif
	endif
endfunction

//===========================================================================
function InitTrig_GamblerE takes nothing returns nothing
    set gg_trg_GamblerE = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_GamblerE, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GamblerE, Condition( function Trig_GamblerE_Conditions ) )
    call TriggerAddAction( gg_trg_GamblerE, function Trig_GamblerE_Actions )
endfunction