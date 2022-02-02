function Trig_ShowerPot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0QS'
endfunction

function ShowerPotCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "shwt" ) )
    local real mana = LoadReal( udg_hash, id, StringHash( "shw" ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shw" ) )

    if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call manast( u, null, mana )
    endif
    
    if counter > 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel(u, 'B02K') > 0 then
        call SaveReal( udg_hash, id, StringHash( "shwt" ), counter - 1 )
    else
        call UnitRemoveAbility( u, 'A0GN' )
        call UnitRemoveAbility( u, 'B02K' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    set u = null
endfunction

function Trig_ShowerPot_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf020FFFF Shower", caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set t = 5
    endif
    set t = timebonus(caster, t)
    
    set heal = 50 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    call UnitAddAbility( caster, 'A0GN' )
    call potionst( caster )
    
    if LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shw" ) ) == null then
        call SaveTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shw" ), caster )
    call SaveReal( udg_hash, id, StringHash( "shw" ), heal )
    call SaveReal( udg_hash, id, StringHash( "shwt" ), t )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shw" ) ), 1, true, function ShowerPotCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_ShowerPot_Actions", 1, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShowerPot takes nothing returns nothing
    set gg_trg_ShowerPot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShowerPot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShowerPot, Condition( function Trig_ShowerPot_Conditions ) )
    call TriggerAddAction( gg_trg_ShowerPot, function Trig_ShowerPot_Actions )
endfunction

