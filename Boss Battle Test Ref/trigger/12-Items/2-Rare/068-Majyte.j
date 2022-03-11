function Trig_Majyte_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YA' and GetUnitAbilityLevel( GetSpellAbilityUnit(), 'A0YC') == 0
endfunction

function Trig_Majyte_Actions takes nothing returns nothing
    local integer id 
    local real r
    local real rsum
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local integer i
    local integer x
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YA'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set t = 10
    endif
    set t = timebonus(caster, t)

    set i = GetPlayerId(GetOwningPlayer( caster )) + 1
    if IsUnitType( caster, UNIT_TYPE_HERO) then
        set id = GetHandleId( caster )
        set r = 150*eyest( caster )
        set rsum = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "majt" ) ) + r
        call spdst( caster, r )
        call UnitAddAbility( caster, 'A0YC')
        
        if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "majt" ) ) == null   then
            call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "majt" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "majt" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "majt" ), caster )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "majt" ), rsum )
        call SaveBoolean( udg_hash, GetHandleId(caster), StringHash( "majt" ), true )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "majt" ) ), t, false, function MajyteCast ) 
        
        if BuffLogic() then
            call effst( caster, caster, null, 1, t )
        endif
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Majyte takes nothing returns nothing
    set gg_trg_Majyte = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Majyte, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Majyte, Condition( function Trig_Majyte_Conditions ) )
    call TriggerAddAction( gg_trg_Majyte, function Trig_Majyte_Actions )
endfunction