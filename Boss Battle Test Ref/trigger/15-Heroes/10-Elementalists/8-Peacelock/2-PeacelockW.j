function Trig_PeacelockW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A03J'
endfunction

function PeacelockWMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pckw1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "pckw1t" ) )
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "pckw1l" ) )

    if caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(caster, 'B010') > 0 and GetUnitAbilityLevel(target, 'B012') > 0 then
    	call MoveLightningUnits( l, caster, target )
    else
        call UnitRemoveAbility( caster, 'A04I' )
        call UnitRemoveAbility( caster, 'B010' )
        call UnitRemoveAbility( caster, 'A04P' )
        call UnitRemoveAbility( target, 'B012' )
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_PeacelockW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local unit targetRandomEnemy
    local real bindPower
    local integer lvl
    local lightning l
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A03J'), caster, 64, 90, 10, 1.5 )
        set t = 12
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 12
    endif
    set t = timebonus(caster, t)
    set targetRandomEnemy = randomtarget( target, 600, "enemy", "", "", "", "" )
    
    if targetRandomEnemy != null then
        set bindPower = 0.1 + (0.1*lvl)

        call bufst( caster, target, 'A04I', 'B010', "pckw", t )
        call effst( caster, target, null, lvl, t )
        call bufst( caster, targetRandomEnemy, 'A04P', 'B012', "pckw", t )
        call debuffst( caster, targetRandomEnemy, null, lvl, t )
        
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", target, "origin" ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", targetRandomEnemy, "origin" ) )
        
        call SaveUnitHandle( udg_hash, GetHandleId( targetRandomEnemy ), StringHash( "pckw2" ), target )
        call SaveUnitHandle( udg_hash, GetHandleId( targetRandomEnemy ), StringHash( "pckw2c" ), caster )
        call SaveReal( udg_hash, GetHandleId( targetRandomEnemy ), StringHash( "pckw2" ), bindPower )

    	set id = GetHandleId( target )
    	if LoadTimerHandle( udg_hash, id, StringHash( "pckw1" ) ) == null then
    		call SaveTimerHandle( udg_hash, id, StringHash( "pckw1" ), CreateTimer() )
            set l = AddLightningEx("DRAL", true, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target), GetUnitX(targetRandomEnemy), GetUnitY(targetRandomEnemy), GetUnitFlyHeight(targetRandomEnemy))
        else
            set l = LoadLightningHandle( udg_hash, GetHandleId(LoadTimerHandle( udg_hash, id, StringHash( "pckw1" ) ) ), StringHash( "pckw1l" ) )
    	endif
    	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pckw1" ) ) ) 
    	call SaveUnitHandle( udg_hash, id, StringHash( "pckw1" ), target )
    	call SaveUnitHandle( udg_hash, id, StringHash( "pckw1t" ), targetRandomEnemy )
        call SaveLightningHandle( udg_hash, id, StringHash( "pckw1l" ), l )
    	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "pckw1" ) ), 0.02, true, function PeacelockWMove )
    endif
    
    set caster = null
    set target = null
    set targetRandomEnemy = null
    set l = null
endfunction

//===========================================================================
function InitTrig_PeacelockW takes nothing returns nothing
    set gg_trg_PeacelockW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PeacelockW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PeacelockW, Condition( function Trig_PeacelockW_Conditions ) )
    call TriggerAddAction( gg_trg_PeacelockW, function Trig_PeacelockW_Actions )
endfunction