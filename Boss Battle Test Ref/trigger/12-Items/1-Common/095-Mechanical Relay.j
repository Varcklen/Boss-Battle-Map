function Trig_Mechanical_Relay_Conditions takes nothing returns boolean
    return inv(udg_DamageEventTarget, 'I00I') > 0 and luckylogic( udg_DamageEventTarget, 15, 1, 100 )
endfunction

function Mech_relayCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "mchr" ) )
    local real dmg = 15 + (15*SetCount_GetPieces(c, SET_MECH))
    local group g = CreateGroup()
    local unit u
    
    call spectime("Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl", GetUnitX( c ), GetUnitY( c ), 1.6 )
    call GroupEnumUnitsInRange( g, GetUnitX( c ), GetUnitY( c ), 450, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, c, "enemy" ) then
            call UnitTakeDamage( c, u, dmg, DAMAGE_TYPE_MAGIC )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    call FlushChildHashtable( udg_hash, id )

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set c = null
endfunction

function Trig_Mechanical_Relay_Actions takes nothing returns nothing
    call InvokeTimerWithUnit(udg_DamageEventTarget, "mchr", 0.01, false, function Mech_relayCast )
endfunction

//===========================================================================
function InitTrig_Mechanical_Relay takes nothing returns nothing
    set gg_trg_Mechanical_Relay = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Mechanical_Relay, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Mechanical_Relay, Condition( function Trig_Mechanical_Relay_Conditions ) )
    call TriggerAddAction( gg_trg_Mechanical_Relay, function Trig_Mechanical_Relay_Actions )
endfunction

