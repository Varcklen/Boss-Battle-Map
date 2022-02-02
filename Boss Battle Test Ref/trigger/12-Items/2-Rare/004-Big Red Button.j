function Trig_Big_Red_Button_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0SW'
endfunction

function Trig_Big_Red_Button_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local real r
    local unit caster
    local real x
    local real y
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0SW'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 0
        set r = 0
        loop
            exitwhen cyclB > 5
            if not( UnitHasItem(udg_hero[GetPlayerId(GetOwningPlayer(caster)) + 1], UnitItemInSlot( udg_hero[GetPlayerId(GetOwningPlayer(caster)) + 1], cyclB ) ) ) then
                set r = r + 1
            endif
            set cyclB = cyclB + 1
        endloop
        if r == 0 then
            call textst( "|c00FFFFFF Button does not work", caster, 64, 90, 10, 1.5 )
        else
            call GroupAoE( caster, null, x, y, 300 * r, 640, "enemy", "", "" )
            call spectime("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl", x, y, 8 )
        endif
        set cyclA = cyclA + 1
    endloop
    set caster = null
endfunction

//===========================================================================
function InitTrig_Big_Red_Button takes nothing returns nothing
    set gg_trg_Big_Red_Button = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Big_Red_Button, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Big_Red_Button, Condition( function Trig_Big_Red_Button_Conditions ) )
    call TriggerAddAction( gg_trg_Big_Red_Button, function Trig_Big_Red_Button_Actions )
endfunction

