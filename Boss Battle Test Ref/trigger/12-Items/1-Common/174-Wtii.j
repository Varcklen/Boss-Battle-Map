globals 
    constant real MECHACHICKEN_WTII_HEALING = 0.2
    constant integer MECHACHICKEN_WTII_COOLDOWN = 35
endglobals

function Trig_Wtii_Conditions takes nothing returns boolean
    return inv( udg_DamageEventTarget, 'I0DR') > 0 and udg_DamageEventAmount >= GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE) and GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE) > 0.405 and not(LoadBoolean( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "wtii" ) ) )
endfunction

function WtiiCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "wtii" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "wtii" ) )
    
	call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "wtii" ), false )
	call BlzItemRemoveAbilityBJ( it, 'A0C2' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
    set it = null
endfunction

function Trig_Wtii_Actions takes nothing returns nothing
    local unit caster = udg_DamageEventTarget
    local item it = GetItemOfTypeFromUnitBJ( caster, 'I0DR')
    local integer id = GetHandleId( caster )

	set udg_DamageEventAmount = 0
	call healst( caster, null, MECHACHICKEN_WTII_HEALING*SetCount_GetPieces(caster, SET_MECH)*GetUnitState( caster, UNIT_STATE_MAX_LIFE) )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", caster, "origin" ) )

	call BlzItemAddAbilityBJ( it, 'A0C2' )
    call BlzStartUnitAbilityCooldown( caster, 'A0C2', 35 )

    if LoadTimerHandle( udg_hash, id, StringHash( "wtii" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "wtii" ), CreateTimer() )
    endif
	call SaveTimerHandle( udg_hash, id, StringHash( "wtii" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wtii" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wtii" ), caster ) 
	call SaveItemHandle( udg_hash, id, StringHash( "wtiit" ), it )
	call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "wtii" ), true ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "wtii" ) ), MECHACHICKEN_WTII_COOLDOWN, false, function WtiiCast ) 

	set it = null
	set caster = null
endfunction

//===========================================================================
function InitTrig_Wtii takes nothing returns nothing
    set gg_trg_Wtii = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Wtii, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wtii, Condition( function Trig_Wtii_Conditions ) )
    call TriggerAddAction( gg_trg_Wtii, function Trig_Wtii_Actions )
endfunction

