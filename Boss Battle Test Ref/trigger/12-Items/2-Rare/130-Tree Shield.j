function Trig_Tree_Shield_Conditions takes nothing returns boolean
    return (GetUnitTypeId(udg_DamageEventTarget) != 'u000') and luckylogic( udg_DamageEventTarget, 10, 1, 100 ) and ( inv(udg_DamageEventTarget, 'I04S') > 0 or ( inv(udg_DamageEventTarget, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventTarget)) + 1 + 48] ) )
endfunction

function Tree_ShieldCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "trsh" ) ), 'A0QP' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "trsh" ) ), 'B03C' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Tree_Shield_Actions takes nothing returns nothing
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
        set t = 18
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    set ib = LoadInteger( udg_hash, GetHandleId(LoadTimerHandle( udg_hash, id, StringHash( "trsh" ) ) ), StringHash( "trsh" ) )
    
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
    
    call UnitAddAbility( caster, 'A0QP' )
    call SetUnitAbilityLevel( caster, 'A0QN', i )

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl", caster, "origin" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "trsh" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "trsh" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "trsh" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "trsh" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "trsh" ), i )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "trsh" ) ), t, false, function Tree_ShieldCast ) 
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_Tree_Shield_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Tree_Shield takes nothing returns nothing
    set gg_trg_Tree_Shield = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Tree_Shield, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Tree_Shield, Condition( function Trig_Tree_Shield_Conditions ) )
    call TriggerAddAction( gg_trg_Tree_Shield, function Trig_Tree_Shield_Actions )
endfunction

