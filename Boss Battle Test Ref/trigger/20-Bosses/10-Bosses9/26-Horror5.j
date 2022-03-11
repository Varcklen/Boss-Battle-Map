function Trig_Horror5_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e002' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function Horror5End takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "bshr5" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bshr5b" ) )
    
	if GetUnitAbilityLevel(u, 'B05B') > 0 then
		call dummyspawn( boss, 1, 0, 0, 0 )
        call DestroyEffect( AddSpecialEffect( "CallOfAggression.mdx", GetUnitX( u ), GetUnitY( u ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, u, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
	endif

    call UnitRemoveAbility( u, 'A092' )
    call UnitRemoveAbility( u, 'B05B' )
    call FlushChildHashtable( udg_hash, id )

    set u = null
    set boss = null
endfunction

function Trig_Horror5_Actions takes nothing returns nothing
    local unit u = GroupPickRandomUnit(udg_otryad)
    local integer id = GetHandleId( u )

    call DisableTrigger( GetTriggeringTrigger() )
    if u != null then
        call UnitAddAbility( u, 'A092')
        call PingMinimapLocForForceEx( bj_FORCE_ALL_PLAYERS, GetUnitLoc( u ), 2, bj_MINIMAPPINGSTYLE_ATTACK, 0, 0, 0 )
        if LoadTimerHandle( udg_hash, id, StringHash( "bshr5" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bshr5" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bshr5" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bshr5" ), u )
        call SaveUnitHandle( udg_hash, id, StringHash( "bshr5b" ), udg_DamageEventTarget )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "bshr5" ) ), bosscast(5), false, function Horror5End )
    endif
	set u = null
endfunction

//===========================================================================
function InitTrig_Horror5 takes nothing returns nothing
    set gg_trg_Horror5 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Horror5 )
    call TriggerRegisterVariableEvent( gg_trg_Horror5, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Horror5, Condition( function Trig_Horror5_Conditions ) )
    call TriggerAddAction( gg_trg_Horror5, function Trig_Horror5_Actions )
endfunction

