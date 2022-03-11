function Trig_OrbArcane_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I08Y') > 0 and luckylogic( GetSpellAbilityUnit(), 15, 1, 100 )
endfunction

function OrbArcaneEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orba" ) )
	local integer i = LoadInteger( udg_hash, id, StringHash( "orba" ) )
	local integer sp = LoadInteger( udg_hash, id, StringHash( "orbasp" ) )
	local integer lvl = LoadInteger( udg_hash, id, StringHash( "orbalvl" ) )
    
	call BlzSetUnitAbilityManaCost( caster, sp, lvl, i )

    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_OrbArcane_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetSpellAbilityUnit() )
	local integer sp = GetSpellAbilityId()
	local integer lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )-1
    local integer i = BlzGetAbilityManaCost( GetSpellAbilityId(), lvl )

    if i > 0 then
        call BlzSetUnitAbilityManaCost( GetSpellAbilityUnit(), sp, lvl, R2I(i/2) )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetSpellAbilityUnit(), "origin" ) )

        if LoadTimerHandle( udg_hash, id, StringHash( "orba" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "orba" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "orba" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "orba" ), GetSpellAbilityUnit() )
        call SaveInteger( udg_hash, id, StringHash( "orba" ), i )
        call SaveInteger( udg_hash, id, StringHash( "orbalvl" ), lvl )
        call SaveInteger( udg_hash, id, StringHash( "orbasp" ), sp )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orba" ) ), 0.01, false, function OrbArcaneEnd )
    endif
endfunction

//===========================================================================
function InitTrig_OrbArcane takes nothing returns nothing
    set gg_trg_OrbArcane = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbArcane, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbArcane, Condition( function Trig_OrbArcane_Conditions ) )
    call TriggerAddAction( gg_trg_OrbArcane, function Trig_OrbArcane_Actions )
endfunction

