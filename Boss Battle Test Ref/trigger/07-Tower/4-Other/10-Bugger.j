function Trig_Bugger_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSellingUnit()) == 'n05B'
endfunction
//GetBuyingUnit()
function Trig_Bugger_Actions takes nothing returns nothing
    local unit u = GetBuyingUnit()
    local integer i = GetPlayerId( GetOwningPlayer( u ) ) + 1
    
    call DestroyEffect(AddSpecialEffect( "UI\\Feedback\\GoldCredit\\GoldCredit.mdl", GetUnitX( GetSellingUnit() ), GetUnitY( GetSellingUnit() ) ))
    
    if luckylogic( u, 1, 1, 100 ) then
        set bj_lastCreatedItem = CreateItem( 'I0F8', GetUnitX(GetSellingUnit())+GetRandomReal(-300, 300 ), GetUnitY(GetSellingUnit())+GetRandomReal(-300, 300 ))
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        call DestroyEffect(AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( GetSellingUnit() ), GetUnitY( GetSellingUnit() ) ))
        call RemoveUnit(GetSellingUnit())
    elseif luckylogic( u, 5, 1, 100 ) then
        set bj_lastCreatedItem = CreateItem( udg_Database_Item_Potion[GetRandomInt(1,udg_Database_NumberItems[9])], GetUnitX(GetSellingUnit())+GetRandomReal(-300, 300 ), GetUnitY(GetSellingUnit())+GetRandomReal(-300, 300 ))
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        call IssueImmediateOrder( GetSellingUnit(), "stop" )
        call SetUnitAnimation( GetSellingUnit(), "spell" )
        call QueueUnitAnimation( GetSellingUnit(), "stand" )
    elseif luckylogic( u, 2, 1, 100 ) then
        set bj_lastCreatedItem = CreateItem( DB_Items[1][GetRandomInt(1,udg_Database_NumberItems[1])], GetUnitX(GetSellingUnit())+GetRandomReal(-300, 300 ), GetUnitY(GetSellingUnit())+GetRandomReal(-300, 300 ))
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        call IssueImmediateOrder( GetSellingUnit(), "stop" )
        call SetUnitAnimation( GetSellingUnit(), "spell" )
        call QueueUnitAnimation( GetSellingUnit(), "stand" )
    elseif luckylogic( u, 10, 1, 100 ) then
        set bj_lastCreatedItem = CreateItem( 'III4', GetUnitX(GetSellingUnit())+GetRandomReal(-300, 300 ), GetUnitY(GetSellingUnit())+GetRandomReal(-300, 300 ))
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
        call IssueImmediateOrder( GetSellingUnit(), "stop" )
        call SetUnitAnimation( GetSellingUnit(), "spell" )
        call QueueUnitAnimation( GetSellingUnit(), "stand" )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Bugger takes nothing returns nothing
    set gg_trg_Bugger = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bugger, EVENT_PLAYER_UNIT_SELL_ITEM )
    call TriggerAddCondition( gg_trg_Bugger, Condition( function Trig_Bugger_Conditions ) )
    call TriggerAddAction( gg_trg_Bugger, function Trig_Bugger_Actions )
endfunction

