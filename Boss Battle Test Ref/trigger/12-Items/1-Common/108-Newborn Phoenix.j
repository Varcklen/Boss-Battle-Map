globals
    constant integer NEWBORN_PHOENIX_DURATION = 10
endglobals

function Trig_Newborn_Phoenix_Conditions takes nothing returns boolean
    return combat(udg_DamageEventTarget, false, 0) and not(udg_fightmod[3]) and inv( udg_DamageEventTarget, 'I05W') > 0 and udg_DamageEventAmount >= GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE) and GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE) > 0.405
endfunction

function Newborn_PhoenixCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "nbph" ) )
    
    call bufallst(caster, null, 'A0NA', 'A0MJ', 0, 0, 0, 'B09W', "nbphf", NEWBORN_PHOENIX_DURATION )
    call DestroyTimer( GetExpiredTimer() )
    
    set caster = null
endfunction

function Trig_Newborn_Phoenix_Actions takes nothing returns nothing
    local unit caster = udg_DamageEventTarget
    local integer id = GetHandleId( caster )

	set udg_DamageEventAmount = 0
	call healst( caster, null, GetUnitState( caster, UNIT_STATE_MAX_LIFE) )
    call manast( caster, null, GetUnitState( caster, UNIT_STATE_MAX_MANA) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", caster, "origin" ) )

    call InvokeTimerWithUnit( caster, "nbph", 0.01, false, function Newborn_PhoenixCast )

	call stazisst( caster, GetItemOfTypeFromUnitBJ( caster, 'I05W') )

	set caster = null
endfunction

//===========================================================================
function InitTrig_Newborn_Phoenix takes nothing returns nothing
    set gg_trg_Newborn_Phoenix = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Newborn_Phoenix, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Newborn_Phoenix, Condition( function Trig_Newborn_Phoenix_Conditions ) )
    call TriggerAddAction( gg_trg_Newborn_Phoenix, function Trig_Newborn_Phoenix_Actions )
endfunction

