function Trig_BuggerQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A105'
endfunction

function Trig_BuggerQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A105'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 5000, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if GetUnitAbilityLevel( u, 'A0ND' ) > 0 and GetOwningPlayer( u ) == GetOwningPlayer( caster ) then
            call IssueImmediateOrder( u, "stop" )
            call IssueTargetOrder( u, "chainlightning", target )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_BuggerQ takes nothing returns nothing
    set gg_trg_BuggerQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BuggerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BuggerQ, Condition( function Trig_BuggerQ_Conditions ) )
    call TriggerAddAction( gg_trg_BuggerQ, function Trig_BuggerQ_Actions )
endfunction

