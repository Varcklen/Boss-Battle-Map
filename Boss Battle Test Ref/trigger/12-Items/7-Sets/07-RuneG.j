function Trig_RuneG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( RuneLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_RuneG_Actions takes nothing returns nothing
    local unit u
    local unit n = GetManipulatingUnit()
    local integer i = CorrectPlayer(n)
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean b = false
    
    if l and inv(n, 'I03I') > 0 then
        set udg_logic[i + 26] = true
        set b = true
        set u = udg_Caster
    else
        set u = n
        set udg_Set_Rune_Number[i] = udg_Set_Rune_Number[i] + 1
        if not( udg_logic[i + 26 ] ) and udg_Set_Rune_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 26] = true
            set b = true
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(u)) + "|r assembled set |cff848484Rune|r!" )     
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\Rock Slam.mdx", GetUnitX( u ), GetUnitY( u )) )
            call iconon( i,  "Руна", "ReplaceableTextures\\PassiveButtons\\PASBTNResistantSkin.blp" )
        endif
    endif
    if b then
        set udg_Event_RuneSetAdd_Hero = u
        set udg_Event_RuneSetAdd_Item = GetManipulatedItem()
        
        set udg_Event_RuneSetAdd_Real = 0.00
        set udg_Event_RuneSetAdd_Real = 1.00
        set udg_Event_RuneSetAdd_Real = 0.00
        
        call UnitRemoveAbility( u, 'A0ZA' )
        call UnitRemoveAbility( u, 'A0Z1' )
        call UnitRemoveAbility( u, 'A0YZ' )
        call UnitRemoveAbility( u, 'A0CB' )
        call UnitRemoveAbility( u, 'A0Z3' )
        call UnitRemoveAbility( u, 'A0Z8' )
        call UnitRemoveAbility( u, 'A0OU' )
        call UnitRemoveAbility( u, 'A0L9' )
        call UnitRemoveAbility( u, 'A0M9' )
    endif
    
    //call AllSetRing( n, 3, GetManipulatedItem() )
    
    set u = null
    set n = null
endfunction

//===========================================================================
function InitTrig_RuneG takes nothing returns nothing
    set gg_trg_RuneG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_RuneG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_RuneG, Condition( function Trig_RuneG_Conditions ) )
    call TriggerAddAction( gg_trg_RuneG, function Trig_RuneG_Actions )
endfunction

