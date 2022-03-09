function Trig_Voodoo_explosion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1AD'
endfunction

function Trig_Voodoo_explosion_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    local group g = CreateGroup()
    local unit u
    local integer k = 0
    local real dmg
    
    if CastLogic() then
        set caster = udg_Target
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A1AD'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    set dmg = 75
    
    call GroupEnumUnitsInRange( g, x, y, 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "all" ) then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\HealingSpray\\HealBottleMissile.mdl", GetUnitX(u), GetUnitY(u) ) )
            call UnitTakeDamage( caster, u, dmg, DAMAGE_TYPE_MAGIC)
            if IsUnitEnemy( u, GetOwningPlayer( caster ) ) then
                set k = k + 1
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    if k >= 3 and combat( caster, false, 0 ) and not(udg_fightmod[3]) then
        call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\HealingSpray\\HealBottleMissile.mdl", GetUnitX(caster), GetUnitY(caster) ) )
        call luckyst( caster, 1 )
        call textst( "|c00FFFF00 +1 luck", caster, 64, 90, 10, 1.5 )
        set udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 80] = udg_Data[GetPlayerId( GetOwningPlayer( caster ) ) + 1 + 80] + 1
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Voodoo_explosion takes nothing returns nothing
    set gg_trg_Voodoo_explosion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Voodoo_explosion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Voodoo_explosion, Condition( function Trig_Voodoo_explosion_Conditions ) )
    call TriggerAddAction( gg_trg_Voodoo_explosion, function Trig_Voodoo_explosion_Actions )
endfunction

