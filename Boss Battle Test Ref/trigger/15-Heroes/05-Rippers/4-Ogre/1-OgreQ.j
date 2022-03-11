function Trig_OgreQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0ET' 
endfunction

function Trig_OgreQ_Actions takes nothing returns nothing
	local integer id
    local unit caster
    local unit target
    local integer lvl
    local integer money
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        set t = 3
        call textst( udg_string[0] + GetObjectName('A0ET'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 3
    endif
    set t = timebonus(caster, t)
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( target ), GetUnitY( target )) )
    call UnitAddAbility( target, 'A0DP' )
    call SetUnitAbilityLevel( target, 'A0DM', lvl )
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "ogrq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "ogrq" ), CreateTimer() )
    endif
    call SaveUnitHandle( udg_hash, id, StringHash( "ogrqt" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "ogrqc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "ogrq" ), 20*lvl )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ogrq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "ogrqd" ), target )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "ogrq" ) ), t, false, function OgreQEnd )
    if BuffLogic() then
        call debuffst( caster, target, "Trig_OgreQ_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OgreQ takes nothing returns nothing
    set gg_trg_OgreQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OgreQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OgreQ, Condition( function Trig_OgreQ_Conditions ) )
    call TriggerAddAction( gg_trg_OgreQ, function Trig_OgreQ_Actions )
endfunction
