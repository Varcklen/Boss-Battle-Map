function Trig_Energizer_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I05F') > 0 and luckylogic( GetSpellAbilityUnit(), 20, 1, 100 )
endfunction

function EnergizerCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "enrgz" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Energizer_Actions takes nothing returns nothing
    local lightning l 
    local integer id 
    local group g = CreateGroup()
    local unit u
    local unit caster = GetSpellAbilityUnit()

    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally" ) and u != caster and IsUnitType( u, UNIT_TYPE_HERO) then
        	set l = AddLightningEx("CLPB", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) + 50, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + 50 )
        	set id = GetHandleId( l )
        	call SaveTimerHandle( udg_hash, id, StringHash( "enrgz" ), CreateTimer() )
        	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enrgz" ) ) ) 
        	call SaveLightningHandle( udg_hash, id, StringHash( "enrgz" ), l )
        	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enrgz" ) ), 0.5, false, function EnergizerCast )

        	call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        	call manast( caster, u, 25 )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set l = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Energizer takes nothing returns nothing
    set gg_trg_Energizer = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Energizer, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Energizer, Condition( function Trig_Energizer_Conditions ) )
    call TriggerAddAction( gg_trg_Energizer, function Trig_Energizer_Actions )
endfunction

