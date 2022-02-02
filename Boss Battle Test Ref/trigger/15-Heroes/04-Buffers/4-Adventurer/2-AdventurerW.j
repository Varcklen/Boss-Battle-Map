function Trig_AdventurerW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A12L'
endfunction

function AdventurerWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "advw" ) )
    call UnitRemoveAbility( u, LoadInteger( udg_hash, id, StringHash( "advw" ) ) )
    call UnitRemoveAbility( u, LoadInteger( udg_hash, id, StringHash( "advwb" ) ) )
    call FlushChildHashtable( udg_hash, id )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "advrd" ) )
    
    set u = null
endfunction

function Trig_AdventurerW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer rand = GetRandomInt( 1, 3 )
    local integer lvl
    local real t
    local integer sp
    local integer spp
    local integer bf
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        set lvl = udg_Level
        set t = 25
        call textst( udg_string[0] + GetObjectName('A12L'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 25
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    set i = GetPlayerId( GetOwningPlayer( target ) ) + 1
    
    if rand == 1 then
        if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
            call statst( target, 1, 0, 0, 192, true )
            call textst( "|c00FF2020 +1 strength", target, 64, 90, 10, 1 )
        endif
        set sp = 'A12N'
        set spp = 'A12M'
        set bf = 'B05T'
    elseif rand == 2 then
        if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
            call statst( target, 0, 1, 0, 196, true )
            call textst( "|c0020FF20 +1 agility", target, 64, 90, 10, 1 )
        endif
        call SaveReal( udg_hash, GetHandleId( target ), StringHash( "advwd" ), 1 - (0.05 * lvl) )
        set sp = 'A12P'
        set spp = 'A12O'
        set bf = 'B05U'
    elseif rand == 3 then
        if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
            call statst( target, 0, 0, 1, 200, true )
            call textst( "|c002020FF +1 intelligence", target, 64, 90, 10, 1 )
        endif
        set sp = 'A12R'
        set spp = 'A12Q'
        set bf = 'B05V'
    endif
    
    call UnitAddAbility( target, sp )
    call SetUnitAbilityLevel( target, spp, lvl )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "advw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "advw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "advw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "advw" ), target )
    call SaveInteger( udg_hash, id, StringHash( "advw" ), sp )
    call SaveInteger( udg_hash, id, StringHash( "advwb" ), bf )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "advw" ) ), t, false, function AdventurerWCast )
    
    call effst( caster, target, null, lvl, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_AdventurerW takes nothing returns nothing
    set gg_trg_AdventurerW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdventurerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AdventurerW, Condition( function Trig_AdventurerW_Conditions ) )
    call TriggerAddAction( gg_trg_AdventurerW, function Trig_AdventurerW_Actions )
endfunction

