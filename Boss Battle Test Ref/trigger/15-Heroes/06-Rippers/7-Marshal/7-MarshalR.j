globals
    constant integer MARSHAL_R_CHANCE = 15
    constant integer MARSHAL_R_MINIONS_COUNT = 2
endglobals

function Trig_MarshalR_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0FF'
endfunction

function MarshalR_UnitCondition takes unit u returns boolean
    local boolean isGood = true
    
    if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        set isGood = false
    elseif IsUnitType(u, UNIT_TYPE_ANCIENT ) then
        set isGood = false
    elseif IsUnitType(u, UNIT_TYPE_HERO ) then
        set isGood = false
    elseif GetUnitTypeId(u) == 'u000' then
        set isGood = false
    elseif GetUnitTypeId(u) == 'h00A' then
        set isGood = false
    elseif GetUnitTypeId(u) == 'h01B' then
        set isGood = false
    endif
    
    set u = null
    return isGood
endfunction

function MarshalR_MinionUnderControl takes unit hero returns boolean
    local player myPlayer = GetOwningPlayer(hero)
    local boolean work = false
    local integer minionsCount = 0
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsOfPlayer(g, myPlayer, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if MarshalR_UnitCondition(u) then
            set minionsCount = minionsCount + 1
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if minionsCount >= MARSHAL_R_MINIONS_COUNT then
        set work = true
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set hero = null
    set myPlayer = null
    return work
endfunction

function MarshalRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mrsr" ) )
    
    if GetUnitAbilityLevel(u, 'A0FF') == 0 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( u ) ) then
        if MarshalR_MinionUnderControl(u) then
            call UnitAddAbility(u, 'A0FL')
        elseif GetUnitAbilityLevel( u, 'A0FL') > 0 then
            call UnitRemoveAbility(u, 'A0FL')
            call UnitRemoveAbility(u, 'B05N')
        endif
    endif
    
    set u = null
endfunction

function Trig_MarshalR_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "mrsr" )))
    call RemoveSavedHandle( udg_hash, id, StringHash( "mrsr" ) )
    call SaveTimerHandle( udg_hash, id, StringHash( "mrsr" ), CreateTimer() )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mrsr" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "mrsr" ), GetLearningUnit() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "mrsr" ) ), 1, true, function MarshalRCast )
endfunction

//===========================================================================
function InitTrig_MarshalR takes nothing returns nothing
    set gg_trg_MarshalR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MarshalR, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MarshalR, Condition( function Trig_MarshalR_Conditions ) )
    call TriggerAddAction( gg_trg_MarshalR, function Trig_MarshalR_Actions )
endfunction
