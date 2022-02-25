//TESH.scrollpos=11
//TESH.alwaysfold=0
function Trig_Mark_of_Calm_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0T1' 
endfunction

function Mark_of_CalmCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mroc" ) ), 'A0T3' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mroc" ) ), 'B014' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Mark_of_Calm_Actions takes nothing returns nothing
    local integer id 
    local integer x
    local unit caster
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0T1' ), caster, 64, 90, 10, 1.5 )
        set t = 15
    else
        set caster = GetSpellAbilityUnit()
        set t = 15
    endif
    set t = timebonus(caster, t)

    set id = GetHandleId( caster )
    set x = eyest( caster )
    
    call UnitAddAbility( caster, 'A0T3' )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", caster, "origin" ) )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "mroc" ) ) == null then 
        call SaveTimerHandle( udg_hash, id, StringHash( "mroc" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mroc" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "mroc" ), caster )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mroc" ) ), t, false, function Mark_of_CalmCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_Mark_of_Calm_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Mark_of_Calm takes nothing returns nothing
    set gg_trg_Mark_of_Calm = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mark_of_Calm, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mark_of_Calm, Condition( function Trig_Mark_of_Calm_Conditions ) )
    call TriggerAddAction( gg_trg_Mark_of_Calm, function Trig_Mark_of_Calm_Actions )
endfunction

