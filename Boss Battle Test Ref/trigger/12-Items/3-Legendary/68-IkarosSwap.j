function Trig_IkarosSwap_Conditions takes nothing returns boolean
    return inv( udg_FightStart_Unit, 'I099') > 0
endfunction

function Trig_IkarosSwap_Actions takes nothing returns nothing
    local integer i = 1
    call heroswap()
    
    loop
        exitwhen i > 4
        if GetUnitState( udg_hero[i], UNIT_STATE_LIFE ) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX(udg_hero[i]), GetUnitY(udg_hero[i]) ) )
        endif
        set i = i + 1
    endloop
endfunction

//===========================================================================
function InitTrig_IkarosSwap takes nothing returns nothing
    set gg_trg_IkarosSwap = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_IkarosSwap, "udg_FightStart_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_IkarosSwap, Condition( function Trig_IkarosSwap_Conditions ) )
    call TriggerAddAction( gg_trg_IkarosSwap, function Trig_IkarosSwap_Actions )
endfunction