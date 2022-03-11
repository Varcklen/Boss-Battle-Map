function Trig_Azgalor1_Conditions takes nothing returns boolean
    return GetUnitTypeId(udg_DamageEventTarget) == 'h011'
endfunction

function AzgCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bszg" ) )
    local integer cyclA

    if GetUnitState( boss, UNIT_STATE_LIFE) <= 0.405 or not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                call SetUnitState(udg_hero[cyclA], UNIT_STATE_MANA, RMaxBJ(0,GetUnitState(udg_hero[cyclA], UNIT_STATE_MANA) - 4 ) )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set boss = null
endfunction

function Trig_Azgalor1_Actions takes nothing returns nothing
    local integer id = GetHandleId( udg_DamageEventTarget )
    local integer cyclA
    local integer cyclB
    local item it
    local integer k
    local integer array slot

    call DisableTrigger( GetTriggeringTrigger() )
    
    set cyclA = 0
    loop
        exitwhen cyclA > 5
        set slot[cyclA] = 0
        set cyclA = cyclA + 1
    endloop
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            set cyclB = 0
            set k = 0
            loop
                exitwhen cyclB > 5
                if UnitHasItem(udg_hero[cyclA], UnitItemInSlot(udg_hero[cyclA], cyclB)) then
                    set k = k + 1
                    set slot[k] = cyclB
                endif
                set cyclB = cyclB + 1
            endloop
            if k > 0 then
                set it = UnitItemInSlot(udg_hero[cyclA], slot[GetRandomInt(1,k)] )
                if it != null then
                    call AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", udg_hero[cyclA], "origin")
                    call UnitRemoveItem(udg_hero[cyclA], it)
                    call SetItemPosition(it, GetLocationX(udg_point[21+cyclA]), GetLocationY(udg_point[21+cyclA])-200)
                endif
            endif
        endif
        set cyclA = cyclA + 1
    endloop
    
    call UnitAddAbility(udg_DamageEventTarget, 'A0K1')
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", udg_DamageEventTarget, "origin") )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "bszg" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bszg" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bszg" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "bszg" ), udg_DamageEventTarget )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bszg" ) ), bosscast(1), true, function AzgCast )

    set cyclA = 0
    loop
        exitwhen cyclA > 5
        set slot[cyclA] = 0
        set cyclA = cyclA + 1
    endloop

    set it = null
endfunction

//===========================================================================
function InitTrig_Azgalor1 takes nothing returns nothing
    set gg_trg_Azgalor1 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Azgalor1 )
    call TriggerRegisterVariableEvent( gg_trg_Azgalor1, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Azgalor1, Condition( function Trig_Azgalor1_Conditions ) )
    call TriggerAddAction( gg_trg_Azgalor1, function Trig_Azgalor1_Actions )
endfunction

