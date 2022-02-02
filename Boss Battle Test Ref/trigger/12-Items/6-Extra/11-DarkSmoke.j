//TESH.scrollpos=6
//TESH.alwaysfold=0
function Trig_DarkSmoke_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A028'
endfunction

function DarkSmokeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "drks" ) ), 'A0WV' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_DarkSmoke_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A028'), caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set t = 5
    endif
    set id = GetHandleId( caster )
    
    call UnitAddAbility( caster, 'A0WV' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", caster, "origin" ) )
    
    call shadowst( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "drks" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "drks" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drks" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "drks" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "drks" ) ), t, false, function DarkSmokeCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_DarkSmoke_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_DarkSmoke takes nothing returns nothing
    set gg_trg_DarkSmoke = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DarkSmoke, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DarkSmoke, Condition( function Trig_DarkSmoke_Conditions ) )
    call TriggerAddAction( gg_trg_DarkSmoke, function Trig_DarkSmoke_Actions )
endfunction

