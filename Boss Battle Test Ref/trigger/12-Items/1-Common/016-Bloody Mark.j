function Trig_Bloody_Mark_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14C'
endfunction

function Trig_Bloody_Mark_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0YG'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffect("Blood Explosion.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    loop
        exitwhen cyclA > cyclAEnd
        if not(IsUnitType( target, UNIT_TYPE_HERO)) and not(IsUnitType( target, UNIT_TYPE_ANCIENT)) then
            set bj_lastCreatedUnit = CreateUnitCopy( target, GetUnitX( target ) + GetRandomReal( -200, 200 ), GetUnitY( target ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30)
        endif
        set cyclA = cyclA + 1
    endloop
    call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - 120. ))
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Bloody_Mark takes nothing returns nothing
    set gg_trg_Bloody_Mark = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bloody_Mark, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Bloody_Mark, Condition( function Trig_Bloody_Mark_Conditions ) )
    call TriggerAddAction( gg_trg_Bloody_Mark, function Trig_Bloody_Mark_Actions )
endfunction

