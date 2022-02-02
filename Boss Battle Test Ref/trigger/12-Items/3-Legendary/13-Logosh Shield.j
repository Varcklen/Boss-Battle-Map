function Trig_Logosh_Shield_Conditions takes nothing returns boolean
    return luckylogic( udg_DamageEventTarget, 15, 1, 100 ) and ( inv(udg_DamageEventTarget, 'I04T') > 0 or ( inv(udg_DamageEventTarget, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 32] ) )
endfunction

function Logosh_ShieldCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "lgsh" ) ), 'A0SF' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "lgsh" ) ), 'B02C' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Logosh_Shield_Actions takes nothing returns nothing
    local integer id
    local integer ib 
    local integer i
    local integer cyclA = 0
    local real t
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    else
        set caster = udg_DamageEventTarget
        set t = 30
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    set ib = LoadInteger( udg_hash, GetHandleId(LoadTimerHandle( udg_hash, id, StringHash( "lgsh" ) ) ), StringHash( "lgsh" ) )
    
    loop
        exitwhen cyclA > 5
        if ib == cyclA then
            set i = cyclA + 1
            set cyclA = 5
        endif
        set cyclA = cyclA + 1
    endloop
    
    if i > 5 then
        set i = 5
    endif
    
    call UnitAddAbility( caster, 'A0SF')
    call SetUnitAbilityLevel( caster, 'A02C', i )
    call SetUnitAbilityLevel( caster, 'A0FA', i )
    if i < 5 then
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", caster, "origin" ) )
    endif
    
     if LoadTimerHandle( udg_hash, id, StringHash( "lgsh" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "lgsh" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "lgsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "lgsh" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "lgsh" ), i )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "lgsh" ) ), t, false, function Logosh_ShieldCast ) 

    if BuffLogic() then
        call effst( caster, caster, "Trig_Logosh_Shield_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Logosh_Shield takes nothing returns nothing
    set gg_trg_Logosh_Shield = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Logosh_Shield, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Logosh_Shield, Condition( function Trig_Logosh_Shield_Conditions ) )
    call TriggerAddAction( gg_trg_Logosh_Shield, function Trig_Logosh_Shield_Actions )
endfunction

