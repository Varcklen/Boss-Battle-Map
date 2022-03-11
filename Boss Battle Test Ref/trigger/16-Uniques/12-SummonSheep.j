function Trig_SummonSheep_Conditions takes nothing returns boolean
    return (GetSpellAbilityId() == 'A0MG' or GetSpellAbilityId() == 'A0MH' )
endfunction

function Trig_SummonSheep_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd = 1
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        set udg_logic[32] = true
        call textst( udg_string[0] + GetObjectName('A0MG'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    if IsUniqueUpgraded(caster) then
        set cyclAEnd = 2
    endif
    
    set x = GetUnitX( caster ) + 200 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 200 * Sin( 0.017 * GetUnitFacing( caster ) )
    
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), ID_SHEEP, x, y, GetUnitFacing( caster ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_SummonSheep takes nothing returns nothing
    set gg_trg_SummonSheep = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SummonSheep, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SummonSheep, Condition( function Trig_SummonSheep_Conditions ) )
    call TriggerAddAction( gg_trg_SummonSheep, function Trig_SummonSheep_Actions )
endfunction

