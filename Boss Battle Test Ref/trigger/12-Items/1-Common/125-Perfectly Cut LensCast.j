function Trig_Perfectly_Cut_LensCast_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0BL'
endfunction

function Trig_Perfectly_Cut_LensCast_Actions takes nothing returns nothing
    local unit caster
    local real x
    local real y
    local real area
    local real dmg
    local integer arm
    local integer i
    local integer iEnd
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A0BL'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif

    set arm = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "pcln" ) )
    set dmg = RMaxBJ(100, arm)
    set area = RMaxBJ(100, arm)

    set i = 1
    set iEnd = eyest(caster)
    loop
        exitwhen i > iEnd
        call GroupAoE( caster, null, x, y, dmg, area, "enemy", "", "Blink Blue Target.mdx" )
        set i = i + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Perfectly_Cut_LensCast takes nothing returns nothing
    set gg_trg_Perfectly_Cut_LensCast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Perfectly_Cut_LensCast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Perfectly_Cut_LensCast, Condition( function Trig_Perfectly_Cut_LensCast_Conditions ) )
    call TriggerAddAction( gg_trg_Perfectly_Cut_LensCast, function Trig_Perfectly_Cut_LensCast_Actions )
endfunction

