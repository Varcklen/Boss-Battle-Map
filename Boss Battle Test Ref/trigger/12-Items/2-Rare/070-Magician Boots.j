function Trig_Magician_Boots_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A18A' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function Magician_BootsCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mgbtc" ) )
    local unit t = LoadUnitHandle( udg_hash, id, StringHash( "mgbtt" ) )
    local real xc = LoadReal( udg_hash, id, StringHash( "mgbtcx" ) )
    local real yc = LoadReal( udg_hash, id, StringHash( "mgbtcy" ) )
    local real xt = LoadReal( udg_hash, id, StringHash( "mgbttx" ) )
    local real yt = LoadReal( udg_hash, id, StringHash( "mgbtty" ) )
    
    call SetUnitPosition( u, xt, yt )
    call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", u, "origin" ) )
    call PanCameraToTimedForPlayer( GetOwningPlayer( u ), xt, yt, 0.25 )
    call SetUnitPosition( t, xc, yc )
    call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", t, "origin" ) )
    call PanCameraToTimedForPlayer( GetOwningPlayer( t ), xc, yc, 0.25 )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Magician_Boots_Actions takes nothing returns nothing
    local integer id
    local unit caster
    local real x
    local real y
    local integer cyclA
    local group g = CreateGroup()
    local unit n

    if CastLogic() then
        set caster = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A18A'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(caster)) and udg_hero[cyclA] != caster then 
            call GroupAddUnit(g, udg_hero[cyclA])
        endif
        set cyclA = cyclA + 1
    endloop
    
    if not(IsUnitGroupEmptyBJ(g)) then
        set n = GroupPickRandomUnit(g)

        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "mgbt" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "mgbt" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mgbt" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mgbtc" ), caster )
        call SaveUnitHandle( udg_hash, id, StringHash( "mgbtt" ), n )
        call SaveReal( udg_hash, id, StringHash( "mgbtcx" ), GetUnitX(caster) )
        call SaveReal( udg_hash, id, StringHash( "mgbtcy" ), GetUnitY(caster) )
        call SaveReal( udg_hash, id, StringHash( "mgbttx" ), GetUnitX(n) )
        call SaveReal( udg_hash, id, StringHash( "mgbtty" ), GetUnitY(n) )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mgbt" ) ), 0.01, false, function Magician_BootsCast )
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set n = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Magician_Boots takes nothing returns nothing
    set gg_trg_Magician_Boots = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magician_Boots, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Magician_Boots, Condition( function Trig_Magician_Boots_Conditions ) )
    call TriggerAddAction( gg_trg_Magician_Boots, function Trig_Magician_Boots_Actions )
endfunction

