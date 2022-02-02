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

	if udg_Endgame > 1 then
        call BlzSetUnitBaseDamage( GetEnteringUnit(), R2I(BlzGetUnitBaseDamage(GetEnteringUnit(), 0) * udg_Endgame), 0 )
        call BlzSetUnitMaxHP( GetEnteringUnit(), R2I(BlzGetUnitMaxHP(GetEnteringUnit()) * udg_Endgame) )
	endif

	if GetOwningPlayer(GetEnteringUnit()) == Player(10) and udg_BossHP != 1 then
        call BlzSetUnitBaseDamage( GetEnteringUnit(), R2I(BlzGetUnitBaseDamage(GetEnteringUnit(), 0) * udg_BossAT), 0 )
        call BlzSetUnitMaxHP( GetEnteringUnit(), R2I(BlzGetUnitMaxHP(GetEnteringUnit()) * udg_BossHP)+1 )
	endif
    
    if not( RectContainsUnit( udg_Boss_Rect, GetEnteringUnit()) ) then
        call SetUnitPositionLoc( GetEnteringUnit(), GetRectCenter( udg_Boss_Rect ) )
    endif

	if GetUnitTypeId(GetEnteringUnit()) != 'h002' and GetUnitTypeId(GetEnteringUnit()) != 'o006' and GetUnitTypeId(GetEnteringUnit()) != 'n00F' then
		call SetUnitLifeBJ( GetEnteringUnit(), GetUnitStateSwap(UNIT_STATE_MAX_LIFE, GetEnteringUnit()) )
	endif
    
    if udg_modbad[21] then
        call UnitAddAbility( GetEnteringUnit(), 'A0SV' )
    endif
    
    if udg_modbad[1] and GetOwningPlayer(GetEnteringUnit()) == Player(10) and GetUnitDefaultMoveSpeed(GetEnteringUnit()) != 0 then
        set id = GetHandleId( GetEnteringUnit() )
        if LoadTimerHandle( udg_hash, id, StringHash( "modb1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "modb1" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "modb1" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "modb1" ), GetEnteringUnit() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "modb1" ) ), 20, false, function ModBad1 )
    endif

    if udg_modbad[19] and BlzGetUnitBaseDamage(GetEnteringUnit(), 0) > 5 and GetUnitDefaultMoveSpeed(GetEnteringUnit()) != 0 and GetUnitTypeId(GetEnteringUnit()) != 'h00Z' then
        call UnitAddAbility( GetEnteringUnit(), 'A0NC' )
    endif

    call RemoveGuardPosition(GetEnteringUnit())
    if ( CountLivingPlayerUnitsOfTypeId('o006', GetOwningPlayer(GetEnteringUnit())) == 0 and GetUnitTypeId(GetEnteringUnit()) == 'n00F' ) or GetUnitTypeId(GetEnteringUnit()) != 'n00F' then
        set cyclA = 1
        set i = DB_Boss_id[1][1]
        set s = 1
        set n = 1
        set k = 1
        loop
            exitwhen cyclA > 1
            if i == GetUnitTypeId( GetEnteringUnit() ) then
                set cyclB = 1
                set l = false
                loop
                    exitwhen l
                    set h = cyclB + ( ( s - 1 ) * 10 )
                    if DB_Trigger_Boss[n][h] != null and cyclB <= 9 then
                        call EnableTrigger( DB_Trigger_Boss[n][h] )
                        call SetUnitUserData(GetEnteringUnit(),5)
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
        call GroupAddUnit( udg_Bosses, GetEnteringUnit() )
        return
    endif
    
    if udg_modbad[10] then
        call UnitAddAbility( GetEnteringUnit(), 'A10Y' )
    endif

    if udg_fightmod[4] and GetUnitTypeId(GetEnteringUnit()) != 'e000' then
        call dummyspawn( GetEnteringUnit(), 1, 0, 0, 0 ) 
        call UnitDamageTarget( bj_lastCreatedUnit, GetEnteringUnit(), 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    
    if Boss_Talk[n][s] != null then
        set id = GetHandleId( GetEnteringUnit() )
        if LoadTimerHandle( udg_hash, id, StringHash( "bcall" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bcall" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bcall" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bcall" ), GetEnteringUnit() )
        call SaveInteger( udg_hash, id, StringHash( "bcalls" ), s )
        call SaveInteger( udg_hash, id, StringHash( "bcalln" ), n )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bcall" ) ), 7, false, function StartFightCall )
    endif
    
    if GetUnitTypeId(GetEnteringUnit()) == 'h001' then 
    	call SetUnitAnimation( GetEnteringUnit(), "sleep" )
        set id = GetHandleId( GetEnteringUnit() )
        if LoadTimerHandle( udg_hash, id, StringHash( "bsog" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bsog" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsog" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsog" ), GetEnteringUnit() )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bsog" ) ), 40, false, function OgreAwake )
    endif
    if GetUnitTypeId(GetEnteringUnit()) == 'n00A' then 
        call ShowUnitHide( gg_unit_h00A_0034 )
    endif

    if GetOwningPlayer(GetEnteringUnit()) == Player(10) then
        call GroupAddUnit( udg_Bosses, GetEnteringUnit() )
        set id = GetHandleId( GetEnteringUnit() )
        if GetUnitTypeId(GetEnteringUnit()) == 'o00M' then
            if LoadTimerHandle( udg_hash, id, StringHash( "bswrs" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "bswrs" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bswrs" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "bswrs" ), GetEnteringUnit() )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bswrs" ) ), 10, false, function WyrmAwake )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_SpawnBoss takes nothing returns nothing
    set gg_trg_SpawnBoss = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_SpawnBoss, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_SpawnBoss, Condition( function Trig_SpawnBoss_Conditions ) )
    call TriggerAddAction( gg_trg_SpawnBoss, function Trig_SpawnBoss_Actions )
endfunction

