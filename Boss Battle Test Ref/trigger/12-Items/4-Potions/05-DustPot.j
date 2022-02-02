function Trig_DustPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0KF'
endfunction

function DustPotCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "dustt" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "dust" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "dust" ) )
    
    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        set udg_logic[52] = true
        call healst( u, null, heal )
    endif
    
    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(u, 'B02J') > 0 then
        call SaveReal( udg_hash, id, StringHash( "dustt" ), counter - 1 )
    else
        call UnitRemoveAbility( u, 'A0R9' )
        call UnitRemoveAbility( u, 'B02J' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set u = null
endfunction

function Trig_DustPot_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf0FF20FF Dust", caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set t = 5
    endif
    set t = timebonus(caster, t)
    
    set heal = 80 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    call UnitAddAbility( caster, 'A0R9' )
    call potionst( caster )
    
    if LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dust" ) ) == null then
        call SaveTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dust" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dust" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "dust" ), caster )
    call SaveReal( udg_hash, id, StringHash( "dust" ), heal )
    call SaveReal( udg_hash, id, StringHash( "dustt" ), t )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "dust" ) ), 1, true, function DustPotCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_DustPot_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_DustPot takes nothing returns nothing
    set gg_trg_DustPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DustPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DustPot, Condition( function Trig_DustPot_Conditions ) )
    call TriggerAddAction( gg_trg_DustPot, function Trig_DustPot_Actions )
endfunction

