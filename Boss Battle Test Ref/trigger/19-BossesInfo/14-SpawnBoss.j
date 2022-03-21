function Trig_SpawnBoss_Conditions takes nothing returns boolean
    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_ANCIENT) and GetUnitTypeId(GetEnteringUnit()) != 'n059' and GetUnitTypeId(GetEnteringUnit()) != 'n01Z' and GetUnitTypeId(GetEnteringUnit()) != 'h005' and GetUnitTypeId(GetEnteringUnit()) != 'h013' and GetUnitTypeId(GetEnteringUnit()) != 'h01H' and GetUnitTypeId(GetEnteringUnit()) != 'h00C' and GetUnitTypeId(GetEnteringUnit()) != 'h009'
endfunction

function OgreAwake takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsog" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] and GetUnitTypeId( boss ) == 'h001' then
        set udg_DamageEventTarget = boss
        call TriggerExecute( gg_trg_Ogre1 )
    endif
    
    call FlushChildHashtable( udg_hash, id )
    set boss = null
endfunction

function WyrmAwake takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswrs" ) )

    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and udg_fightmod[0] then
        set udg_DamageEventTarget = boss 
        call TriggerExecute( gg_trg_Wyrm1 )
    endif
    call FlushChildHashtable( udg_hash, id )
    set boss = null
endfunction

function StartFightCall takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer s = LoadInteger( udg_hash, id, StringHash( "bcalls" ) )
    local integer n = LoadInteger( udg_hash, id, StringHash( "bcalln" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bcall" ) )
    
    if GetUnitState( boss, UNIT_STATE_LIFE) > 0.405 and not(IsUnitHiddenBJ(boss)) then
        call TransmissionFromUnitWithNameBJ( bj_FORCE_ALL_PLAYERS, boss, null, Boss_Talk[n][s], null, bj_TIMETYPE_SET, 1, false )
    endif
    call FlushChildHashtable( udg_hash, id )
    set boss = null
endfunction

function ModBad1 takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "modb1" ) )
    local unit target = GroupPickRandomUnit(udg_otryad)

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not(udg_fightmod[0]) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif target != null and not(IsUnitHiddenBJ(boss)) then
        call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(boss), GetUnitY(boss) ) )
        call SetUnitPosition( boss, GetUnitX(target)+GetRandomReal(-200,200), GetUnitY(target)+GetRandomReal(-200,200) )
        if not( RectContainsUnit( udg_Boss_Rect, boss) ) then
            call SetUnitPositionLoc( boss, GetRectCenter( udg_Boss_Rect ) )
        endif
        call DestroyEffect( AddSpecialEffectTarget("Void Teleport Caster.mdx", boss, "origin" ) )
        call taunt( target, boss, 4 )
    endif

    set boss = null
endfunction

function Trig_SpawnBoss_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclB
    local integer id 
    local boolean l = false
    local integer s = 1
    local integer n = 1
    local integer k = 1
    local integer h
    local integer i
    local integer rand
    
    local unit u = GetEnteringUnit()
    
    if GetUnitTypeId(u) == 'n009' and udg_HardNum > 5 then
        call BlzSetUnitName( u, "Rapist" )
    endif
    
    if udg_Boss_LvL > 1 or udg_Endgame > 1 then
        call BlzSetUnitAttackCooldown(u,BlzGetUnitAttackCooldown(u,0) / HardModAspd[udg_HardNum],0)
    endif
    
	if udg_Endgame > 1 then
        call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_Endgame - GetUnitAvgDiceDamage(u)), 0 )
        call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u) * udg_Endgame) )
	endif

	if GetOwningPlayer(u) == Player(10) and udg_BossHP != 1 then
        call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_BossAT - GetUnitAvgDiceDamage(u)), 0 )
        call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u) * udg_BossHP)+1 )
        call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE ) )
	endif
    
    if not( RectContainsUnit( udg_Boss_Rect, u) ) then
        call SetUnitPositionLoc( u, GetRectCenter( udg_Boss_Rect ) )
    endif

	if GetUnitTypeId(u) != 'h002' and GetUnitTypeId(u) != 'o006' and GetUnitTypeId(u) != 'n00F' then
		call SetUnitLifeBJ( u, GetUnitStateSwap(UNIT_STATE_MAX_LIFE, u) )
	endif
    
    if udg_modbad[21] then
        call UnitAddAbility( u, 'A0SV' )
    endif
    
    if udg_modbad[1] and GetOwningPlayer(u) == Player(10) and GetUnitDefaultMoveSpeed(u) != 0 then
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, StringHash( "modb1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "modb1" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "modb1" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "modb1" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "modb1" ) ), 20, false, function ModBad1 )
    endif

    if udg_modbad[19] and BlzGetUnitBaseDamage(u, 0) > 5 and GetUnitDefaultMoveSpeed(u) != 0 and GetUnitTypeId(u) != 'h00Z' then
        call UnitAddAbility( u, 'A0NC' )
    endif

    call RemoveGuardPosition(u)
    if ( CountLivingPlayerUnitsOfTypeId('o006', GetOwningPlayer(u)) == 0 and GetUnitTypeId(u) == 'n00F' ) or GetUnitTypeId(u) != 'n00F' then
        set cyclA = 1
        set i = DB_Boss_id[1][1]
        set s = 1
        set n = 1
        set k = 1
        loop
            exitwhen cyclA > 1
            if i == GetUnitTypeId( u ) then
                set cyclB = 1
                set l = false
                loop
                    exitwhen l
                    set h = cyclB + ( ( s - 1 ) * 10 )
                    if DB_Trigger_Boss[n][h] != null and cyclB <= 9 then
                        call EnableTrigger( DB_Trigger_Boss[n][h] )
                        call SetUnitUserData(u,5)
                        set cyclB = cyclB + 1
                    else
                        set l = true
                    endif
                endloop
            elseif k < 500 then
                set cyclA = cyclA - 1 
                set s = s + 1
                set i = DB_Boss_id[n][s]
                if i == 0 then
                    set s = 1
                    set n = n + 1
                    set i = DB_Boss_id[n][s]
                endif
            endif
            set k = k + 1
            set cyclA = cyclA + 1
        endloop
    else
        call GroupAddUnit( udg_Bosses, u )
        return
    endif
    
    if udg_modbad[10] then
        call UnitAddAbility( u, 'A10Y' )
    endif

    if udg_fightmod[4] and GetUnitTypeId(u) != 'e000' then
        call dummyspawn( u, 1, 0, 0, 0 ) 
        call UnitDamageTarget( bj_lastCreatedUnit, u, 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    
    if Boss_Talk[n][s] != null then
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, StringHash( "bcall" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bcall" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bcall" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bcall" ), u )
        call SaveInteger( udg_hash, id, StringHash( "bcalls" ), s )
        call SaveInteger( udg_hash, id, StringHash( "bcalln" ), n )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bcall" ) ), 7, false, function StartFightCall )
    endif
    
    if GetUnitTypeId(u) == 'h001' then 
    	call SetUnitAnimation( u, "sleep" )
        set id = GetHandleId( u )
        if LoadTimerHandle( udg_hash, id, StringHash( "bsog" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bsog" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsog" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsog" ), u )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bsog" ) ), 40, false, function OgreAwake )
    endif
    if GetUnitTypeId(u) == 'n00A' then 
        call ShowUnitHide( gg_unit_h00A_0034 )
    endif

    if GetOwningPlayer(u) == Player(10) then
        call GroupAddUnit( udg_Bosses, u )
        set id = GetHandleId( u )
        if GetUnitTypeId(u) == 'o00M' then
            if LoadTimerHandle( udg_hash, id, StringHash( "bswrs" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bswrs" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrs" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bswrs" ), u )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bswrs" ) ), 10, false, function WyrmAwake )
        endif
    endif
    set u = null
endfunction

//===========================================================================
function InitTrig_SpawnBoss takes nothing returns nothing
    set gg_trg_SpawnBoss = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_SpawnBoss, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_SpawnBoss, Condition( function Trig_SpawnBoss_Conditions ) )
    call TriggerAddAction( gg_trg_SpawnBoss, function Trig_SpawnBoss_Actions )
endfunction

