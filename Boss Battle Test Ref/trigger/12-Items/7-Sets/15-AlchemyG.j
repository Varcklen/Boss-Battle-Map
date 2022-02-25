function Trig_AlchemyG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( AlchemyLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_AlchemyG_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )

    if l and inv(n, 'I03I') > 0 then
        set udg_logic[i + 10] = true
    else
        set udg_Set_Alchemy_Number[i] = udg_Set_Alchemy_Number[i] + 1
        if not( udg_logic[i + 10] ) and udg_Set_Alchemy_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 10] = true
            call UnitAddAbility( n, 'A04F' )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(n)) + "|r assembled set |cfffe9a2eAlchemy|r!" )
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\Sci Teleport.mdx", GetUnitX( n ), GetUnitY( n ) ) )
            call iconon( i,  "Алхимия", "ReplaceableTextures\\PassiveButtons\\PASBTNLiquidFire.blp" )
        endif
    endif
    
    //call AllSetRing( n, 6, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_AlchemyG takes nothing returns nothing
    set gg_trg_AlchemyG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AlchemyG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_AlchemyG, Condition( function Trig_AlchemyG_Conditions ) )
    call TriggerAddAction( gg_trg_AlchemyG, function Trig_AlchemyG_Actions )
endfunction

