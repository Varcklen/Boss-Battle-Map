function Trig_ShoggothE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14W'
endfunction

function Trig_ShoggothE_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local real x
    local real y
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A14W'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set t = 10
    endif
    set t = timebonus(caster, t)
    
    set dmg = 50 + ( 50 * lvl )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, x, y, 500, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" )then
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX(u), GetUnitY(u) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call bufst( caster, u, 'A12Y', 'B06U', "shgtw1", t )
                call SetUnitAbilityLevel( u, 'A12E', lvl )

                if BuffLogic() then
                    call debuffst( caster, u, null, 1, 10 )
                endif
            endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothE takes nothing returns nothing
    set gg_trg_ShoggothE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothE, Condition( function Trig_ShoggothE_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothE, function Trig_ShoggothE_Actions )
endfunction

