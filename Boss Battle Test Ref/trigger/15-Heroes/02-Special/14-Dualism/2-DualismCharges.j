function Trig_DualismCharges_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BK'
endfunction

function DualismCharge takes nothing returns nothing 
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dual" ) )
    local integer k = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "dualch" ) )
    local integer pat = LoadInteger( udg_hash, id, StringHash( "dual" ) )

    if pat == udg_Pattern then
        set k = k + 1
        if k > 3 then
            set k = 3
        endif
        if GetLocalPlayer() == GetOwningPlayer(u) then
            call BlzFrameSetText( dualtext, I2S(k) )
        endif
        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "dualch" ), k )
        call BlzEndUnitAbilityCooldown( u, 'A1BK' )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function DualismCool takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dualc" ) )

    call BlzEndUnitAbilityCooldown( u, 'A1BK' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_DualismCharges_Actions takes nothing returns nothing
    local integer k = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "dualch" ) )
    local real t
    local integer id

    if k > 0 then
        call SaveInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "dualch" ), k - 1 )
        set k = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "dualch" ) )
        
        call BlzFrameSetText( dualtext, I2S(k) )
        set t = BlzGetAbilityRealLevelField(BlzGetUnitAbility(GetSpellAbilityUnit(), 'A1BK'), ABILITY_RLF_COOLDOWN, 0) 
        if k > 0 then
            set id = GetHandleId( GetSpellAbilityUnit() )
            if LoadTimerHandle( udg_hash, id, StringHash( "dualc" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "dualc" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dualc" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "dualc" ), GetSpellAbilityUnit() )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "dualc" ) ), 0.01, false, function DualismCool )
        endif
        if GetLocalPlayer() == GetOwningPlayer(GetSpellAbilityUnit()) then
            call BlzFrameSetText( dualtext, I2S(k) )
        endif
        
        set id = GetHandleId( GetSpellAbilityUnit() )
        call SaveTimerHandle( udg_hash, id, StringHash( "dual" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "dual" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "dual" ), GetSpellAbilityUnit() )
        call SaveInteger( udg_hash, id, StringHash( "dual" ), udg_Pattern )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( "dual" ) ), t, false, function DualismCharge )
    endif
endfunction

//===========================================================================
function InitTrig_DualismCharges takes nothing returns nothing
    set gg_trg_DualismCharges = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DualismCharges, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DualismCharges, Condition( function Trig_DualismCharges_Conditions ) )
    call TriggerAddAction( gg_trg_DualismCharges, function Trig_DualismCharges_Actions )
endfunction

