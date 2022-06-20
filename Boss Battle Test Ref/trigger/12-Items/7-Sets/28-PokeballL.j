function Trig_PokeballL_Conditions takes nothing returns boolean
    return not( udg_logic[36] ) and GetItemTypeId(GetManipulatedItem()) == 'I03I'
endfunction

function Trig_PokeballL_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local integer k = 0

    if inv( n, 'I03I' ) <= 1 then
        set udg_Caster = n
        call SaveBoolean( udg_hash, GetHandleId( n ), StringHash( "pkbl" ), false )
        call SaveBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ), true )
        
        set udg_Set_Blood_Number[i] = udg_Set_Blood_Number[i] - 3
        set udg_Set_Rune_Number[i] = udg_Set_Rune_Number[i] - 3
        set udg_Set_Moon_Number[i] = udg_Set_Moon_Number[i] - 3
        set udg_Set_Nature_Number[i] = udg_Set_Nature_Number[i] - 3
        set udg_Set_Alchemy_Number[i] = udg_Set_Alchemy_Number[i] - 3
        set udg_Set_Ring_Number[i] = udg_Set_Ring_Number[i] - 3
        set udg_Set_Cristall_Number[i] = udg_Set_Cristall_Number[i] - 3
        
        call iconoff( i, "Мехатрон" )
        
        if udg_Set_Blood_Number[i] < 3 or k >= 3 then
            call TriggerExecute( gg_trg_BloodL )
            call UnitRemoveAbility( n, 'A03T' )
            call UnitRemoveAbility( n, 'B08U' )
        else
            call iconon( i,  "Кровь", "war3mapImported\\PASSpell_DeathKnight_BloodBoil.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Rune_Number[i] < 3 or k >= 3  then
            call TriggerExecute( gg_trg_RuneL )
        else
            call iconon( i,  "Руна", "ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Moon_Number[i] < 3 or k >= 3  then
            call TriggerExecute( gg_trg_MoonL )
            call UnitRemoveAbility( n, 'A04C' )
            call UnitRemoveAbility( n, 'B08W' )
        else
            call iconon( i,  "Луна", "ReplaceableTextures\\PassiveButtons\\PASBTNElunesBlessing.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Nature_Number[i] < 3 or k >= 3 then
            call TriggerExecute( gg_trg_NatureL )
        else
            call iconon( i,  "Природа", "war3mapImported\\PASSpell_Nature_ResistNature.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Alchemy_Number[i] < 3 or k >= 3 then
            call TriggerExecute( gg_trg_AlchemyL )
            call UnitRemoveAbility( n, 'A04F' )
            call UnitRemoveAbility( n, 'B08X' )
        else
            call iconon( i,  "Алхимия", "ReplaceableTextures\\PassiveButtons\\PASBTNLiquidFire.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Ring_Number[i] < 3 or k >= 3  then
            call TriggerExecute( gg_trg_RingL )
        else
            call iconon( i, "Кольцо", "war3mapImported\\PASINV_Jewelry_Ring_34.blp" )
            set k = k + 1
        endif
        
        if udg_Set_Cristall_Number[i] < 3 or k >= 3  then
            call TriggerExecute( gg_trg_CristallL )
            call UnitRemoveAbility( n, 'A03Y' )
            call UnitRemoveAbility( n, 'B08V' )
        else
            call iconon( i,  "Кристалл", "war3mapImported\\PASINV_Jewelcrafting_StarOfElune_02.blp" )
            set k = k + 1
        endif
        
        call SaveBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ), false )
        call DisplayTimedTextToPlayer( GetOwningPlayer(n), 0, 0, 5, "|cffffcc00Mechatron Charisard|r is not active!")
    endif
    call TriggerExecute( gg_trg_MechL )

    
    //call AllSetRing( n, 1, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_PokeballL takes nothing returns nothing
    set gg_trg_PokeballL = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PokeballL, EVENT_PLAYER_UNIT_DROP_ITEM )
    call TriggerAddCondition( gg_trg_PokeballL, Condition( function Trig_PokeballL_Conditions ) )
    call TriggerAddAction( gg_trg_PokeballL, function Trig_PokeballL_Actions )
endfunction

