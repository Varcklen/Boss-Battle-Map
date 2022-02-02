function Trig_KeeperE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0A9'
endfunction

function KeeperECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "kepe" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "kepelvl" ) )
    local integer cyclA
    local boolean l = false
    
    if GetUnitAbilityLevel( caster, 'A0A9') == 0 or caster == null then
        call UnitRemoveAbility( caster, 'A0BH' )
        call UnitRemoveAbility( caster, 'A0B5' )
        call UnitRemoveAbility( caster, 'B09C' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if DistanceBetweenUnits( caster, udg_hero[cyclA] ) < 900 and caster != udg_hero[cyclA] and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                set l = true
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        if (caster == udg_unit[57] or caster == udg_unit[58] or not(l)) and GetUnitAbilityLevel( caster, 'A0BH') > 0 then
            call UnitRemoveAbility( caster, 'A0BH' )
            call UnitRemoveAbility( caster, 'A0B5' )
            call UnitRemoveAbility( caster, 'B09C' )
        elseif caster != udg_unit[57] and caster != udg_unit[58] and l and GetUnitAbilityLevel( caster, 'A0BH') == 0 then
            call UnitAddAbility( caster, 'A0BH' )
            call UnitAddAbility( caster, 'A0B5' )
            call SetUnitAbilityLevel( caster, 'A0B5', lvl )
            call shadowst(caster)
        endif
    endif
    
    set caster = null
endfunction

function Trig_KeeperE_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    call UnitRemoveAbility( GetLearningUnit(), 'A0BH' )
    call UnitRemoveAbility( GetLearningUnit(), 'A0B5' )
    call UnitRemoveAbility( GetLearningUnit(), 'B09C' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "kepe" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "kepe" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "kepe" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "kepe" ), GetLearningUnit() ) 
    call SaveInteger( udg_hash, id, StringHash( "kepelvl" ), GetUnitAbilityLevel( GetLearningUnit(), 'A0A9' ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "kepe" ) ), 1, true, function KeeperECast )
endfunction

//===========================================================================
function InitTrig_KeeperE takes nothing returns nothing
    set gg_trg_KeeperE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KeeperE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_KeeperE, Condition( function Trig_KeeperE_Conditions ) )
    call TriggerAddAction( gg_trg_KeeperE, function Trig_KeeperE_Actions )
endfunction

