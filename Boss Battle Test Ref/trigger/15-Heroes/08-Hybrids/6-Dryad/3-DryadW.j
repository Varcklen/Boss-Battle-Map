function Trig_DryadW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0I0'
endfunction

function DryadWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "drdw" ) )
    
    call UnitRemoveAbility( u, 'A0GX' )
    call UnitRemoveAbility( u, 'B06F' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_DryadW_Actions takes nothing returns nothing
    local integer id 
    local integer i
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
        set t = 15
        call textst( udg_string[0] + GetObjectName('A0I0'), caster, 64, 90, 10, 1.5 )
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
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A0GX' )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", target, "origin" ) )
    if LoadTimerHandle( udg_hash, id, StringHash( "drdw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "drdw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "drdw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "drdw" ), target )
    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call SaveBoolean( udg_hash, GetHandleId( target ), StringHash( "drdw" ), true )
        if BuffLogic() then
            call effst( caster, target, "Trig_DryadW_Actions", lvl, t )
        endif
    else
        if BuffLogic() then
            call debuffst( caster, target, "Trig_DryadW_Actions", lvl, t )
        endif
    endif
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "drdw" ), 0.1 + ( 0.1 * lvl ) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "drdw" ) ), t, false, function DryadWEnd )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DryadW takes nothing returns nothing
    set gg_trg_DryadW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DryadW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DryadW, Condition( function Trig_DryadW_Conditions ) )
    call TriggerAddAction( gg_trg_DryadW, function Trig_DryadW_Actions )
endfunction

