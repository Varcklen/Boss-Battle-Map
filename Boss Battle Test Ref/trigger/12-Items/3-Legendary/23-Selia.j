//TESH.scrollpos=24
//TESH.alwaysfold=0
function Trig_Selia_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A174'
endfunction

function SeliaCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call DestroyEffect( LoadEffectHandle( udg_hash, id, StringHash( "selia" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Selia_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer x
    local unit caster
    local real hp
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A174'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set x = eyest( caster )
    set hp = GetUnitState(caster, UNIT_STATE_MANA )
    set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 3 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
    loop
        exitwhen cyclA > 4
        if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and unitst( caster, udg_hero[cyclA], "ally" ) then
            call healst( caster, udg_hero[cyclA], hp )
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set bj_lastCreatedEffect = AddSpecialEffect( "Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl", GetUnitX(caster), GetUnitY(caster) )
    
    set id = GetHandleId( bj_lastCreatedEffect )
    if LoadTimerHandle( udg_hash, id, StringHash( "selia" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "selia" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "selia" ) ) )
    call SaveEffectHandle( udg_hash, id, StringHash( "selia" ), bj_lastCreatedEffect )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "selia" ) ), 2.5, false, function SeliaCast )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Selia takes nothing returns nothing
    set gg_trg_Selia = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Selia, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Selia, Condition( function Trig_Selia_Conditions ) )
    call TriggerAddAction( gg_trg_Selia, function Trig_Selia_Actions )
endfunction

