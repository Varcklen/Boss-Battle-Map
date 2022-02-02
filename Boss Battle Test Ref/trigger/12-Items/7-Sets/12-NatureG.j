function Trig_NatureG_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( NatureLogic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function NatureCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    
    call DestroyEffect( LoadEffectHandle( udg_hash, id, StringHash( "ntrr" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_NatureG_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()//udg_hero[GetPlayerId(GetOwningPlayer(GetManipulatingUnit())) + 1]
    local integer i = CorrectPlayer(n)//GetPlayerId(GetOwningPlayer(n)) + 1
    local boolean l = LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "pkblt" ) )
    local boolean b = false
    local integer cyclA = 0
    local integer f = 0

    if inv( n, 'I0BT' ) > 0 then
        loop
            exitwhen cyclA > 5
            if NatureLogic( UnitItemInSlot(n, cyclA)) then
                set f = f + 1
            endif
            set cyclA = cyclA + 1
        endloop
        if f >= 6 and not(LoadBoolean( udg_hash, GetHandleId( n ), StringHash( "strz" ) ) ) then
            call SaveBoolean( udg_hash, GetHandleId( n ), StringHash( "strz" ), true )
            call RessurectionPoints( 4, true )
        endif
    endif

    if l and inv(n, 'I03I') > 0 then
        set udg_logic[i + 22] = true
        set b = true
    else
        set udg_Set_Nature_Number[i] = udg_Set_Nature_Number[i] + 1
        if not( udg_logic[i + 22] ) and udg_Set_Nature_Number[i] >= 3 and Multiboard_Condition(i) then
            set udg_logic[i + 22] = true
            set b = true
            call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5., udg_Player_Color[i] + GetPlayerName(GetOwningPlayer(n)) + "|r assembled set |cff7cfc00Nature|r!" )
            call spectime( "Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl", GetUnitX(n), GetUnitY(n), 2.5 )
            call iconon( i,  "Природа", "war3mapImported\\PASSpell_Nature_ResistNature.blp" )
        endif
    endif
    if b then
        call RessurectionPoints( 2, true )
    endif
    
    //call AllSetRing( n, 5, GetManipulatedItem() )
    
    set n = null
endfunction

//===========================================================================
function InitTrig_NatureG takes nothing returns nothing
    set gg_trg_NatureG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NatureG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_NatureG, Condition( function Trig_NatureG_Conditions ) )
    call TriggerAddAction( gg_trg_NatureG, function Trig_NatureG_Actions )
endfunction

