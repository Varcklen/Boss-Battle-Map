function Trig_Salamander1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'n041'
endfunction

function Salamander1_Movement takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss =  LoadUnitHandle( udg_hash, id, StringHash( "cerf" ) )
    local real SalamanderAccelerationx = 0.3
    local real SalamanderAccelerationy = 0.3
    local real SalamanderSpeedx = udg_SalamanderSpeed[0] //скорость саламандры глобальная переменная массив integer
    local real SalamanderSpeedy = udg_SalamanderSpeed[1]
    local real BossPosx = 0.00
    local real HeroPosx = 0.00
    local real BossPosy = 0.00
    local real HeroPosy = 0.00
    local integer Hero1 = 0
    local integer Time2 = udg_counter[0]//счетчик глобальная переменная массив integer
    local integer Time3 = udg_counter[1]
    local integer Time4 = udg_counter[2]
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set Time2 = udg_counter[0] + 1
        if GetUnitAbilityLevel( boss, 'BEer' ) > 0 or GetUnitAbilityLevel( boss, 'BPSE' ) > 0 or GetUnitAbilityLevel( boss, 'B043' ) > 0 or IsUnitPaused(boss) then//внести сюда все станящие абилки, так же при стане не кдшатся скилы боса
            set Time2 = 1
        else
            //set Hero = 1
            //loop 
            //exitwhen GetUnitState(udg_hero[Hero], UNIT_STATE_LIFE) > 0.405
            //    set Hero = Hero + 1
            //endloop
            set SalamanderSpeedx = udg_SalamanderSpeed[0] + SalamanderAccelerationx * CosBJ (GetUnitFacing (boss))
            set SalamanderSpeedy = udg_SalamanderSpeed[1] + SalamanderAccelerationy * SinBJ (GetUnitFacing (boss))
            if SalamanderSpeedy > 12 then
                set SalamanderSpeedy = 10 //максимальная скорость
            endif
            if SalamanderSpeedy < -12 then
                set SalamanderSpeedy = -10
            endif
            if SalamanderSpeedx > 12 then
                set SalamanderSpeedx = 10
            endif
            if SalamanderSpeedx < -12 then
                set SalamanderSpeedx = -10
            endif
            set BossPosx = GetUnitX(boss) + SalamanderSpeedx
            set BossPosy = GetUnitY(boss) + SalamanderSpeedy
            if IsTerrainPathable(BossPosx,BossPosy, PATHING_TYPE_WALKABILITY) == FALSE then //проверка проходимости
                call SetUnitX (boss,BossPosx)
                call SetUnitY (boss,BossPosy)
            else
                set SalamanderSpeedx = 0//сброс скорости если непроходимо
                set SalamanderSpeedy = 0
            endif
            if RAbsBJ (SalamanderSpeedx) + RAbsBJ (SalamanderSpeedy)< 2 and Time2 > 200 then// оглушение боса при замедлении раз в 6 секунд(200*0.03)абилка новое переделана работа на самого боса
                call dummyspawn( boss, 1, 'A0JW', 0, 0 )
                call IssueTargetOrder( bj_lastCreatedUnit, "thunderbolt", boss )
                set SalamanderSpeedx = 0
                set SalamanderSpeedy = 0
                set Time2 = 0
            endif
            if GetUnitLifePercent(boss) <= 75 then
                set Time3 = udg_counter[1] + 1
                set Hero1 = 1
                loop
                    if RAbsBJ(BossPosx - GetUnitX(udg_hero[Hero1]))+ RAbsBJ(BossPosy - GetUnitY(udg_hero[Hero1]))<250 and Time3 > 300 then
                        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 300, null )
                        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", BossPosx, BossPosy ) )
                        loop
                            set u = FirstOfGroup(g)
                        exitwhen u == null
                            if unitst( u, boss, "enemy" ) then
                                call dummyspawn( boss, 1, 0, 0, 0 )
                                call UnitStun(boss, u, 3 )
                                call UnitDamageTarget( boss, u, 125, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)//оглушение героев если они близко раз в 9 секунд абилка взята от медведя
                            endif
                            call GroupRemoveUnit(g,u)
                            set u = FirstOfGroup(g)
                        endloop
                        set Time3 = 0
                    endif
                exitwhen Hero1>4
                    set Hero1 = Hero1 + 1
                endloop
            endif
            if GetUnitLifePercent(boss) <= 50 then
                set Time4 = udg_counter[2] + 1
                if RAbsBJ (BossPosx-udg_BossPos[0])+ RAbsBJ (BossPosy-udg_BossPos[1])>320 and Time4 < 450 then//поджог земли при перемещении в течении 14 секунд потом 14 секунд отдыха абилка стандартная
                    set udg_BossPos[0]=BossPosx
                    set udg_BossPos[1]=BossPosy 
                    call dummyspawn( boss, 1, 'A0JT',0, 0)
                    call IssuePointOrder( bj_lastCreatedUnit, "flamestrike", GetUnitX( boss ), GetUnitY( boss ) )
                endif
                if Time4 > 900 then
                    set Time4 = 0
                endif
            endif
            set udg_SalamanderSpeed[0] = SalamanderSpeedx
            set udg_SalamanderSpeed[1] = SalamanderSpeedy
            set udg_counter[0] = Time2
            set udg_counter[1] = Time3
            set udg_counter[2] = Time4
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Salamander1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "cerf" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "cerf" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "cerf" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "cerf" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "cerf" ) ), 0.03, true, function Salamander1_Movement )
endfunction

//===========================================================================
function InitTrig_Salamander1 takes nothing returns nothing
    set gg_trg_Salamander1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Salamander1 )
    call TriggerRegisterVariableEvent( gg_trg_Salamander1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Salamander1, Condition( function Trig_Salamander1_Conditions ) )
    call TriggerAddAction( gg_trg_Salamander1, function Trig_Salamander1_Actions )
endfunction

