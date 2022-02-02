function Trig_Archer_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and luckylogic( udg_DamageEventSource, 10, 1, 100 ) and ( inv(udg_DamageEventSource, 'I04Y') > 0 or ( inv(udg_DamageEventSource, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1] ) )
endfunction

function ArcherCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "arch" ) ), 'A0QU' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "arch" ) ), 'B03H' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Archer_Actions takes nothing returns nothing
    local integer id 
    local integer ib
    local integer i
    local integer cyclA = 0
    local real t = 15
    local unit caster = udg_DamageEventSource

    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    set ib = LoadInteger( udg_hash, GetHandleId(LoadTimerHandle( udg_hash, id, StringHash( "arch" ) ) ), StringHash( "archi" ) )
    
    loop
        exitwhen cyclA > 3
        if ib == cyclA then
            set i = cyclA + 1
            set cyclA = 3
        endif
        set cyclA = cyclA + 1
    endloop
    
    if i > 3 then
        set i = 3
    endif
    
    call UnitAddAbility( caster, 'A0QU')
    call SetUnitAbilityLevel( caster, 'A0FJ', i )

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl", caster, "origin" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "arch" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "arch" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "arch" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "arch" ), caster )
    call SaveInteger( udg_hash, id, StringHash( "archi" ), i )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "arch" ) ), t, false, function ArcherCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_Archer_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Archer takes nothing returns nothing
    set gg_trg_Archer = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Archer, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Archer, Condition( function Trig_Archer_Conditions ) )
    call TriggerAddAction( gg_trg_Archer, function Trig_Archer_Actions )
endfunction

