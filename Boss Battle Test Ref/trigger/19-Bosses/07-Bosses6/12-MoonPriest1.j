function Trig_MoonPriest1_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e005' and GetUnitLifePercent(udg_DamageEventTarget) <= 80
endfunction

function MoonPriestCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local integer rand
    local unit target
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsmp" ) )
    local group g = CreateGroup()
    local unit u

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set rand = GetRandomInt(1, 4)
        if rand == 1 then
            set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
            if target != null then
                call dummyspawn( boss, 1, 0, 0, 0 )
                call SetUnitFacing( boss, bj_RADTODEG * Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss) ) )
                call UnitDamageTarget( bj_lastCreatedUnit, target, 250, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin") )
            endif
        elseif rand == 2 then
            call SetUnitState( boss, UNIT_STATE_MANA, GetUnitState( boss, UNIT_STATE_MANA) + ( 100 * udg_SpellDamage[0] ) )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", boss, "origin") )
        elseif rand == 3 then
            call SetUnitState( boss, UNIT_STATE_LIFE, GetUnitState( boss, UNIT_STATE_LIFE) + ( 300 * udg_SpellDamage[0] ) )
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", boss, "origin") )
        elseif rand == 4 then
            call dummyspawn( boss, 1, 0, 0, 0 )
            call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\ArcaneExplosion.mdx", LoadUnitHandle( udg_hash, id, StringHash( "bsmp" ) ), "origin") )
            call GroupEnumUnitsInRange( g, GetUnitX( boss ), GetUnitY( boss ), 250, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, boss, "enemy" ) then
                    call UnitDamageTarget(bj_lastCreatedUnit, u, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
                call GroupRemoveUnit(g,u)
            endloop
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set boss = null
    set target = null
endfunction

function Trig_MoonPriest1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )

    call DisableTrigger( GetTriggeringTrigger() )

    if LoadTimerHandle( udg_hash, id, StringHash( "bsmp" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bsmp" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bsmp" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bsmp" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsmp" ) ), bosscast(7), true, function MoonPriestCast )
endfunction

//===========================================================================
function InitTrig_MoonPriest1 takes nothing returns nothing
    set gg_trg_MoonPriest1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_MoonPriest1 )
    call TriggerRegisterVariableEvent( gg_trg_MoonPriest1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_MoonPriest1, Condition( function Trig_MoonPriest1_Conditions ) )
    call TriggerAddAction( gg_trg_MoonPriest1, function Trig_MoonPriest1_Actions )
endfunction

