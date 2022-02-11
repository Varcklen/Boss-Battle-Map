function Trig_OrbKhadgar_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0DK') > 0 and luckylogic( GetSpellAbilityUnit(), 20, 1, 100 )
endfunction

function OrbKhadgarEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbkh" ) )
	local integer i = LoadInteger( udg_hash, id, StringHash( "orbkh" ) )
	local integer sp = LoadInteger( udg_hash, id, StringHash( "orbkhsp" ) )
	local integer lvl = LoadInteger( udg_hash, id, StringHash( "orbkhlvl" ) )
    
	call BlzSetUnitAbilityManaCost( caster, sp, lvl, i )

    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_OrbKhadgar_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetSpellAbilityUnit() )
	local integer sp = GetSpellAbilityId()
	local integer lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )-1
    local integer i = BlzGetAbilityManaCost( GetSpellAbilityId(), lvl )

    if i > 0 then
        call BlzSetUnitAbilityManaCost( GetSpellAbilityUnit(), sp, lvl, 0 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetSpellAbilityUnit(), "origin" ) )

        if LoadTimerHandle( udg_hash, id, StringHash( "orbkh" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "orbkh" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "orbkh" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "orbkh" ), GetSpellAbilityUnit() )
        call SaveInteger( udg_hash, id, StringHash( "orbkh" ), i )
        call SaveInteger( udg_hash, id, StringHash( "orbkhlvl" ), lvl )
        call SaveInteger( udg_hash, id, StringHash( "orbkhsp" ), sp )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "orbkh" ) ), 0.01, false, function OrbKhadgarEnd )
    endif
endfunction

//===========================================================================
function InitTrig_OrbKhadgar takes nothing returns nothing
    set gg_trg_OrbKhadgar = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbKhadgar, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbKhadgar, Condition( function Trig_OrbKhadgar_Conditions ) )
    call TriggerAddAction( gg_trg_OrbKhadgar, function Trig_OrbKhadgar_Actions )
endfunction

