function Trig_Ogre_Magi2_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h00Q' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function Ogre_Magi2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsom" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call dummyspawn( boss, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX(boss), GetUnitY(boss), 600, null )
        loop
            set u = FirstOfGroup(g) 
            exitwhen u == null
            if unitst( u, boss, "all" )  then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                if not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT ) ) then
                    call UnitDamageTarget( bj_lastCreatedUnit, u, 0.25 * GetUnitState( u, UNIT_STATE_MAX_LIFE ), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                else
                    call UnitDamageTarget( bj_lastCreatedUnit, u, 0.01 * GetUnitState( u, UNIT_STATE_MAX_LIFE ), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set boss = null
endfunction

function Trig_Ogre_Magi2_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    
    call DisableTrigger( GetTriggeringTrigger() )
    if LoadTimerHandle( udg_hash, id, StringHash( "bsom" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsom" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsom" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsom" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsom" ) ), bosscast(1), true, function Ogre_Magi2Cast )
endfunction

//===========================================================================
function InitTrig_Ogre_Magi2 takes nothing returns nothing
    set gg_trg_Ogre_Magi2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Ogre_Magi2 )
    call TriggerRegisterVariableEvent( gg_trg_Ogre_Magi2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ogre_Magi2, Condition( function Trig_Ogre_Magi2_Conditions ) )
    call TriggerAddAction( gg_trg_Ogre_Magi2, function Trig_Ogre_Magi2_Actions )
endfunction

