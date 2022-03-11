function Trig_ShoggothR123123_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0X4'
endfunction

function ShoggothRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer p = LoadInteger( udg_hash, id, StringHash( "shgr" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shgr" ) )

    call spdstpl( p, -1 * LoadReal( udg_hash, GetHandleId( u ), StringHash( "shgr" ) ) )
    call UnitRemoveAbility( u, 'A0XD' )
    call UnitRemoveAbility( u, 'B087' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "shgr" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_ShoggothR123123_Actions takes nothing returns nothing
    local integer id 
    local real r
    local real rsum
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local integer i
    local real t
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0X4'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    set i = GetPlayerId(GetOwningPlayer( caster )) + 1
    if IsUnitType( caster, UNIT_TYPE_HERO) then
        set id = GetHandleId( caster )
        set r = 10 + (10*lvl)
        set rsum = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "shgr" ) ) + r
        call spdst( caster, r )
        call UnitAddAbility( caster, 'A0XD')
        call SetUnitAbilityLevel( caster, 'A0X5', lvl )
        call SetUnitAbilityLevel( caster, 'A0XA', lvl )
        
        if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "shgr" ) ) == null   then
            call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "shgr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "shgr" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "shgr" ), caster )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "shgr" ), rsum )
        call SaveInteger( udg_hash, id, StringHash( "shgr" ), GetPlayerId( GetOwningPlayer( caster ) ) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shgr" ) ), t, false, function ShoggothRCast ) 
        
        if BuffLogic() then
            call effst( caster, caster, null, lvl, t )
        endif
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothR123123 takes nothing returns nothing
    set gg_trg_ShoggothR123123 = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothR123123, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothR123123, Condition( function Trig_ShoggothR123123_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothR123123, function Trig_ShoggothR123123_Actions )
endfunction

