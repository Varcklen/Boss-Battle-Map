function Trig_Corrupted_EntQCharges_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OE'
endfunction

function Corrupted_EntQCharge takes nothing returns nothing 
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "entqe" ) )
    local integer unitId = GetHandleId( u )
    local integer k = LoadInteger( udg_hash, unitId, StringHash( "entqch" ) )
    local integer pat = LoadInteger( udg_hash, id, StringHash( "entqe" ) )

    if pat == udg_Pattern then
        set k = k + 1
        if k > CorruptedEntQ_CHARGE_LIMIT then
            set k = CorruptedEntQ_CHARGE_LIMIT
        endif
        if GetLocalPlayer() == GetOwningPlayer(u) then
            call BlzFrameSetText( entQText, I2S(k) )
        endif
        call SaveInteger( udg_hash, unitId, StringHash( "entqch" ), k )
        call BlzEndUnitAbilityCooldown( u, 'A0OE' )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Corrupted_EntQCool takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "entqc" ) )

    call BlzEndUnitAbilityCooldown( u, 'A0OE' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_Corrupted_EntQCharges_Actions takes nothing returns nothing
    local unit caster = GetSpellAbilityUnit()
    local integer unitId = GetHandleId( caster )
    local integer k = LoadInteger( udg_hash, unitId, StringHash( "entqch" ) )
    local real t
    local integer id

    if k > 0 then
        set k = k - 1
        call SaveInteger( udg_hash, unitId, StringHash( "entqch" ), k )
        
        call BlzFrameSetText( entQText, I2S(k) )
        set t = BlzGetAbilityRealLevelField(BlzGetUnitAbility(caster, 'A0OE'), ABILITY_RLF_COOLDOWN, 0) 
        if k > 0 then
            set id = InvokeTimerWithUnit( caster, "entqc", 0.01, false, function Corrupted_EntQCool )
        endif
        if GetLocalPlayer() == GetOwningPlayer(caster) then
            call BlzFrameSetText( entQText, I2S(k) )
        endif
        
        //set id = InvokeTimerWithUnit( caster, "entq", t, false, function Corrupted_EntQCharge )
        //call SaveInteger( udg_hash, id, StringHash( "entq" ), udg_Pattern )
        
        set id = GetHandleId( caster )
        call SaveTimerHandle( udg_hash, id, StringHash( "entqe" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "entqe" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "entqe" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "entqe" ), udg_Pattern )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "entqe" ) ), t, false, function Corrupted_EntQCharge )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Corrupted_EntQCharges takes nothing returns nothing
    set gg_trg_Corrupted_EntQCharges = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Corrupted_EntQCharges, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Corrupted_EntQCharges, Condition( function Trig_Corrupted_EntQCharges_Conditions ) )
    call TriggerAddAction( gg_trg_Corrupted_EntQCharges, function Trig_Corrupted_EntQCharges_Actions )
endfunction

