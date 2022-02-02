function Trig_Magic_casket_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CI'
endfunction

function Trig_Magic_casket_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0CI'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )

    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), udg_Eczotic[GetRandomInt(1, udg_Database_NumberItems[28])], GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Magic_casket takes nothing returns nothing
    set gg_trg_Magic_casket = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_casket, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Magic_casket, Condition( function Trig_Magic_casket_Conditions ) )
    call TriggerAddAction( gg_trg_Magic_casket, function Trig_Magic_casket_Actions )
endfunction