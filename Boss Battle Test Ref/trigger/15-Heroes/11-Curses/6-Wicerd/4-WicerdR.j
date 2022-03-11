function Trig_WicerdR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17O'
endfunction

function Trig_WicerdR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = 10
        call textst( udg_string[0] + GetObjectName('A17O'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 10
    endif
    
    set dmg = 40 + ( 20 * lvl )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
		call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX(u), GetUnitY(u) ) )
    		if GetUnitAbilityLevel( u, 'B07J' ) == 0 and GetUnitAbilityLevel( u, 'B07K' ) == 0 then
			call freezest( caster, u, t, lvl )
    		else
    			call dummyspawn( caster, 1, 0, 0, 0 )
    			call UnitDamageTarget(bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                call UnitStun(caster, u, 3 )
    		endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_WicerdR takes nothing returns nothing
    set gg_trg_WicerdR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WicerdR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WicerdR, Condition( function Trig_WicerdR_Conditions ) )
    call TriggerAddAction( gg_trg_WicerdR, function Trig_WicerdR_Actions )
endfunction

