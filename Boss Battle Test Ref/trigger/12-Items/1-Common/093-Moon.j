function Trig_Moon_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0C1'
endfunction

function Trig_Moon_Actions takes nothing returns nothing
    local integer cyclA = 1
    local unit u = GetManipulatingUnit()
    
    call stazisst( u, GetItemOfTypeFromUnitBJ( u, 'I0C1') )
    loop
        exitwhen cyclA > 6
        if UnitInventoryCount(u) < 6 then
            call ItemRandomizer( u, "rare" )
            call BlzSetItemIconPath( bj_lastCreatedItem, "|cffC71585Cursed|r|n" + BlzGetItemExtendedTooltip(bj_lastCreatedItem) )
        else
            set cyclA = 6
        endif
        set cyclA = cyclA + 1
    endloop
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetManipulatingUnit(), "origin" ) )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Moon takes nothing returns nothing
    set gg_trg_Moon = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Moon, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Moon, Condition( function Trig_Moon_Conditions ) )
    call TriggerAddAction( gg_trg_Moon, function Trig_Moon_Actions )
endfunction
