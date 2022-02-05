library SpecialLib

    function NewSpecial takes unit caster, integer spec returns nothing
        local player p = GetOwningPlayer(caster)
        local integer i = GetUnitUserData(caster)
        local integer spold = udg_Ability_Spec[i]

        if spold == 'A1BK' then
            if GetLocalPlayer() == p then
                call BlzFrameSetVisible( dualtext, false )
            endif
        endif
        
        call UnitRemoveAbility( caster, spold )
        set udg_Ability_Spec[i] = spec
        call UnitAddAbility( caster, spec )

        if spec == 'A1BK' then
            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "dualch" ), 3 )
            if GetLocalPlayer() == p then
                call BlzFrameSetText( dualtext, "3" )
            endif
        endif

        if spec != 0 then
            call BlzFrameSetVisible( specframe[i],true)
            call BlzFrameSetTexture( specframe[i], BlzGetAbilityIcon(spec),0, true)
        else
            call BlzFrameSetVisible( specframe[i],false)
        endif

        set caster = null
        set p = null
    endfunction

endlibrary