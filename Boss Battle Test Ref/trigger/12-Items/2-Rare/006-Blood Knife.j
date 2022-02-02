function Trig_Blood_Knife_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0X6' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Blood_KnifeEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "blkn1" ) )
    
    if combat( u, false, 0 ) and GetUnitState( u, UNIT_STATE_LIFE) <= 0.405  then
        call ReviveHeroLoc( u, GetUnitLoc( u ), true )
        call ShowUnitShow( u )
        if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
            set udg_Heroes_Deaths = udg_Heroes_Deaths + 1
        else
            call GroupAddUnit( udg_otryad, u )
            call PauseUnit( u, false )
            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * 0.5 )
            call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * 0.5 )
        endif
    endif
    call UnitRemoveAbility( u, 'A0EX' )
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Blood_KnifeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "blkn" ) )
    local integer id1 = GetHandleId( target )

    if combat( target, false, 0 ) then
    	call UnitAddAbility( target, 'A0EX' )
        set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( target ), GetUnitY( target ), 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "blkn1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "blkn1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "blkn1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "blkn1" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "blkn1" ) ), 3, false, function Blood_KnifeEnd )
        
        call DisableTrigger( gg_trg_HeroDeath )
        call DisableTrigger( gg_trg_IA_End )
        call DisableTrigger( gg_trg_PA_End )
        call DisableTrigger( gg_trg_AL_End )
        call DisableTrigger( gg_trg_BattleRessurect )
        call DisableTrigger( gg_trg_PhoenixEgg )
        call DisableTrigger( gg_trg_Sphere_Abyss )
	call DisableTrigger( gg_trg_DoctorRUse )
        call KillUnit( target )
        call EnableTrigger( gg_trg_BattleRessurect )
        call EnableTrigger( gg_trg_PhoenixEgg )
        call EnableTrigger( gg_trg_Sphere_Abyss )
	call EnableTrigger( gg_trg_DoctorRUse )
        if udg_fightmod[1] then
            call EnableTrigger( gg_trg_HeroDeath )
        endif
        if udg_fightmod[2] then
            call EnableTrigger( gg_trg_IA_End )
        endif
        if udg_fightmod[3] then
            call EnableTrigger( gg_trg_PA_End )
        endif
        if udg_fightmod[4] then
            call EnableTrigger( gg_trg_AL_End )
        endif
    endif
    
    set target = null
    call FlushChildHashtable( udg_hash, id )
endfunction   

function Trig_Blood_Knife_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer x
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0X6'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set x = eyest( caster )
    set id = GetHandleId( caster )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "blkn" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "blkn" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "blkn" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "blkn" ), caster )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "blkn" ) ), 0.01, false, function Blood_KnifeCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Blood_Knife takes nothing returns nothing
    set gg_trg_Blood_Knife = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Blood_Knife, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Blood_Knife, Condition( function Trig_Blood_Knife_Conditions ) )
    call TriggerAddAction( gg_trg_Blood_Knife, function Trig_Blood_Knife_Actions )
endfunction

