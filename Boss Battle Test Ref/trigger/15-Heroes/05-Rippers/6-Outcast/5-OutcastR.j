function Trig_OutcastR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07Z'
endfunction

function OutcastRSpell takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "outr" ) )
    local real mp = GetUnitState( u, UNIT_STATE_MANA)
    local integer agi = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "outra" ) )
    local integer int = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "outri" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call statst( u, 0, -agi, -int, 0, false )
        call SetUnitState( u, UNIT_STATE_MANA, mp )
        call UnitRemoveAbility( u, 'A081' )
        call UnitRemoveAbility( u, 'B05Q' )
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "outra" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "outri" ) )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_OutcastR_Actions takes nothing returns nothing
    local integer id 
    local integer agi 
    local integer agisum
    local integer int 
    local integer intsum
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
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07Z'), caster, 64, 90, 10, 1.5 )
        set t = 20 
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20 
    endif
    set t = timebonus(caster, t)

    set id = GetHandleId( target )
    
    if IsUnitType( target, UNIT_TYPE_HERO) then
        call statst( target, 0, -1*LoadInteger( udg_hash, GetHandleId( target ), StringHash( "outra" ) ), -1*LoadInteger( udg_hash, GetHandleId( target ), StringHash( "outri" ) ), 0, false )
        call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "outra" ) )
        call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "outri" ) )
        set agi = R2I((0.25+(0.15*lvl))*GetHeroAgi( caster, true))
        set int = R2I((0.25+(0.15*lvl))*GetHeroInt( caster, true))
        call UnitAddAbility( target, 'A081' )
        call statst( target, 0, agi, int, 0, false )
        set agisum = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "outra" ) ) + agi
        set intsum = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "outra" ) ) + int

        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        
        set id = GetHandleId( target )
        if LoadTimerHandle( udg_hash, id, StringHash( "outr" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "outr" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "outr" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "outr" ), target )
        call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "outra" ), agisum )
        call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "outri" ), intsum )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "outr" ) ), t, false, function OutcastRSpell )
        
        call effst( caster, target, null, lvl, t )
    endif

    if GetUnitAbilityLevel(caster, 'A082') > 0 then
        if udg_outcast[3] then
            set udg_outcast[3] = false
            if not(udg_fightmod[3]) and combat( caster, false, 0 ) then
                call statst( caster, 0, 0, 2, 240, true )
                call textst( "|c002020FF +2 intelligence", caster, 64, 90, 10, 1 )
            endif
            if GetLocalPlayer() == GetOwningPlayer(caster) then
                call BlzFrameSetVisible( outballframe[3], false )
            endif
        endif
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "outer" ) ), 55 - (5*GetUnitAbilityLevel(caster, 'A082')), true, function OutcastEREnd )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OutcastR takes nothing returns nothing
    set gg_trg_OutcastR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OutcastR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OutcastR, Condition( function Trig_OutcastR_Conditions ) )
    call TriggerAddAction( gg_trg_OutcastR, function Trig_OutcastR_Actions )
endfunction