function Trig_BloodG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( BloodLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Multiboard_Condition takes integer i returns boolean
    return udg_Multiboard_Sets[( udg_Multiboard_Position[i] * 3 )] == "" or udg_Multiboard_Sets[( udg_Multiboard_Position[i] * 3 ) - 1] == "" or udg_Multiboard_Sets[( udg_Multiboard_Position[i] * 3 ) - 2] == ""
endfunction

function Trig_BloodG_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    
    if l and inv(n, 'I03I') > 0 then
        set udg_logic[i + 14] = true
    else
        set udg_Set_Blood_Number[i] = udg_Set_Blood_Number[i] + 1
        if not( udg_logic[i + 14] ) and udg_Set_Blood_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 14] = true
            call UnitAddAbility( n, 'A03T' )
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5., ( udg_Player_Color[i] + ( GetPlayerName(GetOwningPlayer(n)) + "|r assembled set |cffb40431Blood|r!" ) ) )
            call DestroyEffect( AddSpecialEffect( "Blood Explosion.mdx", GetUnitX( n ), GetUnitY( n ) ) )
            call iconon( i, "Кровь", "war3mapImported\\PASSpell_DeathKnight_BloodBoil.blp" )
        endif
    endif
    
    //call AllSetRing( n, 2, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_BloodG takes nothing returns nothing
    set gg_trg_BloodG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BloodG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_BloodG, Condition( function Trig_BloodG_Conditions ) )
    call TriggerAddAction( gg_trg_BloodG, function Trig_BloodG_Actions )
endfunction

