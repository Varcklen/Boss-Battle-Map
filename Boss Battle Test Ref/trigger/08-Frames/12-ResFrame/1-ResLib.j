library ResLib

function RessurectionPoints takes integer i, boolean l returns nothing
    set udg_Heroes_Ressurect_Battle = udg_Heroes_Ressurect_Battle + i

    if udg_Heroes_Ressurect_Battle < 0 then
        set udg_Heroes_Ressurect_Battle = 0
    endif
    
    if udg_fightmod[0] then
        call BlzFrameSetVisible( resback, true )
        call BlzFrameSetText( restext, I2S(udg_Heroes_Ressurect_Battle) )
    endif

    if l then
        set udg_Heroes_Ressurect = udg_Heroes_Ressurect + i
        if udg_Heroes_Ressurect < 0 then
            set udg_Heroes_Ressurect = 0
        endif
        call MultiSetValue( udg_multi, 2, 2, I2S(udg_Heroes_Ressurect) )
    endif
endfunction

endlibrary