function Trig_ShamanE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0WR'
endfunction

function Trig_ShamanE_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local group g = CreateGroup()
    local unit u
    local real x
    local real y
    local real t
    local real j
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set t = 3 + (2*lvl)
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0WR'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        set t = 3 + (2*lvl)
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set t = 3 + (2*lvl)
    endif
    set t = timebonus(caster, t)
    
    call GroupEnumUnitsInRange( g, x, y, 400, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        set j = t
        if unitst( u, caster, "enemy" ) then
            if IsUnitType( u, UNIT_TYPE_ANCIENT) then
                set j = j/3
            endif
            call UnitPoly( caster, u, 'n02N', j )
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
function InitTrig_ShamanE takes nothing returns nothing
    set gg_trg_ShamanE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShamanE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShamanE, Condition( function Trig_ShamanE_Conditions ) )
    call TriggerAddAction( gg_trg_ShamanE, function Trig_ShamanE_Actions )
endfunction

