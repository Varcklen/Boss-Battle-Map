function Trig_ShoggothR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A199'
endfunction

function ShoggothRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shgw" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "shgwx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "shgwy" ) )
    
    if GetUnitState( caster, UNIT_STATE_LIFE) <= 0.405 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'n02J', x+GetRandomReal( -250, 250 ), y+GetRandomReal( -250, 250 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 10 )
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", bj_lastCreatedUnit, "origin"))
    endif
    
    set caster = null
endfunction

function Trig_ShoggothR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer id
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A199'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set t = 7-lvl
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'u000', x, y, 270 )
    call UnitAddAbility( bj_lastCreatedUnit, 'A19B' )
    call SetUnitScale( bj_lastCreatedUnit, 2.5, 2.5, 2.5 )
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 20.1 )

    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "shgw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "shgw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shgw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "shgw" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "shgwx" ), x )
    call SaveReal( udg_hash, id, StringHash( "shgwy" ), y )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "shgw" ) ), t, true, function ShoggothRCast )

    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothR takes nothing returns nothing
    set gg_trg_ShoggothR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothR, Condition( function Trig_ShoggothR_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothR, function Trig_ShoggothR_Actions )
endfunction

