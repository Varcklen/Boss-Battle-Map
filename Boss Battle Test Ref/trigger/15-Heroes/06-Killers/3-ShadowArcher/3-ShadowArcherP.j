function Trig_ShadowArcherP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0ID'
endfunction

function ShadowArcherPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "sdap" ) )
    local integer attackExtra = LoadInteger( udg_hash, id, StringHash( "sdap" ))
    local integer attackBonus = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sdapb" ))
    
    if GetUnitAbilityLevel(u, 'A0ID') == 0 then
        call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - attackBonus, 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] and not(udg_fightmod[3]) and not( IsUnitLoaded( u ) ) then
        set attackBonus = attackBonus + attackExtra
        call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) + attackExtra, 0 )
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "sdapb" ), attackBonus)
    endif
    
    set u = null
endfunction

function Trig_ShadowArcherP_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "sdap" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "sdap" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sdap" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "sdap" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "sdap" ), GetUnitAbilityLevel(GetLearningUnit(), GetLearnedSkill() ) + 1 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "sdap" ) ), 1, true, function ShadowArcherPCast )
endfunction

//===========================================================================
function InitTrig_ShadowArcherP takes nothing returns nothing
    set gg_trg_ShadowArcherP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShadowArcherP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_ShadowArcherP, Condition( function Trig_ShadowArcherP_Conditions ) )
    call TriggerAddAction( gg_trg_ShadowArcherP, function Trig_ShadowArcherP_Actions )
endfunction

scope ShadowArcherE initializer Triggs
    private function DeleteBonusDamage takes unit hero returns nothing
        local integer attackBonus = LoadInteger( udg_hash, GetHandleId( hero ), StringHash( "sdapb" ))
        
        if attackBonus <= 0 then
            return
        endif
        
        call BlzSetUnitBaseDamage( hero, BlzGetUnitBaseDamage(hero, 0) - attackBonus, 0 )
        call SaveInteger( udg_hash, GetHandleId( hero ), StringHash( "sdapb" ), 0)
        
        set hero = null
    endfunction
    
    private function Cast takes nothing returns nothing
        if GetUnitAbilityLevel(udg_DamageEventSource, 'A0ID') > 0 and GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) > 0.405 and udg_IsDamageSpell == false then
            call DeleteBonusDamage(udg_DamageEventSource)
        endif
    endfunction
    
    private function FightEnd takes nothing returns nothing
        if GetUnitAbilityLevel(udg_FightEnd_Unit, 'A0ID') > 0 then
            call DeleteBonusDamage(udg_FightEnd_Unit)
        endif
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger(  )
        
        call TriggerRegisterVariableEvent( trig, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddAction( trig, function Cast )
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_FightEnd_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function FightEnd )
        
        set trig = null
    endfunction
endscope

