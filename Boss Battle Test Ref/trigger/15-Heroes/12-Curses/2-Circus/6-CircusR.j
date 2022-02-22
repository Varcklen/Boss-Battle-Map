function Trig_CircusR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0SJ' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function CircusRData takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "cirr" ) )
    
    call luckyst( u, -LoadInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ) )
    call UnitRemoveAbility( u, 'A0SL' )
    call UnitRemoveAbility( u, 'B03J' )
    
    call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ) )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction

function Trig_CircusR_Actions takes nothing returns nothing
    local integer id
    local integer lvl
    local integer i
    local integer isum
    local integer n
    local integer cyclA = 1
    local integer k
    local unit caster
    local unit target
    local unit u
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0SJ'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)

    set i = ( 5 * lvl ) + 5
    set n = 1
    
	set k = 4
    loop
        exitwhen cyclA > k
            set u = udg_hero[cyclA]
        if GetUnitState(u, UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(u, GetOwningPlayer(caster)) and not( udg_fightmod[3] ) and IsUnitType( u, UNIT_TYPE_HERO) then
            set id = GetHandleId( u )
            call luckyst( u, i )
            set isum = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ) + i
            call DestroyEffect( AddSpecialEffectTarget("Life Magic.mdx", u, "chest" ) )
            if luckylogic( caster, 2 * lvl, 1, 100 ) then
                call luckyst( u, n )
                set udg_Data[GetPlayerId(GetOwningPlayer(u)) + 1 + 96] = udg_Data[GetPlayerId(GetOwningPlayer(u)) + 1 + 96] + n
                call textst( "|c00FFFF00 +" + I2S( n ) + " to luck", u, 64, 90, 10, 1.5 )
            endif
            
            call UnitAddAbility( u, 'A0SL' )  
            
            if LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ) == null  then
                call SaveTimerHandle( udg_hash, GetHandleId( u ), StringHash( "cirr" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "cirr" ), u )
            call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "cirr" ), isum )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "cirr" ) ), t, false, function CircusRData ) 
            
            if BuffLogic() then
                call effst( caster, u, null, lvl, t )
            endif
        endif
        set cyclA = cyclA + 1
    endloop

    set caster = null
    set target = null
    set u = null
endfunction

//===========================================================================
function InitTrig_CircusR takes nothing returns nothing
    set gg_trg_CircusR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CircusR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_CircusR, Condition( function Trig_CircusR_Conditions ) )
    call TriggerAddAction( gg_trg_CircusR, function Trig_CircusR_Actions )
endfunction

