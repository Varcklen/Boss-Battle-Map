function Trig_Wendigo3_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03I' and GetUnitLifePercent(udg_DamageEventTarget) <= 50 and not(udg_logic[1])
endfunction

function Trig_Wendigo3_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local integer cyclB
    local real x
    local real y
    local group g = CreateGroup()
    local unit u

    call DisableTrigger( GetTriggeringTrigger() )
    
    call StartSound(gg_snd_ItemReceived)
    call SetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE, GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) )
    call SetUnitPosition( udg_DamageEventTarget, GetRectCenterX(gg_rct_BossSpawn), GetRectCenterY(gg_rct_BossSpawn) )
    call SetUnitFacing( udg_DamageEventTarget, 270 )
    call aggro( udg_DamageEventTarget )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, udg_DamageEventTarget, GetUnitName(udg_DamageEventTarget), null, "CANCEL!", bj_TIMETYPE_SET, 3, false )
    set bj_livingPlayerUnitsTypeId = 'h012'
    call GroupEnumUnitsOfPlayer(g, Player( PLAYER_NEUTRAL_AGGRESSIVE ), filterLivingPlayerUnitsOfTypeId)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        call RemoveUnit( u )
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    loop
        exitwhen cyclA > 4
        set bj_livingPlayerUnitsTypeId = 'h01M'
        call GroupEnumUnitsOfPlayer(g, Player( cyclA - 1 ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call RemoveUnit( u )
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if not( IsUnitLoaded( udg_hero[cyclA] ) ) and GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call SetUnitPosition( udg_hero[cyclA], GetRectCenterX( udg_Boss_Rect ) - 528 + ( (cyclA - 1) * 385 ), GetRectCenterY( udg_Boss_Rect ) - 1150 )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState(udg_hero[cyclA], UNIT_STATE_MAX_MANA))
            call PanCameraToTimedForPlayer( Player( cyclA - 1 ), GetRectCenterX( udg_Boss_Rect ) - 528 + ( (cyclA - 1) * 385 ), GetRectCenterY( udg_Boss_Rect ) - 1150, 0 )
            call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) )
            call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) )
            set cyclB = 1
            loop
                exitwhen cyclB > 4
                set x = GetUnitX( udg_hero[cyclA] ) + 300 * Cos( ( 45 + ( 90 * cyclB ) ) * 0.0174 )
                set y = GetUnitY( udg_hero[cyclA] ) + 300 * Sin( ( 45 + ( 90 * cyclB ) ) * 0.0174 )
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'h01H', x, y, GetRandomReal( 0, 360 ) )
                call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
                call SetUnitTimeScale( bj_lastCreatedUnit, 3 )
                
                set id = GetHandleId( bj_lastCreatedUnit )
                
                call SaveTimerHandle( udg_hash, id, StringHash( "bswd2" ), CreateTimer() )
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd2" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "bswd2" ), bj_lastCreatedUnit )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bswd2" ) ), bosscast(3), true, function Wend2End ) 
                set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
    
    set udg_Heroes_Deaths = 0
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Wendigo3 takes nothing returns nothing
    set gg_trg_Wendigo3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wendigo3 )
    call TriggerRegisterVariableEvent( gg_trg_Wendigo3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wendigo3, Condition( function Trig_Wendigo3_Conditions ) )
    call TriggerAddAction( gg_trg_Wendigo3, function Trig_Wendigo3_Actions )
endfunction

