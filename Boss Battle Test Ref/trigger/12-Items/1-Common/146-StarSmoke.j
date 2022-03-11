function Trig_StarSmoke_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0BD'
endfunction

function StarSmokeCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "stsm" ) )
    
    call UnitRemoveAbility( u, 'A0BE' )
    call UnitRemoveAbility( u, 'A0LJ' )
    call UnitRemoveAbility( u, 'B00P' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_StarSmoke_Actions takes nothing returns nothing
    local unit caster
    local unit u
    local integer id 
    local integer cyclA = 1
    local integer x
    local integer i
    local real t
    
    if CastLogic() then
        set caster = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0BD'), caster, 64, 90, 10, 1.5 )
        set t = 3
    else
        set caster = GetSpellAbilityUnit()
        set t = 3
    endif 
    set t = timebonus(caster, t)
    set x = eyest( caster )
    
    if udg_BuffLogic then
        set i = 1
    else
        set i = 4
    endif

    loop
        exitwhen cyclA > i
        if udg_BuffLogic then
            set u = caster
        else
            set u = udg_hero[cyclA]
        endif
        if unitst( u, caster, "ally" ) then
            call UnitAddAbility( u, 'A0BE')
            call UnitAddAbility( u, 'A0LJ')
            call shadowst( u )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl", u, "origin"))
            
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "stsm" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "stsm" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "stsm" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "stsm" ), u )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "stsm" ) ), t, false, function StarSmokeCast )
            
            if BuffLogic() then
                call effst( caster, u, "Trig_StarSmoke_Actions", 1, t )
            else
                set cyclA = i
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set u = null
endfunction

//===========================================================================
function InitTrig_StarSmoke takes nothing returns nothing
    set gg_trg_StarSmoke = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_StarSmoke, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_StarSmoke, Condition( function Trig_StarSmoke_Conditions ) )
    call TriggerAddAction( gg_trg_StarSmoke, function Trig_StarSmoke_Actions )
endfunction

