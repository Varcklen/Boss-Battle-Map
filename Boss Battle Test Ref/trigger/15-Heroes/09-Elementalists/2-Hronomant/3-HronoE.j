globals
    constant real CHRONOMANCER_E_REDUCTION = 0.8
endglobals

function Trig_HronoE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A00P'
endfunction

function HronoECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "hrne" ) )
    local integer unitId = GetHandleId( caster )
    local integer cool = LoadInteger( udg_hash, id, StringHash( "hrne" ) )
    local real c = LoadReal( udg_hash, unitId, StringHash( "hrnec" ) ) - CHRONOMANCER_E_REDUCTION
    
    if GetUnitAbilityLevel( caster, 'A00P' ) == 0 then
        call FlushChildHashtable( udg_hash, id )
    elseif c <= 0 then
        call SaveReal( udg_hash, unitId, StringHash( "hrnec" ), cool )
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( caster ) ) then
            call coldstop( caster )
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\Sci Teleport.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
        endif
        if GetUnitAbilityLevel( caster, 'A00P') > 0 then
            call BlzStartUnitAbilityCooldown( caster, 'A00P', cool )
        endif
    else
        call SaveReal( udg_hash, unitId, StringHash( "hrnec" ), c )
    endif
    
    set caster = null
endfunction

function Trig_HronoE_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    local integer cool = 75 - (5*GetUnitAbilityLevel( GetLearningUnit(), 'A00P' ))
    
    call BlzStartUnitAbilityCooldown( GetLearningUnit(), 'A00P', cool )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "hrne" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "hrne" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "hrne" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "hrne" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "hrne" ), cool )
    call SaveReal( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "hrnec" ), cool )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "hrne" ) ), CHRONOMANCER_E_REDUCTION, true, function HronoECast )
endfunction

//===========================================================================
function InitTrig_HronoE takes nothing returns nothing
    set gg_trg_HronoE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_HronoE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_HronoE, Condition( function Trig_HronoE_Conditions ) )
    call TriggerAddAction( gg_trg_HronoE, function Trig_HronoE_Actions )
endfunction

