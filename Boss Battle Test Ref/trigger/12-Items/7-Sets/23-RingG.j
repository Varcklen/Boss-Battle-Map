function Trig_RingG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Ring_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_RingG_Actions takes nothing returns nothing
    local unit u = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(u)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "pkblt" ) )

    if l and inv(u, 'I03I') > 0 then
        set udg_logic[i + 62] = true
        call skillst( i, 1 )
    else
        set udg_Set_Ring_Number[i] = udg_Set_Ring_Number[i] + 1
        if not( udg_logic[i + 62] ) and udg_Set_Ring_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 62] = true
            call skillst( i, 1 )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer( u ) ) + "|r assembled set |cff9001fdRing|r!" )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call iconon( i, "Кольцо", "war3mapImported\\PASINV_Jewelry_Ring_34.blp" )
        endif
    endif
    
    //call AllSetRing( u, 8, GetManipulatedItem() )
    
    set u = null
endfunction

//===========================================================================
function InitTrig_RingG takes nothing returns nothing
    set gg_trg_RingG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RingG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_RingG, Condition( function Trig_RingG_Conditions ) )
    call TriggerAddAction( gg_trg_RingG, function Trig_RingG_Actions )
endfunction

