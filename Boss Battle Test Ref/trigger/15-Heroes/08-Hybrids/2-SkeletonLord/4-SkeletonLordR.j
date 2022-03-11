function Trig_SkeletonLordR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0CN'
endfunction

function Trig_SkeletonLordR_Actions takes nothing returns nothing
    local real heal
    local unit caster
    local unit target
    local integer lvl
    local integer cyclA = 1
    local integer cyclAEnd

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "undead", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0CN'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set heal =  125. + ( 75. * lvl ) 
    set cyclAEnd = 1
    call healst( GetSpellAbilityUnit(), GetSpellTargetUnit(), heal )
    
    call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", GetSpellTargetUnit(), "origin") )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( Player(10), 'n01O', GetUnitX( target ) + GetRandomReal( -200, 200 ), GetUnitY( target ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", bj_lastCreatedUnit, "origin") )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_SkeletonLordR takes nothing returns nothing
    set gg_trg_SkeletonLordR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkeletonLordR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SkeletonLordR, Condition( function Trig_SkeletonLordR_Conditions ) )
    call TriggerAddAction( gg_trg_SkeletonLordR, function Trig_SkeletonLordR_Actions )
endfunction

