library DealDamageLib

    function UnitTakeDamage takes unit dealer, unit target, real damage, damagetype damageType returns nothing
        local attacktype attackType = ATTACK_TYPE_HERO
        
        if damageType == DAMAGE_TYPE_MAGIC then
            set attackType = ATTACK_TYPE_NORMAL
        endif

        call UnitDamageTarget( dealer, target, damage, true, false, attackType, damageType, WEAPON_TYPE_WHOKNOWS)
            
        set attackType = null
        set dealer = null
        set target = null
    endfunction

endlibrary