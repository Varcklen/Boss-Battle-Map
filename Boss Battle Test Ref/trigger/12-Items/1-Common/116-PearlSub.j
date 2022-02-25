function Trig_PearlSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A140'
endfunction

function Trig_PearlSub_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd 
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0E2'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set heal = 100. + ( 25. * GetHeroLevel( caster ) ) 
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, target, heal )
        call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\MiniRessurection.mdx", target, "origin" ) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_PearlSub takes nothing returns nothing
    set gg_trg_PearlSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PearlSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PearlSub, Condition( function Trig_PearlSub_Conditions ) )
    call TriggerAddAction( gg_trg_PearlSub, function Trig_PearlSub_Actions )
endfunction

