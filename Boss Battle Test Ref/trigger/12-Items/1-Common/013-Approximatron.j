function Trig_Approximatron_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A007' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction
  
function Trig_Approximatron_Actions takes nothing returns nothing
    local real heal
    local unit caster
    local integer cyclA = 1
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A007'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set heal = eyest(caster)*100*SetCount_GetPieces(caster, SET_MECH)
    loop
        exitwhen cyclA > 4
        if udg_hero[cyclA] != caster and unitst(caster, udg_hero[cyclA], "ally") then
            call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
            call SetUnitPosition( udg_hero[cyclA], GetUnitX(caster), GetUnitY(caster) )
            call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(udg_hero[cyclA]), GetUnitY(udg_hero[cyclA]) ) )
            call healst( caster, udg_hero[cyclA], heal )
            call PanCameraToTimedLocForPlayer( Player( cyclA - 1 ), GetUnitLoc( udg_hero[cyclA] ), 0.25 )
        endif
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Approximatron takes nothing returns nothing
    set gg_trg_Approximatron = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Approximatron, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Approximatron, Condition( function Trig_Approximatron_Conditions ) )
    call TriggerAddAction( gg_trg_Approximatron, function Trig_Approximatron_Actions )
endfunction

