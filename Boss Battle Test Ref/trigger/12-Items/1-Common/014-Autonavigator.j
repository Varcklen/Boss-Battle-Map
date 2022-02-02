function Trig_Autonavigator_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11V'
endfunction

function Trig_Autonavigator_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local real dmg 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11V'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster ) * ( SetCount_GetPieces(caster, SET_MECH) + 1 )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( Player(4), udg_Database_RandomUnit[GetRandomInt(1, udg_Database_NumberItems[5])], GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30.)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        call IssueTargetOrder( bj_lastCreatedUnit, "attack", target )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Autonavigator takes nothing returns nothing
    set gg_trg_Autonavigator = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Autonavigator, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Autonavigator, Condition( function Trig_Autonavigator_Conditions ) )
    call TriggerAddAction( gg_trg_Autonavigator, function Trig_Autonavigator_Actions )
endfunction

