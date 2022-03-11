function Trig_GhostQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0MD'
endfunction

function GhostQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "qhq" ) )
    
    call UnitRemoveAbility( u, 'A0MA' )
    call UnitRemoveAbility( u, 'A08J' )
    call UnitRemoveAbility( u, 'B01L' )
    call FlushChildHashtable( udg_hash, id )
    
     set u = null
endfunction

function Trig_GhostQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0MD'), caster, 64, 90, 10, 1.5 )
        set t = 10
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 10
    endif
    set t = timebonus(caster, t)
    set heal = 75 + ( 25 * lvl )
    set id = GetHandleId( target )
    
    call UnitAddAbility( target, 'A0MA' )
    call SetUnitAbilityLevel( target, 'A08J', lvl )
    if IsUnitType( target, UNIT_TYPE_ANCIENT) then 
        call healst( caster, null, heal )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", caster, "origin" ) )
    endif
    
    if LoadTimerHandle( udg_hash, id, StringHash( "qhq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "qhq" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "qhq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "qhq" ), target )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "qhq" ) ), t, false, function GhostQCast )
    if BuffLogic() then
        call debuffst( caster, target, "Trig_GhostQ_Actions", lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction
//===========================================================================
function InitTrig_GhostQ takes nothing returns nothing
    set gg_trg_GhostQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GhostQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GhostQ, Condition( function Trig_GhostQ_Conditions ) )
    call TriggerAddAction( gg_trg_GhostQ, function Trig_GhostQ_Actions )
endfunction

