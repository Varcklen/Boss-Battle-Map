function Trig_PokeballG_Conditions takes nothing returns boolean
    return not( udg_logic[36] ) and GetItemTypeId(GetManipulatedItem()) == 'I03I'
endfunction

function Trig_PokeballG_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(u)//GetPlayerId(GetOwningPlayer(n)) + 1

    if inv( u, 'I03I' ) <= 1 then
        set udg_Caster = u
        call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "pkbl" ), true )
        call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "pkblt" ), true )
        
        
        call TriggerExecute( gg_trg_BloodG )
        call TriggerExecute( gg_trg_RuneG )
        call TriggerExecute( gg_trg_MoonG )
        call TriggerExecute( gg_trg_NatureG )
        call TriggerExecute( gg_trg_AlchemyG )
        call TriggerExecute( gg_trg_RingG )
        call TriggerExecute( gg_trg_CristallG )
        
        set udg_Set_Blood_Number[i] = udg_Set_Blood_Number[i] + 3
        set udg_Set_Rune_Number[i] = udg_Set_Rune_Number[i] + 3
        set udg_Set_Moon_Number[i] = udg_Set_Moon_Number[i] + 3
        set udg_Set_Nature_Number[i] = udg_Set_Nature_Number[i] + 3
        set udg_Set_Alchemy_Number[i] = udg_Set_Alchemy_Number[i] + 3
        set udg_Set_Ring_Number[i] = udg_Set_Ring_Number[i] + 3
        set udg_Set_Cristall_Number[i] = udg_Set_Cristall_Number[i] + 3
        
        call UnitAddAbility( u, 'A03T' )
        call UnitAddAbility( u, 'A04F' )
        call UnitAddAbility( u, 'A03Y' )
        call UnitAddAbility( u, 'A04C' )
        
        call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "pkblt" ), false )
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\Rock Slam.mdx", GetUnitX( u ), GetUnitY( u )) )
        call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer( u ) ) + "|r find |cffffcc00Mechatron Charisard|r!" )
        call iconon( i,  "Мехатрон", "war3mapImported\\PASINV_Misc_DragonKite_01.blp" )
    endif
    call TriggerExecute( gg_trg_MechG )
    
    //call AllSetRing( GetManipulatingUnit(), 1, GetManipulatedItem() )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_PokeballG takes nothing returns nothing
    set gg_trg_PokeballG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PokeballG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_PokeballG, Condition( function Trig_PokeballG_Conditions ) )
    call TriggerAddAction( gg_trg_PokeballG, function Trig_PokeballG_Actions )
endfunction

