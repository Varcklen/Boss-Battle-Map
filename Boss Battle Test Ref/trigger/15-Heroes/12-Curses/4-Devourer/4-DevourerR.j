function Trig_DevourerR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A10J'
endfunction

function Trig_DevourerR_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA
    local integer lvl
    local real x
    local real y
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A10J'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    call GroupEnumUnitsInRange( g, x, y, 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            set i = i + 1
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if i > 0 then
        set dmg = ( 325 + ( lvl * 125 ) ) / i
        
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, x, y, 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
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

//===========================================================================
function InitTrig_DevourerR takes nothing returns nothing
    set gg_trg_DevourerR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DevourerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DevourerR, Condition( function Trig_DevourerR_Conditions ) )
    call TriggerAddAction( gg_trg_DevourerR, function Trig_DevourerR_Actions )
endfunction

