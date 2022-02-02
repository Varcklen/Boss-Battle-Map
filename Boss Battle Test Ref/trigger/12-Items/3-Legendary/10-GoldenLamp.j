function Trig_GoldenLamp_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0VB'
endfunction

function Trig_GoldenLamp_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local integer i
    local unit caster
    local unit target
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0VB'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "gldl" ) ) 
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ForkedLightningOrange.mdx", GetUnitX( target ), GetUnitY( target ) ) )
    set cyclA = 1
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_GoldenLamp takes nothing returns nothing
    set gg_trg_GoldenLamp = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GoldenLamp, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GoldenLamp, Condition( function Trig_GoldenLamp_Conditions ) )
    call TriggerAddAction( gg_trg_GoldenLamp, function Trig_GoldenLamp_Actions )
endfunction

