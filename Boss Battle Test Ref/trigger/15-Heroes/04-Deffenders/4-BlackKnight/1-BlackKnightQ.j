function Trig_BlackKnightQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0Z2' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_BlackKnightQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real t
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0Z2'), caster, 64, 90, 10, 1.5 )
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 10
    endif
    set t = timebonus(caster, t)

    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 3000, null )
    call AddSpecialEffect( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", GetUnitX( caster ), GetUnitY( caster ) )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then 
		call taunt( caster, u, t )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BlackKnightQ takes nothing returns nothing
    set gg_trg_BlackKnightQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BlackKnightQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BlackKnightQ, Condition( function Trig_BlackKnightQ_Conditions ) )
    call TriggerAddAction( gg_trg_BlackKnightQ, function Trig_BlackKnightQ_Actions )
endfunction

