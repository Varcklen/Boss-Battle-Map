function Trig_MorlocR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0U4'
endfunction

function MorlocRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrlr" ) ), 'A0U2' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrlr" ) ), 'B03L' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_MorlocR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit target
    local real heal
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notfull", "", "", "" )
        set lvl = udg_Level
        set t = 18
        call textst( udg_string[0] + GetObjectName('A0U4'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 18
    endif
    set t = timebonus(caster, t)
    set heal = 50 + ( 75 * lvl )
    
    call DestroyEffect( AddSpecialEffectTarget("Objects\\Spawnmodels\\Other\\IllidanFootprint\\IllidanWaterSpawnFootPrint.mdl", caster, "origin" ) )
    if IsUnitAlly( target, GetOwningPlayer( caster ) ) then
        call healst( caster, target, heal )
    else
        call bufst( caster, target, 'A0U2', 'B03L', "mrlr", t )
        call SetUnitAbilityLevel( target, 'A0A6', lvl )
        call debuffst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MorlocR takes nothing returns nothing
    set gg_trg_MorlocR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MorlocR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MorlocR, Condition( function Trig_MorlocR_Conditions ) )
    call TriggerAddAction( gg_trg_MorlocR, function Trig_MorlocR_Actions )
endfunction

