function Trig_Moonlight_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CC'
endfunction

function MoonlightCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call DestroyEffect( LoadEffectHandle( udg_hash, id, StringHash( "mons" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Moonlight_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer id
    local boolean l = false
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0CC'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = 2 * eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set target = randomtarget( caster, 600, "enemy", "", "", "", "" )
        if target != null  then
            set l = true
            call dummyspawn( caster, 1, 0, 0, 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Starfall\\StarfallTarget.mdl", GetUnitX(target), GetUnitY(target) ) )
        else
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    if l then
        set bj_lastCreatedEffect = AddSpecialEffect( "Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl", GetUnitX(caster), GetUnitY(caster) )
        call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "mons" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "mons" ) ) )
        call SaveEffectHandle( udg_hash, id, StringHash( "mons" ), bj_lastCreatedEffect )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedEffect ), StringHash( "mons" ) ), 2.5, false, function MoonlightCast )
    endif
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Moonlight takes nothing returns nothing
    set gg_trg_Moonlight = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Moonlight, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Moonlight, Condition( function Trig_Moonlight_Conditions ) )
    call TriggerAddAction( gg_trg_Moonlight, function Trig_Moonlight_Actions )
endfunction

