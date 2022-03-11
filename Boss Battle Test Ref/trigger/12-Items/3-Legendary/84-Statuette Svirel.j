function Trig_Statuette_Svirel_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0PP'
endfunction

function Trig_Statuette_Svirel_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer h
    local integer cyclB
    local real r
    local unit caster
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0PP'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

    set h = eyest( caster )
    call GroupEnumUnitsInRange( g, x, y, 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "all" ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and GetUnitTypeId(u) != 'h01F' and GetUnitAbilityLevel( u, 'Avul') == 0 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call ShowUnit( u, false)
            call CreateUnit(GetOwningPlayer(u), ID_SHEEP, GetUnitX(u), GetUnitY(u), GetUnitFacing(u))
            call KillUnit( u )
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
function InitTrig_Statuette_Svirel takes nothing returns nothing
    set gg_trg_Statuette_Svirel = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Statuette_Svirel, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Statuette_Svirel, Condition( function Trig_Statuette_Svirel_Conditions ) )
    call TriggerAddAction( gg_trg_Statuette_Svirel, function Trig_Statuette_Svirel_Actions )
endfunction

