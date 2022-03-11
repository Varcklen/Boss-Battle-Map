function Trig_AL_Money_Conditions takes nothing returns boolean
    return GetOwningPlayer(GetDyingUnit()) == Player(10) and IsUnitInGroup(GetDyingUnit(), udg_Bosses) and udg_fightmod[4]
endfunction

function Trig_AL_Money_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer counter 
    local real money = udg_number[9]
    
    call GroupRemoveUnit(udg_Bosses, GetDyingUnit())
    if GetUnitTypeId(GetDyingUnit()) != 'h01D' and GetUnitTypeId(GetDyingUnit()) != 'h01J' and GetUnitTypeId(GetDyingUnit()) != 'h01I' and GetUnitTypeId(GetDyingUnit()) != 'h009' and GetUnitTypeId(GetDyingUnit()) != 'n01V' and GetUnitTypeId(GetDyingUnit()) != 'n01W' and GetUnitTypeId(GetDyingUnit()) != 'h01H' and GetUnitTypeId(GetDyingUnit()) != 'h005' and GetUnitTypeId(GetDyingUnit()) != 'h013' and GetUnitTypeId(GetDyingUnit()) != 'n01U' and GetUnitTypeId(GetDyingUnit()) != 'h00C' then
        set udg_number[9] = udg_number[9] + 10
	if udg_number[9] > 150 then
            set udg_number[9] = 150
        endif
	if udg_modgood[21] then
            set money = money * 1.1
        endif
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
function InitTrig_AL_Money takes nothing returns nothing
    set gg_trg_AL_Money = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AL_Money, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_AL_Money, Condition( function Trig_AL_Money_Conditions ) )
    call TriggerAddAction( gg_trg_AL_Money, function Trig_AL_Money_Actions )
endfunction

