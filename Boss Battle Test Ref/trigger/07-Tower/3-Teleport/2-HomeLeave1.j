function Trig_HomeLeave1_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1
    
    if IsUnitInGroup(GetEnteringUnit(), udg_heroinfo) then
        call SetUnitPosition(GetEnteringUnit(), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp) )
        call SetUnitFacing(GetEnteringUnit(), 270 )
        call PanCameraToTimedLocForPlayer( GetOwningPlayer(GetEnteringUnit()), GetRectCenter(gg_rct_HeroTp), 0. )
        call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp) ) )
    endif
endfunction

//===========================================================================
function InitTrig_HomeLeave1 takes nothing returns nothing
    set gg_trg_HomeLeave1 = CreateTrigger()
    call TriggerRegisterEnterRectSimple( gg_trg_HomeLeave1, gg_rct_ChoiseLeave1 )
    call TriggerRegisterEnterRectSimple( gg_trg_HomeLeave1, gg_rct_ChoiseLeave2 )
    call TriggerRegisterEnterRectSimple( gg_trg_HomeLeave1, gg_rct_ChoiseLeave3 )
    call TriggerRegisterEnterRectSimple( gg_trg_HomeLeave1, gg_rct_ChoiseLeave4 )
    call TriggerAddAction( gg_trg_HomeLeave1, function Trig_HomeLeave1_Actions )
endfunction