function Trig_AltarR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A12B'
endfunction

function AtlarREnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "altr" ) )
    
    call UnitRemoveAbility( caster, 'A12Z' )
    call UnitRemoveAbility( caster, 'A0FZ' )
    call UnitRemoveAbility( caster, 'A0PB' )
    call UnitRemoveAbility( caster, 'B08C' )
    call FlushChildHashtable( udg_hash, id )
    
    set caster = null
endfunction

function AtlarRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real counter = LoadReal( udg_hash, id, StringHash( "altr" ) ) - 1
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "altrc" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "altr" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "altrh" ) )
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call healst( caster, target, heal )
    endif
    
    if counter > 0 then
        call SaveReal( udg_hash, id, StringHash( "altr" ), counter )
    else
        call UnitRemoveAbility( target, 'A12Z' )
        call UnitRemoveAbility( target, 'A0FZ' )
        call UnitRemoveAbility( target, 'A0PB' )
        call UnitRemoveAbility( target, 'B08C' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_AltarR_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real heal
    local integer id
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notcaster", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A12B'), caster, 64, 90, 10, 1.5 )
        set t = 15
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 15
    endif
    set t = timebonus(caster, t)
    set heal = 10 + ( 5 * lvl )
    
    if GetUnitAbilityLevel( caster, 'A12W') > 0 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetUnitX( target ), GetUnitY( target) ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetUnitX( caster ), GetUnitY( caster) ) )
        
        set id = GetHandleId( target )
        call UnitAddAbility( target, 'A12Z' )
        call UnitAddAbility( target, 'A0FZ' )
        call UnitAddAbility( target, 'A0PB' )
        call SetUnitAbilityLevel( target, 'A0FZ', lvl )
        call SetUnitAbilityLevel( target, 'A0PB', lvl )
        if LoadTimerHandle( udg_hash, id, StringHash( "altr" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "altr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "altr" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "altr" ), target )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "altr" ) ), t, false, function AtlarREnd )
        
        if BuffLogic() then
            call effst( caster, target, null, lvl, t )
        endif
        
        set id = GetHandleId( caster )
        call UnitAddAbility( caster, 'A12Z' )
        call UnitAddAbility( caster, 'A0FZ' )
        call UnitAddAbility( caster, 'A0PB' )
        call SetUnitAbilityLevel( caster, 'A0FZ', lvl )
        call SetUnitAbilityLevel( caster, 'A0PB', lvl )
        if LoadTimerHandle( udg_hash, id, StringHash( "altr" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "altr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "altr" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "altr" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "altr" ) ), t, false, function AtlarREnd )
        
        if BuffLogic() then
            call effst( caster, caster, null, lvl, t )
        endif
    else
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", GetUnitX( target ), GetUnitY( target) ) )
        set id = GetHandleId( target )
        call UnitAddAbility( target, 'A12Z' )
        call UnitAddAbility( target, 'A0PB' )
        call SetUnitAbilityLevel( target, 'A0PB', lvl )
        if LoadTimerHandle( udg_hash, id, StringHash( "altr" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "altr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "altr" ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "altr" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "altrc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "altr" ), t )
        call SaveReal( udg_hash, id, StringHash( "altrh" ), heal )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "altr" ) ), 1, true, function AtlarRCast )
        
        if BuffLogic() then
            call effst( caster, target, null, lvl, t )
        endif
        
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - (95+(5*lvl)) ))
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AltarR takes nothing returns nothing
    set gg_trg_AltarR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AltarR, Condition( function Trig_AltarR_Conditions ) )
    call TriggerAddAction( gg_trg_AltarR, function Trig_AltarR_Actions )
endfunction

