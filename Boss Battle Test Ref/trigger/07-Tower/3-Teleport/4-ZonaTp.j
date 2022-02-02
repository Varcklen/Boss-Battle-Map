function Trig_ZonaTp_Conditions takes nothing returns boolean
    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO) or GetUnitTypeId(GetEnteringUnit()) == 'n01Z' or GetUnitTypeId(GetEnteringUnit()) == 'n059'
endfunction

function Trig_ZonaTp_Actions takes nothing returns nothing
    local integer id
    local rect array r
    local integer cyclA = 1
    local integer i = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1
    local real x
    local real y

    set r[1] = gg_rct_Zona1
    set r[2] = gg_rct_Zona2
    set r[3] = gg_rct_Zona3
    set r[4] = gg_rct_Zona4

    set x = GetLocationX(GetRectCenter(r[i]))
    set y = GetLocationY(GetRectCenter(r[i]))
    
    loop
        exitwhen cyclA > 4
        if RectContainsCoords( r[cyclA], GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit()) ) and GetOwningPlayer(GetEnteringUnit()) != Player( cyclA - 1 ) then
            if GetUnitTypeId(GetEnteringUnit()) == 'n01Z' or GetUnitTypeId(GetEnteringUnit()) == 'n059' then
                call KillUnit( GetEnteringUnit() )
            else
                call SetUnitPosition( GetEnteringUnit(), x, y )
		call PanCameraToTimedLocForPlayer( GetOwningPlayer(GetEnteringUnit()), GetUnitLoc(GetEnteringUnit()), 0 )
                call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit()) ) )
            endif
            set cyclA = 4
        endif
        set r[cyclA] = null
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_ZonaTp takes nothing returns nothing
    set gg_trg_ZonaTp = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona1 )
    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona2 )
    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona3 )
    call TriggerRegisterEnterRectSimple( gg_trg_ZonaTp, gg_rct_Zona4 )
    call TriggerAddCondition( gg_trg_ZonaTp, Condition( function Trig_ZonaTp_Conditions ) )
    call TriggerAddAction( gg_trg_ZonaTp, function Trig_ZonaTp_Actions )
endfunction