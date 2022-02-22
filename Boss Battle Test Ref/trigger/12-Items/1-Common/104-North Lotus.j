function Trig_North_Lotus_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14M'
endfunction

function Trig_North_Lotus_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer rand
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11T'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, target, 300 )
        call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\MiniRessurection.mdx", target, "origin" ) )
        if GetUnitState( target, UNIT_STATE_MAX_LIFE ) == GetUnitState( target, UNIT_STATE_LIFE ) and combat( caster, false, 0 ) then
            set udg_RandomLogic = true
            set udg_Caster = caster
            set udg_Level = 5
            set rand = GetRandomInt( 1, 3 )
            set RandomMode = true
            if rand == 1 then
                call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
            elseif rand == 2 then
                call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
            else
                call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
            endif
            set RandomMode = false
        endif
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_North_Lotus takes nothing returns nothing
    set gg_trg_North_Lotus = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_North_Lotus, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_North_Lotus, Condition( function Trig_North_Lotus_Conditions ) )
    call TriggerAddAction( gg_trg_North_Lotus, function Trig_North_Lotus_Actions )
endfunction

