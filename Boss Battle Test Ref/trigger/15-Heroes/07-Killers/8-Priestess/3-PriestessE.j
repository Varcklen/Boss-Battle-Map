function Trig_PriestessE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A03X'
endfunction

function PriestessECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "prse" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "prsel" ) )
    local integer arm = LoadInteger( udg_hash, id, StringHash( "prsea" ) )
    local integer pets = CountLivingPlayerUnitsOfTypeId('n020', GetOwningPlayer(caster))
    local real spd = (pets - arm) * LoadInteger( udg_hash, id, StringHash( "prse" ) )
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "prsen" ) )
    
	if GetUnitAbilityLevel(caster, 'A03X') == 0 then
        call spdstpl( pl, -spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "prsen" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != pets then
        call spdstpl( pl, spd )
		call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "prsen" ), spdnow + spd ) 
        call SaveInteger( udg_hash, id, StringHash( "prsea" ), pets ) 
    endif

    set caster = null
endfunction

function Trig_PriestessE_Actions takes nothing returns nothing
    local integer id

    call spdst( GetLearningUnit(), -1*LoadReal( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "prsen" ) ) )
    call SaveReal( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "prsen" ), 0 )

    set id = GetHandleId( GetLearningUnit() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "prse" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "prse" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "prse" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "prse" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "prsel" ), GetPlayerId( GetOwningPlayer( GetLearningUnit() ) ) )
    call SaveInteger( udg_hash, id, StringHash( "prse" ), GetUnitAbilityLevel(GetLearningUnit(), 'A03X') + 1 ) 
    call SaveInteger( udg_hash, id, StringHash( "prsea" ), 0 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "prse" ) ), 1, true, function PriestessECast )
endfunction

//===========================================================================
function InitTrig_PriestessE takes nothing returns nothing
    set gg_trg_PriestessE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PriestessE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_PriestessE, Condition( function Trig_PriestessE_Conditions ) )
    call TriggerAddAction( gg_trg_PriestessE, function Trig_PriestessE_Actions )
endfunction

