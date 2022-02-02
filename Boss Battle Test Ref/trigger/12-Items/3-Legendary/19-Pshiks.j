function Trig_Pshiks_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13X'
endfunction

function Trig_Pshiks_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclAEnd
    local integer i = 0
    local unit caster
    local unit target
    local integer sec
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A11N'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    if LoadBoolean( udg_hash, GetHandleId( caster ), StringHash( "unique" ) ) then
        set sec = 8
    else
        set sec = 2
    endif

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin" ) )
    set cyclA = 1
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call UnitStun(caster, target, sec )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Pshiks takes nothing returns nothing
    set gg_trg_Pshiks = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Pshiks, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Pshiks, Condition( function Trig_Pshiks_Conditions ) )
    call TriggerAddAction( gg_trg_Pshiks, function Trig_Pshiks_Actions )
endfunction

