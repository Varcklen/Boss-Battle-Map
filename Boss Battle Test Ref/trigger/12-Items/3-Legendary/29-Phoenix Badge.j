function Trig_Phoenix_Badge_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0T5' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) 
endfunction

function Phoenix_BadgeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "objct" ) )
    local real hp = LoadReal( udg_hash, id, StringHash( "objcthp" ) )
    local real mp = LoadReal( udg_hash, id, StringHash( "objctmp" ) )
    local real fac = LoadReal( udg_hash, id, StringHash( "objctfac" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "objctx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "objcty" ) )
    
    if udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] then
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call SetUnitPosition( u, x, y )
        elseif IsUnitType( u , UNIT_TYPE_HERO ) then
            call ReviveHero( u, x, y, false )
            call GroupAddUnit( udg_otryad, u )
        else
            call CreateUnit( GetOwningPlayer( u ), GetUnitTypeId( u ), x, y, fac )
        endif
        call SetUnitFacing( u, fac )
        call SetUnitState( u, UNIT_STATE_LIFE, hp * GetUnitState( u, UNIT_STATE_MAX_LIFE ) )
        call SetUnitState( u, UNIT_STATE_MANA, mp * GetUnitState( u, UNIT_STATE_MAX_MANA ) )
    endif
    call UnitRemoveAbility( u, 'A0EX' )
    
    call GroupRemoveUnit( udg_Return, u )
    call UnitRemoveAbility( u, 'A0U5' )
    call UnitRemoveAbility( u, 'B080' )
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Trig_Phoenix_Badge_Actions takes nothing returns nothing
    local integer id 
    local real hp 
    local real mp
    local real fac 
    local real x 
    local real y
    local unit caster
    local unit target
    local integer lvl
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
        call textst( udg_string[0] + GetObjectName('A0T5'), caster, 64, 90, 10, 1.5 )
        set t = 5
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 5
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    set hp = GetUnitState( target, UNIT_STATE_LIFE ) / GetUnitState( target, UNIT_STATE_MAX_LIFE )
    set mp = GetUnitState( target, UNIT_STATE_MANA ) / GetUnitState( target, UNIT_STATE_MAX_MANA )
    set fac = GetUnitFacing( target )
    set x = GetUnitX( target )
    set y = GetUnitY( target )
    
    if GetLocalPlayer() == GetOwningPlayer(target) then
        call StartSound( gg_snd_phoenix_objection )
    endif
 
    call UnitAddAbility( target, 'A0U5' )
    call UnitAddAbility( target, 'A0EX' )
    if not( IsUnitInGroup( target, udg_Return ) ) then
        call GroupAddUnit(udg_Return, target )
    endif
    if LoadTimerHandle( udg_hash, id, StringHash( "objct" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "objct" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "objct" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "objct" ), target )
    call SaveReal( udg_hash, id, StringHash( "objcthp" ), hp )
    call SaveReal( udg_hash, id, StringHash( "objctmp" ), mp )
    call SaveReal( udg_hash, id, StringHash( "objctfac" ), fac )
    call SaveReal( udg_hash, id, StringHash( "objctx" ), x )
    call SaveReal( udg_hash, id, StringHash( "objcty" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "objct" ) ), t, false, function Phoenix_BadgeCast )
    
    if BuffLogic() then
        call effst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Phoenix_Badge takes nothing returns nothing
    set gg_trg_Phoenix_Badge = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Phoenix_Badge, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Phoenix_Badge, Condition( function Trig_Phoenix_Badge_Conditions ) )
    call TriggerAddAction( gg_trg_Phoenix_Badge, function Trig_Phoenix_Badge_Actions )
endfunction

