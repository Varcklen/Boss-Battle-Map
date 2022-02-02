function Trig_HomeLeave2_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetEnteringUnit())) + 1
    
    if IsUnitInGroup(GetEnteringUnit(), udg_heroinfo) and udg_logic[43] then
        call SetUnitPosition(GetEnteringUnit(), GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp) )
        call SetUnitFacing(GetEnteringUnit(), 270 )
        call PanCameraToTimedLocForPlayer( GetOwningPlayer(GetEnteringUnit()), GetRectCenter(gg_rct_HeroTp), 0. )
        call DestroyEffect( AddSpecialEffect("Void Teleport Caster.mdx", GetRectCenterX(gg_rct_HeroTp), GetRectCenterY(gg_rct_HeroTp) ) )
    endif
endfunction

//===========================================================================
function InitTrig_HomeLeave2 takes nothing returns nothing
    set gg_trg_HomeLeave2 = CreateTrigger()
    call TriggerRegisterEnterRectSimple( gg_trg_HomeLeave2, gg_rct_BossSpawn )
    call TriggerAddAction( gg_trg_HomeLeave2, function Trig_HomeLeave2_Actions )
endfunction