function Trig_Sheep_Bell_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04O'
endfunction

function Trig_Sheep_Bell_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A04O'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif 

    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )
    
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 1
        loop
            exitwhen cyclB > 3
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), ID_SHEEP, x, y, GetUnitFacing( caster ) )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Sheep_Bell takes nothing returns nothing
    set gg_trg_Sheep_Bell = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sheep_Bell, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sheep_Bell, Condition( function Trig_Sheep_Bell_Conditions ) )
    call TriggerAddAction( gg_trg_Sheep_Bell, function Trig_Sheep_Bell_Actions )
endfunction

