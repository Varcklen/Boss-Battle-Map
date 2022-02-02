function Trig_Perfect_Gift_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I07I'
endfunction

function Trig_Perfect_Gift_Actions takes nothing returns nothing
    local unit caster = GetManipulatingUnit()
    local integer i
    local integer k
	local integer array it
    local integer setItem = 1
    local integer array setList
    local integer setListMax = 0
    local integer max = 0
    local integer currentSetCount
    local integer rand
    
    set i = 1
    loop
        exitwhen i > SETS_COUNT
        set setList[i] = 0
        set i = i + 1
    endloop
    
    set i = 1
    loop
        exitwhen i > SETS_COUNT
        set currentSetCount = SetCount_GetPieces(caster, i)
        if currentSetCount >= max and currentSetCount > 0 then
            if currentSetCount == max then
                //Если выбранный сет равен другому по силе, добавляет его в список к другому
                set k = 1
                loop
                    exitwhen k > SETS_COUNT
                    if setList[k] == 0 then
                        set setList[k] = i
                        set k = SETS_COUNT
                        set setListMax = setListMax + 1
                    endif
                    set k = k + 1
                endloop
            else
                //Делает выбранный сет доминирующим
                set k = 1
                loop
                    exitwhen k > setListMax
                    set setList[k] = 0
                    set k = k + 1
                endloop
                set setList[1] = i
                set setListMax = 1
            endif
            set max = currentSetCount
        endif
        set i = i + 1
    endloop

    set i = 2
	set it[0] = 0
	set it[1] = 0
	loop
		exitwhen i > 4
        //Если нет доминирующего сета, выбирает из случайных сетов
        if setListMax == 0 then
            set rand = GetRandomInt(1,SETS_COUNT)
        else
            set rand = setList[GetRandomInt(1,setListMax)]
        endif
        set it[i] = DB_SetItems[rand][GetRandomInt( 1, udg_DB_SetItems_Num[rand] )]
		if (it[i] == it[i-1] or it[i] == it[i-2]) then
			set i = i - 1
		endif
		set i = i + 1
	endloop
	call forge( caster, GetManipulatedItem(), it[4], it[2], it[3], true )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Perfect_Gift takes nothing returns nothing
    set gg_trg_Perfect_Gift = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Perfect_Gift, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Perfect_Gift, Condition( function Trig_Perfect_Gift_Conditions ) )
    call TriggerAddAction( gg_trg_Perfect_Gift, function Trig_Perfect_Gift_Actions )
endfunction

