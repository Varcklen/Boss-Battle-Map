function Trig_Bloody_Figurine_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A14D'
endfunction

function Trig_Bloody_Figurine_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0WG'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    set cyclAEnd = eyest( caster )
    call DestroyEffect( AddSpecialEffect( "Blood Whirl.mdx", GetUnitX( target ), GetUnitY( target ) ) )
	call KillUnit(target)
    set cyclA = 1
    loop
        exitwhen cyclA > cyclAEnd
        if combat( caster, false, 0 ) and not(udg_fightmod[3] ) then
            call RandomStat( caster, 1, 120, true )
        endif
        set cyclA = cyclA + 1
    endloop
    
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Bloody_Figurine takes nothing returns nothing
    set gg_trg_Bloody_Figurine = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bloody_Figurine, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Bloody_Figurine, Condition( function Trig_Bloody_Figurine_Conditions ) )
    call TriggerAddAction( gg_trg_Bloody_Figurine, function Trig_Bloody_Figurine_Actions )
endfunction

