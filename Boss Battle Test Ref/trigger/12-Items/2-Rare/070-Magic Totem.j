function Trig_Magic_Totem_Conditions takes nothing returns boolean
    return ( GetSpellAbilityId() == 'A0TE' ) and ( combat( GetSpellAbilityUnit(), true, 'A0TE' ) )
endfunction

    function Magic_TotemCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call FlushChildHashtable( udg_hash, id )
endfunction

function Magic_TotemData takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mgct" ) )

    call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "mgct" ) ) )
    call UnitRemoveAbility( u, 'A0TG' )
    call UnitRemoveAbility( u, 'B015' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "mgct" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Magic_Totem_Actions takes nothing returns nothing
    local integer id 
    local real r
    local real rsum
    local group g = CreateGroup()
    local unit u
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0TE'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set t = 20
    endif
    set t = timebonus(caster, t)
    
    set r = 5 * eyest( caster )
    set id = GetHandleId( caster )
    
    if IsUnitType( caster, UNIT_TYPE_HERO) then
        call spdst( caster, r )
        set rsum = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "mgct" ) ) + r
        call UnitAddAbility( caster, 'A0TG')
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\GryphonRiderMissile\\GryphonRiderMissileTarget.mdl", caster, "origin") )
        
        if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "mgct" ) ) == null then
            call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "mgct" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mgct" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mgct" ), caster )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "mgct" ), rsum )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mgct" ) ), t, false, function Magic_TotemData ) 
        
        if BuffLogic() then
            call effst( caster, caster, "Trig_Magic_Totem_Actions", 1, t )
        endif
    endif
    
    set caster = null
endfunction


//===========================================================================
function InitTrig_Magic_Totem takes nothing returns nothing
    set gg_trg_Magic_Totem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Totem, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Magic_Totem, Condition( function Trig_Magic_Totem_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_Totem, function Trig_Magic_Totem_Actions )
endfunction

