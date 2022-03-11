function Trig_Library_Card_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSellingUnit()) == 'h007' and inv( GetBuyingUnit(), 'I0E2' ) > 0
endfunction

function Trig_Library_Card_Actions takes nothing returns nothing
    local integer rand
    local item it = GetItemOfTypeFromUnitBJ( GetBuyingUnit(), 'I0E2')
	local integer id = GetHandleId( it )
    local integer s = LoadInteger( udg_hash, id, StringHash( "libc" ) ) + 1

    if s >= 4 then
        call SaveInteger( udg_hash, id, StringHash( "libc" ), 0 )
        set rand = GetRandomInt( 1,4 )
        if rand == 1 then
            set rand = GetRandomInt( 1,3 )
            if rand == 1 then
                call statst( GetBuyingUnit(), 1, 0, 0, 0, true )
                call textst( "|c00FF2020 +1 strength", GetBuyingUnit(), 64, 90, 10, 1 )
            elseif rand == 2 then
                call statst( GetBuyingUnit(), 0, 1, 0, 0, true )
                call textst( "|c0020FF20 +1 agility", GetBuyingUnit(), 64, 90, 10, 1 )
            elseif rand == 3 then
                call statst( GetBuyingUnit(), 0, 0, 1, 0, true )
                call textst( "|c002020FF +1 intelligence", GetBuyingUnit(), 64, 90, 10, 1 )
            endif
        elseif rand == 2 then
            call luckyst( GetBuyingUnit(), 1 )
            call textst( "|cFFFE8A0E +1 luck", GetBuyingUnit(), 64, 90, 10, 1 )
        elseif rand == 3 then
            call spdst( GetBuyingUnit(), 0.5 )
            call textst( "|cFF7EBFF1 +0.5% spell power", GetBuyingUnit(), 64, 90, 10, 1 )
        elseif rand == 4 then
            call moneyst( GetBuyingUnit(), 50 )
            call textst( "|cFFFFFC01 +50 gold", GetBuyingUnit(), 64, 90, 10, 1 )
        endif
    elseif GetUnitState( GetBuyingUnit(), UNIT_STATE_LIFE) > 0.405 then
        call SaveInteger( udg_hash, id, StringHash( "libc" ), s )
        call textst( "|c005050FF " + I2S( s ) + "/4", GetBuyingUnit(), 64, GetRandomReal( 0, 360 ), 7, 1.5 )
    endif
endfunction

//===========================================================================
function InitTrig_Library_Card takes nothing returns nothing
    set gg_trg_Library_Card = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Library_Card, EVENT_PLAYER_UNIT_SELL_ITEM )
    call TriggerAddCondition( gg_trg_Library_Card, Condition( function Trig_Library_Card_Conditions ) )
    call TriggerAddAction( gg_trg_Library_Card, function Trig_Library_Card_Actions )
endfunction

