globals
    integer MODE_WILD_GROWTH_AREA = 128
endglobals

function Trig_Wild_Growth_Conditions takes nothing returns boolean
    return udg_modbad[27]
endfunction

function Wild_Growth_Vine takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local effect vine = LoadEffectHandle( udg_hash, id, StringHash( "mdb27v" ) )
    local group g = CreateGroup()
    local group affected = CreateGroup()
    local unit u

    if not( udg_fightmod[0] ) then
        call DestroyEffect(vine)
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( vine ), BlzGetLocalSpecialEffectY( vine ), MODE_WILD_GROWTH_AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitAlly(u, Player(4)) then
                call GroupAddUnit(affected, u)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        if not(IsUnitGroupEmptyBJ(affected)) then
            loop
                set u = FirstOfGroup(affected)
                exitwhen u == null
                set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_AGGRESSIVE ), 'u000', GetUnitX( u ), GetUnitY( u ), 270 )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)   
                call UnitAddAbility( bj_lastCreatedUnit, 'A0LG')
                call IssueTargetOrder( bj_lastCreatedUnit, "entanglingroots", u )
                call GroupRemoveUnit(affected,u)
            endloop
            call DestroyEffect(vine)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( affected )
    call DestroyGroup( affected )
    set vine = null
    set u = null
    set g = null
    set affected = null
endfunction

function Wild_Growth_ActivationTime takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local effect vine = LoadEffectHandle( udg_hash, id, StringHash( "mdb27" ) )
    local integer id1

    set id1 = GetHandleId( vine )

    if LoadTimerHandle( udg_hash, id1, StringHash( "mdb27v" ) ) == null  then
        call SaveTimerHandle( udg_hash, id1, StringHash( "mdb27v" ), CreateTimer() )
    endif
    set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb27v" ) ) ) 
    call SaveEffectHandle( udg_hash, id1, StringHash( "mdb27v" ), vine )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( vine ), StringHash( "mdb27v" ) ), 0.5, true, function Wild_Growth_Vine )
    call DestroyTimer( GetExpiredTimer() )
    
    set vine = null
endfunction

function Wild_Growth_Spawn takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer id1
    local unit hero
    local effect vine

    if not( udg_fightmod[0] ) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    else
        set hero = GroupPickRandomUnit(udg_otryad)
        
        if hero != null then
            set vine = AddSpecialEffect("Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", Math_GetUnitRandomX(hero, 500), Math_GetUnitRandomY(hero, 500))
            call BlzSetSpecialEffectColor( vine, 255, 50, 50 )
        
            set id1 = GetHandleId( vine )

            if LoadTimerHandle( udg_hash, id1, StringHash( "mdb27" ) ) == null  then
                call SaveTimerHandle( udg_hash, id1, StringHash( "mdb27" ), CreateTimer() )
            endif
            set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mdb27" ) ) ) 
            call SaveEffectHandle( udg_hash, id1, StringHash( "mdb27" ), vine )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( vine ), StringHash( "mdb27" ) ), 2, false, function Wild_Growth_ActivationTime )
        endif
    endif
    
    set hero = null
    set vine = null
endfunction

function Trig_Wild_Growth_Actions takes nothing returns nothing
    call TimerStart( CreateTimer(), 12, true, function Wild_Growth_Spawn )
endfunction

//===========================================================================
function InitTrig_Wild_Growth takes nothing returns nothing
    set gg_trg_Wild_Growth = CreateTrigger()
    call TriggerRegisterVariableEvent( gg_trg_Wild_Growth, "udg_FightStartGlobal_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Wild_Growth, Condition( function Trig_Wild_Growth_Conditions ) )
    call TriggerAddAction( gg_trg_Wild_Growth, function Trig_Wild_Growth_Actions )
endfunction

