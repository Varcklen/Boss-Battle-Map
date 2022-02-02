function Trig_DogR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A15B'
endfunction

function Trig_DogR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local real r = 0
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A15B'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.08
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX(caster), GetUnitY(caster) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            if GetUnitAbilityLevel( u, 'B06Y') > 0 then
                set r = r + dmg
            endif
            call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX(u), GetUnitY(u) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if r > 0 then
        call healst( caster, null, r )
    endif
    
    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - 80 ))
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_DogR takes nothing returns nothing
    set gg_trg_DogR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DogR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DogR, Condition( function Trig_DogR_Conditions ) )
    call TriggerAddAction( gg_trg_DogR, function Trig_DogR_Actions )
endfunction

