function Trig_Ikaros_Mudstone_Conditions takes nothing returns boolean
    return inv( udg_FightStart_Unit, 'I03H') > 0 and not(udg_fightmod[3])
endfunction

function Trig_Ikaros_Mudstone_Actions takes nothing returns nothing
    local integer i = 1
    loop
        exitwhen i > 4
        if udg_hero[i] != null then
            call DestroyEffect( AddSpecialEffectTarget( "war3mapImported\\Rock Slam.mdx", udg_hero[i], "origin") )
            if BlzGetUnitIntegerField(udg_hero[i],UNIT_IF_PRIMARY_ATTRIBUTE) == 1 then
                call statst( udg_hero[i], 3, 0, 0, 0, true )
            elseif BlzGetUnitIntegerField(udg_hero[i],UNIT_IF_PRIMARY_ATTRIBUTE) == 2  then
                call statst( udg_hero[i], 0, 0, 3, 0, true )
            elseif BlzGetUnitIntegerField(udg_hero[i],UNIT_IF_PRIMARY_ATTRIBUTE) == 3  then
                call statst( udg_hero[i], 0, 3, 0, 0, true )
            endif
        endif
        set i = i + 1
    endloop
endfunction

//===========================================================================
function InitTrig_Ikaros_Mudstone takes nothing returns nothing
    set gg_trg_Ikaros_Mudstone = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Ikaros_Mudstone, "udg_FightStart_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Ikaros_Mudstone, Condition( function Trig_Ikaros_Mudstone_Conditions ) )
    call TriggerAddAction( gg_trg_Ikaros_Mudstone, function Trig_Ikaros_Mudstone_Actions )
endfunction