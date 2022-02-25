function Trig_Manadragon1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e004' and GetUnitLifePercent(udg_DamageEventTarget) <= 75
endfunction

function ManadrCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmd" ) ) 
    local real r = LoadReal( udg_hash, GetHandleId( boss ), StringHash( "bsmd" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 900, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                call SetUnitState( u, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState( u, UNIT_STATE_MANA ) - ( r * SpellPower_GetBossSpellPower() ) ) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\ReplenishMana\\ReplenishManaCasterOverhead.mdl", u, "origin") )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
endfunction

function Trig_Manadragon1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bsmd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmd" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmd" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmd" ), udg_DamageEventTarget )
    call SaveReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmd" ), 20 )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmd" ) ), bosscast(10), true, function ManadrCast )
endfunction

//===========================================================================
function InitTrig_Manadragon1 takes nothing returns nothing
    set gg_trg_Manadragon1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manadragon1 )
    call TriggerRegisterVariableEvent( gg_trg_Manadragon1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manadragon1, Condition( function Trig_Manadragon1_Conditions ) )
    call TriggerAddAction( gg_trg_Manadragon1, function Trig_Manadragon1_Actions )
endfunction

