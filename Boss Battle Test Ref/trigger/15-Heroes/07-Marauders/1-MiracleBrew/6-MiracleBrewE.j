function Trig_MiracleBrewE_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetDyingUnit()) == 'u000' and ( GetUnitAbilityLevel(GetDyingUnit(), 'A087') > 0 or GetUnitAbilityLevel(GetDyingUnit(), 'A0MZ') > 0 )
endfunction

function MiracleBrewECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrbr" ) ), 'A0S0' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrbr" ) ), 'B00Y' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_MiracleBrewE_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local unit caster = LoadUnitHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "mrbr" ) )
    local real dmg = LoadReal( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "mrbr" ) )
    local integer id
    local real t = timebonus(caster, 15)

    call DestroyEffect(AddSpecialEffect("Units\\NightElf\\Wisp\\WispExplode.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() )))
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 355, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy") then
            set id = GetHandleId( u )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call UnitAddAbility( u, 'A0S0' )
                call SetUnitAbilityLevel( u, 'A0A5', GetUnitAbilityLevel( caster, 'A0RT' ) )
                call SaveTimerHandle( udg_hash, id, StringHash( "mrbr" ), CreateTimer() )
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mrbr" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "mrbr" ), u )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "mrbr" ) ), t, false, function MiracleBrewECast )

	    	if BuffLogic() then
        		call debuffst( caster, u, null, 1, t )
   		endif
            endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

    call RemoveSavedHandle(udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "mrbr" ) )
    call RemoveSavedReal(udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "mrbr" ) )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_MiracleBrewE takes nothing returns nothing
    set gg_trg_MiracleBrewE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewE, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_MiracleBrewE, Condition( function Trig_MiracleBrewE_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewE, function Trig_MiracleBrewE_Actions )
endfunction

