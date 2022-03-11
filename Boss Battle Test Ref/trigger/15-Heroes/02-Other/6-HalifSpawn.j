function Trig_HalifSpawn_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'n00O'
endfunction

function Trig_HalifSpawn_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    
    call dummyspawn( GetEnteringUnit(), 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit()) ) )
    call GroupEnumUnitsInRange( g, GetUnitX( GetEnteringUnit() ), GetUnitY( GetEnteringUnit() ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, GetEnteringUnit(), "enemy" ) then
            call UnitDamageTarget( bj_lastCreatedUnit, u, 500, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_HalifSpawn takes nothing returns nothing
    set gg_trg_HalifSpawn = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_HalifSpawn, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_HalifSpawn, Condition( function Trig_HalifSpawn_Conditions ) )
    call TriggerAddAction( gg_trg_HalifSpawn, function Trig_HalifSpawn_Actions )
endfunction