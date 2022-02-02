function Trig_EnergyballQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A01D' 
endfunction

function Trig_EnergyballQ_Actions takes nothing returns nothing
    local lightning l
    local integer id 
    local integer lvl
    local integer cyclA = 1
    local real dmg 
    local group g
    local group h 
    local group n
    local unit target
    local unit caster
    local unit lastunit
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A01D'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 60 + ( 40 * lvl )  
    set lastunit = caster
    set g = CreateGroup()
    set h = CreateGroup()
    set n = CreateGroup()
    
    call dummyspawn( caster, 3, 0, 0 , 0 )
    loop
        exitwhen cyclA > 1
        set l = AddLightningEx("CLPB", true, GetUnitX(lastunit), GetUnitY(lastunit), GetUnitFlyHeight(lastunit) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
        set id = GetHandleId( l )

        call SaveTimerHandle( udg_hash, id, StringHash( "enba" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enba" ) ) ) 
        call SaveLightningHandle( udg_hash, id, StringHash( "enba" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function EnergyballACast )
	call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        
	call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( target ), GetUnitY( target ) ) )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 250, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and u != target and not( IsUnitInGroup(u , n ) ) then
                call GroupAddUnit(h, u)
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if not( IsUnitGroupEmptyBJ(h) ) then
            set cyclA = cyclA - 1
            set lastunit = target
            set target = GroupPickRandomUnit(h)
            call GroupRemoveUnit(h, target)
            call GroupAddUnit(n, target)
        endif
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( h )
    call DestroyGroup( h )
    call GroupClear( n )
    call DestroyGroup( n )
    set n = null
    set g = null
    set h = null
    set l = null
    set u = null
    set caster = null
    set target = null
    set lastunit = null
endfunction

//===========================================================================
function InitTrig_EnergyballQ takes nothing returns nothing
    set gg_trg_EnergyballQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_EnergyballQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_EnergyballQ, Condition( function Trig_EnergyballQ_Conditions ) )
    call TriggerAddAction( gg_trg_EnergyballQ, function Trig_EnergyballQ_Actions )
endfunction

