function Trig_NecroSubUpgrade_Conditions takes nothing returns boolean
    return IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1])) and inv(udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1], 'I022' ) > 0 and combat( udg_hero[GetPlayerId( GetOwningPlayer(GetKillingUnit()) ) + 1], false, 0 ) and ( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == udg_hero[GetPlayerId( GetOwningPlayer(GetKillingUnit()) ) + 1] )
endfunction

function Trig_NecroSubUpgrade_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1
    local unit u = udg_hero[i]
    local item it = GetItemOfTypeFromUnitBJ( u, 'I022')
    local integer id = GetHandleId( it )
    local integer s = LoadInteger( udg_hash, id, StringHash( "unds" ) ) + 1
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "undslvl" ) )
    
    if lvl < 4 then
        call SaveInteger( udg_hash, id, StringHash( "unds" ), s )

        if s >= 5 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call BlzSetItemIconPath( it, words( u, BlzGetItemDescription(it), "|cFF959697(", ")|r", I2S(lvl+2) + "/5" ) )
            set lvl = lvl + 1
            
            call textst( "|c005050FF Necromancer Pendant Improved!", u, 64, 90, 10, 1.5 )
            call DestroyEffect( AddSpecialEffect("war3mapImported\\SoulRitual.mdx", GetUnitX( u ), GetUnitY( u ) ) )
	    
            call SaveInteger( udg_hash, id, StringHash( "unds" ), 0 )
            call SaveInteger( udg_hash, id, StringHash( "undslvl" ), lvl )
        elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call textst( "|c005050FF " + I2S( s ) + "/5", u, 64, GetRandomReal( 45, 135 ), 10, 2 )
        endif
    endif
    set u = null
    set it = null 
endfunction

//===========================================================================
function InitTrig_NecroSubUpgrade takes nothing returns nothing
    set gg_trg_NecroSubUpgrade = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NecroSubUpgrade, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_NecroSubUpgrade, Condition( function Trig_NecroSubUpgrade_Conditions ) )
    call TriggerAddAction( gg_trg_NecroSubUpgrade, function Trig_NecroSubUpgrade_Actions )
endfunction