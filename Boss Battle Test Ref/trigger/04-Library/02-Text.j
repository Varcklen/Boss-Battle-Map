library TextLib

    function textst takes string inf, unit caster, real speed, real angle, real size, real life returns nothing
        local texttag txt = CreateTextTag()
        local real sp = ( speed * 0.071 / 128 ) * Cos( angle * 0.0174 )
        local real an = ( speed * 0.071 / 128 ) * Sin( angle * 0.0174 )
        local real pos = 0
        
        if udg_logic[32] then
            set udg_logic[32] = false
            set pos = -100
        endif
        
        call SetTextTagText( txt, inf, size * 0.023 / 10 ) 
        call SetTextTagPosUnit( txt, caster, pos ) 
        call SetTextTagColor( txt, 225, 225, 225, 225 ) 
        call SetTextTagVelocity( txt, sp , an )
        call SetTextTagFadepoint( txt, life ) 
        call SetTextTagLifespan( txt, life + 0.5 ) 
        call SetTextTagPermanent( txt, false )
        
        set txt = null
        set caster = null
    endfunction

endlibrary