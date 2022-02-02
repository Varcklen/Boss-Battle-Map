library SpecialEffect

    globals
        private effect Effect = null
    endglobals

    function AddSpecialEffectToUnit takes string myEffect, unit myUnit returns effect
        set Effect = AddSpecialEffect( myEffect, GetUnitX( myUnit ), GetUnitY( myUnit ) )
        return Effect
    endfunction
    
    function PlaySpecialEffect takes string myEffect, unit myUnit returns nothing
        call DestroyEffect( AddSpecialEffect( myEffect, GetUnitX( myUnit ), GetUnitY( myUnit ) ) )
    endfunction
    
endlibrary