function Trig_ComandQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0UK'
endfunction

function Trig_ComandQ_Actions takes nothing returns nothing
    local real x 
    local real y
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0UK'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif
    
    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )
    set dmg = 100 + ( 50 * lvl ) 
    
	call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl", x, y ) )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, x, y, 250, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
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
function InitTrig_ComandQ takes nothing returns nothing
    set gg_trg_ComandQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ComandQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ComandQ, Condition( function Trig_ComandQ_Conditions ) )
    call TriggerAddAction( gg_trg_ComandQ, function Trig_ComandQ_Actions )
endfunction

