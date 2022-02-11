library Other

    globals
        private constant integer GLOW_NORMAL = 'A0D8'
        private constant integer GLOW_SMALL = 'A0UI'
        private constant integer GLOW_BIG = 'A062'
    endglobals
    
    private function Refresh takes unit whichUnit, integer skinId returns nothing
        call UnitRemoveAbility(whichUnit, skinId)
        call UnitAddAbility(whichUnit, skinId)
        set whichUnit = null
    endfunction

    function SetUnitSkin takes unit whichUnit, integer skinId returns nothing
        call BlzSetUnitSkin( whichUnit, skinId )
            
        if IsUnitHasAbility(whichUnit, GLOW_NORMAL) then
            call Refresh(whichUnit, GLOW_NORMAL)
        elseif IsUnitHasAbility(whichUnit, GLOW_SMALL) then
            call Refresh(whichUnit, GLOW_SMALL)
        elseif IsUnitHasAbility(whichUnit, GLOW_BIG) then
            call Refresh(whichUnit, GLOW_BIG)
        endif
        
        set whichUnit = null
    endfunction

endlibrary