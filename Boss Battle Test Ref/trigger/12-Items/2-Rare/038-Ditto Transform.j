scope DittoTransform initializer init
    private function FightEnd_Conditions takes nothing returns boolean
        return udg_fightmod[3] == false
    endfunction

    private function FightEnd takes nothing returns nothing
        local unit caster = udg_FightEnd_Unit
        local item it
        local integer i
        
        set i = 0
        loop
            exitwhen i > 5
            set it = UnitItemInSlot(caster, i)
            if SubString(BlzGetItemExtendedTooltip(it), 0, 15) == "|cFFB20080Ditto" then
                call Inventory_ReplaceItemByNew(caster, it, 'I05H' )
            endif
            set i = i + 1
        endloop
        
        set it = null
        set caster = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightEnd_Real", function FightEnd, function FightEnd_Conditions )
    endfunction
endscope