function Trig_Echo_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A06Y' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Echo_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA
    local integer cyclAEnd
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A06Y'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    set i = CorrectPlayer(caster)

    set cyclA = 1
    set cyclAEnd = udg_Database_NumberItems[24]
    loop
        exitwhen cyclA > cyclAEnd
        if udg_DB_Hero_SpecAbAkt[cyclA] == udg_Ability_Uniq[i] or udg_DB_Hero_SpecAbAktPlus[cyclA] == udg_Ability_Uniq[i] then
            set i = cyclA
            set cyclA = cyclAEnd
        endif
        set cyclA = cyclA + 1
    endloop
    if i != 0 then
        set udg_CastLogic = true
        set udg_Caster = caster
        set udg_Target = target
        call TriggerExecute( udg_DB_Trigger_Spec[i] )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Echo takes nothing returns nothing
    set gg_trg_Echo = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Echo, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Echo, Condition( function Trig_Echo_Conditions ) )
    call TriggerAddAction( gg_trg_Echo, function Trig_Echo_Actions )
endfunction

