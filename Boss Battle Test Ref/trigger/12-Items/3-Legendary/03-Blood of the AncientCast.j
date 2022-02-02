function Trig_Blood_of_the_AncientCast_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'B07T') > 0 and GetSpellAbilityId() != 'A0HV'
endfunction

function SpellBloodEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bldcst" ) )
	local integer i = LoadInteger( udg_hash, id, StringHash( "bldcst" ) )
	local integer sp = LoadInteger( udg_hash, id, StringHash( "bldcstsp" ) )
	local integer lvl = LoadInteger( udg_hash, id, StringHash( "bldcstlvl" ) )
    
    if sp != 0 and GetUnitAbilityLevel(caster, sp) > 0 then
        call BlzSetUnitAbilityManaCost( caster, sp, lvl, i )
    endif

    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_Blood_of_the_AncientCast_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetSpellAbilityUnit() )
	local integer sp = GetSpellAbilityId()
	local integer lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )-1
    local integer i = BlzGetAbilityManaCost( GetSpellAbilityId(), lvl )

	call BlzSetUnitAbilityManaCost( GetSpellAbilityUnit(), sp, lvl, 0 )

    if LoadTimerHandle( udg_hash, id, StringHash( "bldcst" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bldcst" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "bldcst" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "bldcst" ), GetSpellAbilityUnit() )
    call SaveInteger( udg_hash, id, StringHash( "bldcst" ), i )
    call SaveInteger( udg_hash, id, StringHash( "bldcstlvl" ), lvl )
    call SaveInteger( udg_hash, id, StringHash( "bldcstsp" ), sp )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "bldcst" ) ), 0.01, false, function SpellBloodEnd )

    call SetUnitState( GetSpellAbilityUnit(), UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( GetSpellAbilityUnit(), UNIT_STATE_LIFE) - i ))
endfunction

//===========================================================================
function InitTrig_Blood_of_the_AncientCast takes nothing returns nothing
    set gg_trg_Blood_of_the_AncientCast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Blood_of_the_AncientCast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Blood_of_the_AncientCast, Condition( function Trig_Blood_of_the_AncientCast_Conditions ) )
    call TriggerAddAction( gg_trg_Blood_of_the_AncientCast, function Trig_Blood_of_the_AncientCast_Actions )
endfunction

