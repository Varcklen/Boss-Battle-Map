function Trig_CristallG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( CristallLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_CristallG_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    
    if l and inv(n, 'I03I') > 0 then
        set udg_logic[i + 80] = true
    else
        set udg_Set_Cristall_Number[i] = udg_Set_Cristall_Number[i] + 1
        if not( udg_logic[i + 80] ) and udg_Set_Cristall_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 80] = true
            call UnitAddAbility( n, 'A03Y' )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5., udg_Player_Color[i] + ( GetPlayerName(GetOwningPlayer(n)) + "|r assembled set |cff00cceeCrystal|r!" ) )
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\WhiteChakraExplosion.mdx", GetUnitX( n ), GetUnitY( n ) ) )
            call iconon( i,  "Кристалл", "war3mapImported\\PASINV_Jewelcrafting_StarOfElune_02.blp" )
        endif
    endif
    
    //call AllSetRing( n, 9, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_CristallG takes nothing returns nothing
    set gg_trg_CristallG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CristallG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_CristallG, Condition( function Trig_CristallG_Conditions ) )
    call TriggerAddAction( gg_trg_CristallG, function Trig_CristallG_Actions )
endfunction

