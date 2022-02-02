function Trig_IA_Money_Conditions takes nothing returns boolean
    return GetOwningPlayer(GetDyingUnit()) == Player(10) and GetUnitAbilityLevel( GetDyingUnit(), 'A0CZ' ) > 0 and udg_fightmod[2]
endfunction

function Trig_IA_Money_Actions takes nothing returns nothing
    local integer cyclA = 1
    local real money = 0
    
    loop
        exitwhen cyclA > 6
        if GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[6+cyclA] or GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[cyclA] then
            set money = 1 + ( 2 * cyclA )
            set cyclA = 6
        elseif GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[12+cyclA] then
            set money = 6 + ( 6 * cyclA )
            set cyclA = 6
        elseif GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[18+cyclA] then
            set money = 4 + ( 2 * cyclA )
            set cyclA = 6
        elseif GetUnitTypeId(GetDyingUnit()) == udg_Database_IA_Unit[24+cyclA] then
            set money = 4 + ( 1 * cyclA )
            set cyclA = 6
        endif
        set cyclA = cyclA + 1
    endloop
    if money != 0 then
        if udg_modgood[21] then
            set money = money * 1.1
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState(Player(cyclA - 1)) == PLAYER_SLOT_STATE_PLAYING then
                call moneyst( udg_hero[cyclA], R2I(money) )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
endfunction

//===========================================================================
function InitTrig_IA_Money takes nothing returns nothing
    set gg_trg_IA_Money = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_IA_Money, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_IA_Money, Condition( function Trig_IA_Money_Conditions ) )
    call TriggerAddAction( gg_trg_IA_Money, function Trig_IA_Money_Actions )
endfunction

