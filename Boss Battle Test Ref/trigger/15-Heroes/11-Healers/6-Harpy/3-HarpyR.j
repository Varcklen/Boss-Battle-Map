function Trig_HarpyR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UD' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function HarpyREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "harr1" ) )
    local real r = LoadReal( udg_hash, id, StringHash( "harr1" ) )

    if (GetOwningPlayer(u) == Player(4) or udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1]) and GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        call ReviveHeroLoc( u, GetUnitLoc( u ), true )
        call ShowUnitShow( u )
        if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
            set udg_Heroes_Deaths = udg_Heroes_Deaths + 1
        else
            call GroupAddUnit( udg_otryad, u )
            call PauseUnit( u, false )
            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * r * 0.01 )
            call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * r * 0.01 )
        endif
    endif
    call UnitRemoveAbility( u, 'A0EX' )
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function HarpyRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "harr" ) )
    local integer id1 = GetHandleId( target )
    local real r = LoadInteger( udg_hash, id, StringHash( "harrlvl" ) )

    if udg_combatlogic[GetPlayerId( GetOwningPlayer( target ) ) + 1] then
        set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( target ), GetUnitY( target ), 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
        
        if LoadTimerHandle( udg_hash, id1, StringHash( "harr1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id1, StringHash( "harr1" ), CreateTimer() )
        endif
        set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "harr1" ) ) ) 
        call SaveUnitHandle( udg_hash, id1, StringHash( "harr1" ), target )
        call SaveReal( udg_hash, id1, StringHash( "harr1" ), r )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "harr1" ) ), 3, false, function HarpyREnd )
        
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
    
    call FlushChildHashtable( udg_hash, id )
    
    set target = null
endfunction   

function Trig_HarpyR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0UD'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set id = GetHandleId( target )
    call UnitAddAbility( target, 'A0EX' )

    if LoadTimerHandle( udg_hash, id, StringHash( "harr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "harr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "harr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "harr" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "harrc" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "harrlvl" ), 10 + ( 10 * lvl ) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "harr" ) ), 0.01, false, function HarpyRCast )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_HarpyR takes nothing returns nothing
    set gg_trg_HarpyR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HarpyR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_HarpyR, Condition( function Trig_HarpyR_Conditions ) )
    call TriggerAddAction( gg_trg_HarpyR, function Trig_HarpyR_Actions )
endfunction