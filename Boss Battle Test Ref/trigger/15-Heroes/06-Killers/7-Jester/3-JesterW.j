function Trig_JesterW_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0JN'
endfunction

function JesterWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "jesw" ) )
    
    call UnitRemoveAbility( caster, 'A0JW' )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function Trig_JesterW_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local integer lvl
    local real t
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0JN'), caster, 64, 90, 10, 1.5 )
        set t = 4
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 4
    endif
    set t = timebonus(caster, t)
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    call UnitAddAbility( caster, 'A0JW' )
    call shadowst( caster )
    if LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "jesw" ) ) == null then
        call SaveTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "jesw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, GetHandleId( caster ), StringHash( "jesw" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "jesw" ), caster )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "jesw" ) ), t, false, function JesterWEnd )
    
    call effst( caster, caster, null, lvl, t )
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'e003', GetUnitX( caster ), GetUnitY( caster ), GetUnitFacing( caster ) )
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(caster)) )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, BlzGetUnitBaseDamage(caster, 0), 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_LIFE) )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', 4 )
    
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call hpoisonst( caster, u, lvl )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_JesterW takes nothing returns nothing
    set gg_trg_JesterW = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_JesterW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_JesterW, Condition( function Trig_JesterW_Conditions ) )
    call TriggerAddAction( gg_trg_JesterW, function Trig_JesterW_Actions )
endfunction

