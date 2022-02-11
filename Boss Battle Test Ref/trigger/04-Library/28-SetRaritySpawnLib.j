library SetRaritySpawnLib

    function SetRaritySpawn takes integer leg, integer rar returns nothing
        set udg_RarityChance[3] = leg
        set udg_RarityChance[2] = rar
        set udg_RarityChance[1] = IMaxBJ(0,100-(udg_RarityChance[3]+udg_RarityChance[2]))
    endfunction

endlibrary