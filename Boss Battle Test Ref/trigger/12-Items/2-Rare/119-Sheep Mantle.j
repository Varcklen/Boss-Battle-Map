function Trig_Sheep_Mantle_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0FK'
endfunction

function Trig_Sheep_Mantle_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0FK'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "all" ) and GetUnitTypeId(u) != ID_SHEEP then
                call UnitPoly( caster, u, 'n02L', 5 )
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), ID_SHEEP, GetUnitX( u ) + GetRandomReal( -200, 200 ), GetUnitY( u ) + GetRandomReal( -200, 200 ), 270 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl", bj_lastCreatedUnit, "origin" ) )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Sheep_Mantle takes nothing returns nothing
    set gg_trg_Sheep_Mantle = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_Mantle, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheep_Mantle, Condition( function Trig_Sheep_Mantle_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_Mantle, function Trig_Sheep_Mantle_Actions )
endfunction

