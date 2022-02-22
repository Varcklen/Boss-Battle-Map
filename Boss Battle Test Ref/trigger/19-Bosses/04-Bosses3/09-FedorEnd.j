scope FedorEnd initializer init

    globals
        private constant integer ID_TRAIN = 'h00C'
    endglobals

    function FightEndGlobal takes nothing returns nothing
        local group g = CreateGroup()
        local unit u
        
        call GroupEnumUnitsInRect( g, udg_Boss_Rect, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if GetUnitTypeId( u ) == ID_TRAIN then
                call KillUnit( u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_FightEndGlobal_Real", function FightEndGlobal, null )
    endfunction
endscope