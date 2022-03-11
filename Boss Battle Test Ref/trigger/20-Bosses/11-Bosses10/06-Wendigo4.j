function Trig_Wendigo4_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n03I' and GetUnitLifePercent(udg_DamageEventTarget) <= 25 and not(udg_logic[1])
endfunction

function WendAngelEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswda1" ) )
    local integer i = GetRandomInt( 1, 3 )

    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set udg_RandomLogic = true
        set udg_Caster = u
        set udg_Level = GetRandomInt( 1, 5 )
        if i == 1 then
            call TriggerExecute( gg_trg_AngelQ )
        elseif i == 2 then
            call TriggerExecute( gg_trg_AngelW )
        else
            call TriggerExecute( gg_trg_AngelR )
        endif
        call IssueTargetOrder( u, "attack", GroupPickRandomUnit(udg_Bosses) )
    endif
    
    set u = null
endfunction

function WendAngel takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bswda" ) )
    local integer id1 = GetHandleId( u )
    local integer cyclA = 1

    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null then
	    call GroupRemoveUnit( udg_DeadHero, udg_hero[cyclA])
            call ReviveHero( udg_hero[cyclA], GetRectCenterX( udg_Boss_Rect ) - 528 + ( (cyclA - 1) * 385 ), GetRectCenterY( udg_Boss_Rect ) - 1150, true )
            call SetUnitPosition( udg_hero[cyclA], GetRectCenterX( udg_Boss_Rect ) - 528 + ( (cyclA - 1) * 385 ), GetRectCenterY( udg_Boss_Rect ) - 1150 )
            call SetUnitFacing( udg_hero[cyclA], 90 )
            call SetUnitState( udg_hero[cyclA], UNIT_STATE_MANA, GetUnitState(udg_hero[cyclA], UNIT_STATE_MAX_MANA))
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
        endif
        set cyclA = cyclA + 1
    endloop
    set udg_Heroes_Deaths = 0
    
    call PauseUnit( u, false )
    call SetUnitAnimation( u, "stop" )
    call IssueTargetOrder( u, "attack", GroupPickRandomUnit(udg_Bosses) )
    call DestroyEffect( LoadEffectHandle( udg_hash, id, StringHash( "bswdae" ) ) )
    call EnableTrigger( gg_trg_Debug )
    
    if LoadTimerHandle( udg_hash, id1, StringHash( "bswda1" ) ) == null  then
        call SaveTimerHandle( udg_hash, id1, StringHash( "bswda1" ), CreateTimer() )
    endif
	set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswda1" ) ) )
    call SaveUnitHandle( udg_hash, id1, StringHash( "bswda1" ), u )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bswda1" ) ), 15, true, function WendAngelEnd )
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
endfunction

function Wend4Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer id1
    local integer cyclA = 1
    local unit u
    local effect ef

	call StopMusic(false)
	call ClearMapMusic()
	call PlayMusicBJ( gg_snd_Doom01 )
    call MultiboardMinimize( udg_multi, true )
    
    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != null then
            call PanCameraToTimedForPlayer( Player( cyclA - 1 ), GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) - 1000, 1 )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set ef = AddSpecialEffect( "Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl", GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) - 1000 )
    
    set u = CreateUnit( Player( 4 ), 'N01M', GetRectCenterX( udg_Boss_Rect ), GetRectCenterY( udg_Boss_Rect ) - 1000, 270 )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, u, GetUnitName(u), null, "Heroes do not lose! Stand up and fight again!", bj_TIMETYPE_SET, 7, false )
    call SetHeroLevel( u, 10, false )
    call PauseUnit( u, true )
    call SetUnitAnimation( u, "attack spell" )
    call QueueUnitAnimationBJ( u, "stand" )
    set id1 = GetHandleId( u )
    
    call SaveTimerHandle( udg_hash, id1, StringHash( "bswda" ), CreateTimer() )
    set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "bswda" ) ) ) 
    call SaveUnitHandle( udg_hash, id1, StringHash( "bswda" ), u )
    call SaveEffectHandle( udg_hash, id1, StringHash( "bswdae" ), ef )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bswda" ) ), 2.33, false, function WendAngel )
    
    call FlushChildHashtable( udg_hash, id )
    set u = null
    set ef = null
endfunction

function Trig_Wendigo4_Actions takes nothing returns nothing
    local unit v = udg_DamageEventTarget
    local integer id
    local integer cyclA
    local group g = CreateGroup()
    local unit u
    
    call DisableTrigger( GetTriggeringTrigger() )
    call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, v, GetUnitName(v), null, "DIE!", bj_TIMETYPE_SET, 3, false )
	call StopMusic(false)
	call ClearMapMusic()
	call PlayMusicBJ( gg_snd_DarkAgents01 )
    call MultiboardMinimize( udg_multi, false )
    
    set id = GetHandleId( v )
    if LoadTimerHandle( udg_hash, id, StringHash( "bswd4" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bswd4" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswd4" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "bswd4" ), v )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( v ), StringHash( "bswd4" ) ), 3, false, function Wend4Cast )
    
    call DisableTrigger( gg_trg_Debug )
    call DisableTrigger( gg_trg_HeroDeath )
    call DisableTrigger( gg_trg_BattleRessurect )
    call DisableTrigger( gg_trg_PhoenixEgg )
    call DisableTrigger( gg_trg_Sphere_Abyss )
    call DisableTrigger( gg_trg_DoctorRUse )
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set bj_livingPlayerUnitsTypeId = 'n01Z'
            call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), filterLivingPlayerUnitsOfTypeId)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call KillUnit( u )
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
            call GroupEnumUnitsOfPlayer(g, Player(cyclA - 1), null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if not( IsUnitType( u, UNIT_TYPE_HERO) ) and RectContainsCoords(udg_Boss_Rect, GetUnitX(u), GetUnitY(u)) then
                    call RemoveUnit( u )
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
            call spectime("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ), 2 )
            call KillUnit( udg_hero[cyclA] )
        endif
        set cyclA = cyclA + 1
    endloop
    set udg_Heroes_Deaths = 0
    call EnableTrigger( gg_trg_BattleRessurect )
    call EnableTrigger( gg_trg_PhoenixEgg )
    call EnableTrigger( gg_trg_Sphere_Abyss )
    call EnableTrigger( gg_trg_HeroDeath )
    call EnableTrigger( gg_trg_DoctorRUse )

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set v = null
endfunction

//===========================================================================
function InitTrig_Wendigo4 takes nothing returns nothing
    set gg_trg_Wendigo4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Wendigo4 )
    call TriggerRegisterVariableEvent( gg_trg_Wendigo4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wendigo4, Condition( function Trig_Wendigo4_Conditions ) )
    call TriggerAddAction( gg_trg_Wendigo4, function Trig_Wendigo4_Actions )
endfunction

