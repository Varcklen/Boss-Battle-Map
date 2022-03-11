library AllSetRingLib requires InvLib, TextLib

function AllSetRing takes unit u, integer k, item g returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(u)) + 1

    if GetUnitAbilityLevel( u, 'A0ZK') > 0 then
        if udg_Set_Alchemy_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[1], BlzGetAbilityIcon( udg_DB_SoulContract_Set[1]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Blood_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[2], BlzGetAbilityIcon( udg_DB_SoulContract_Set[2]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[2], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Cristall_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[3], BlzGetAbilityIcon( udg_DB_SoulContract_Set[3]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[3], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Mech_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[4], BlzGetAbilityIcon( udg_DB_SoulContract_Set[4]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[4], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Moon_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[5], BlzGetAbilityIcon( udg_DB_SoulContract_Set[5]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[5], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Nature_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[6], BlzGetAbilityIcon( udg_DB_SoulContract_Set[6]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[6], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Ring_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[7], BlzGetAbilityIcon( udg_DB_SoulContract_Set[7]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[7], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Rune_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[8], BlzGetAbilityIcon( udg_DB_SoulContract_Set[8]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[8], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        if udg_Set_Weapon_Number[i] > 0 then
            call BlzFrameSetTexture( mephicon[9], BlzGetAbilityIcon( udg_DB_SoulContract_Set[9]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[9], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
    endif
endfunction

endlibrary