function Trig_Manadragon2_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e004' and GetUnitLifePercent(udg_DamageEventTarget) <= 50
endfunction

function ManaDr2Cast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "bsmd1" ) )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmd1b" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 128, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA ) + ( 20 * udg_SpellDamage[0] ) )
                call UnitDamageTarget( dummy, u, 30, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call spectimeunit( u, "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCaster.mdl", "origin", 1 )
            endif 
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set boss = null
endfunction

function Trig_Manadragon2_Actions takes nothing returns nothing
    local integer id 
    local integer cyclA = 1
    local real x
    local real y

    call DisableTrigger( GetTriggeringTrigger() )
    call SaveReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmd" ), 40 )
    loop
        exitwhen cyclA > 4
        set x = GetUnitX(udg_DamageEventTarget) + 600 * Cos((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set y = GetUnitY(udg_DamageEventTarget) + 600 * Sin((45 + ( 90 * cyclA )) * bj_DEGTORAD)
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( udg_DamageEventTarget ), 'u000', x, y, 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A0RU' )
        set id = GetHandleId( bj_lastCreatedUnit )
        
        if LoadTimerHandle( udg_hash, id, StringHash( "bsmd1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bsmd1" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmd1" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "bsmd1" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "bsmd1b" ), udg_DamageEventTarget )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bsmd1" ) ), bosscast(1), true, function ManaDr2Cast )
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Manadragon2 takes nothing returns nothing
    set gg_trg_Manadragon2 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manadragon2 )
    call TriggerRegisterVariableEvent( gg_trg_Manadragon2, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manadragon2, Condition( function Trig_Manadragon2_Conditions ) )
    call TriggerAddAction( gg_trg_Manadragon2, function Trig_Manadragon2_Actions )
endfunction

