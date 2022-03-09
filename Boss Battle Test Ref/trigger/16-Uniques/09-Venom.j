function Trig_Venom_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and GetUnitTypeId(udg_DamageEventSource) != 'u000' and (GetUnitAbilityLevel( udg_DamageEventSource, 'A0FS') > 0 or GetUnitAbilityLevel( udg_DamageEventSource, 'A0J5') > 0 )
endfunction

function VenomCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "vnm" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "vnm" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "vnmc" ) )
    
    if GetUnitAbilityLevel( target, 'A0K8') > 0 then
        set dmg = dmg + (dmg * LoadReal( udg_hash, GetHandleId( target ), StringHash( "eleqv" ) ) )
    endif
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, 'A0FU') > 0 then
        if GetUnitAbilityLevel(target, 'B07R') > 0 and Aspects_IsHeroAspectActive( caster, ASPECT_03 ) == false then
            call healst(caster, target, dmg)
        else
            call UnitTakeDamage( caster, target, dmg, DAMAGE_TYPE_MAGIC )
        endif
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_Venom_Actions takes nothing returns nothing
    local integer id 
    local unit target
    local unit caster
    local real t
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    else
        set caster = udg_DamageEventSource
        set target = udg_DamageEventTarget
    endif
    set t = timebonus( caster, 5 )
    set id = GetHandleId( target )

    set dmg = udg_DamageEventAmount*0.15*GetUnitSpellPower(caster) //делим на время (5 сек), по этому 0.1 а не 0.75
    if IsUniqueUpgraded(caster) then
        set dmg = dmg * 2
    endif
    set dmg = dmg * udg_SpellDamageSpec[GetPlayerId(GetOwningPlayer(caster)) + 1]

    if GetUnitAbilityLevel( target, 'A0FU') == 0 then 
        if LoadTimerHandle( udg_hash, id, StringHash( "vnm" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "vnm" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vnm" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "vnm" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "vnmc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "vnm" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "vnm" ) ), 1, true, function VenomCast )
    endif

    call bufst( caster, target, 'A0FU', 'B07P', "vnm1", t ) 
    
    call debuffst( caster, target, null, 1, t )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Venom takes nothing returns nothing
    set gg_trg_Venom = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Venom, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Venom, Condition( function Trig_Venom_Conditions ) )
    call TriggerAddAction( gg_trg_Venom, function Trig_Venom_Actions )
endfunction