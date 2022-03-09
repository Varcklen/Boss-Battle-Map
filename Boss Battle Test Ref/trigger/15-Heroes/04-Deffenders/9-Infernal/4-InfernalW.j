function Trig_InfernalW_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetOrderedUnit(), 'A1A9') > 0
endfunction

function InfernalWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "infw" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "infw" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "infw" ) )
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( caster, UNIT_STATE_LIFE) <= 0.405 or GetUnitAbilityLevel( caster, 'A1A9' ) == 0 or GetUnitAbilityLevel( caster, 'B04K' ) == 0 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call bufallst( caster, u, 'A1AA', 'A1AB', 0, 0, 0, 'B050', "infwd", 4 )
                call SetUnitAbilityLevel(u, 'A1AB', lvl )
                call debuffst( caster, u, null, 1, 4 )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Immolation\\ImmolationDamage.mdl", u, "origin" ) )
                call UnitTakeDamage( caster, u, dmg, DAMAGE_TYPE_MAGIC)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

function Trig_InfernalW_Actions takes nothing returns nothing
    local unit u = GetOrderedUnit()
    local integer id = GetHandleId( u )
    local integer lvl = GetUnitAbilityLevel( u, 'A1A9' )
    local real dmg = 10+ (5*lvl)

    if GetIssuedOrderId() == OrderId("immolation") then
        if LoadTimerHandle( udg_hash, id, StringHash( "infw" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "infw" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "infw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "infw" ), u )   
        call SaveReal( udg_hash, id, StringHash( "infw" ), dmg )
        call SaveInteger( udg_hash, id, StringHash( "infw" ), lvl )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "infw" ) ), 1, true, function InfernalWCast )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_InfernalW takes nothing returns nothing
    set gg_trg_InfernalW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfernalW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    call TriggerAddCondition( gg_trg_InfernalW, Condition( function Trig_InfernalW_Conditions ) )
    call TriggerAddAction( gg_trg_InfernalW, function Trig_InfernalW_Actions )
endfunction