function SantaLogic takes item t returns boolean
    local integer cyclA = 1
    local boolean l = false
    
    loop
        exitwhen cyclA > 12
        if t == udg_SantaItem[cyclA] then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    set t = null
    return l
endfunction

function Trig_SantaAdd_Conditions takes nothing returns boolean
    return SantaLogic(GetManipulatedItem())
endfunction

function Trig_SantaAdd_Actions takes nothing returns nothing
    local integer cyclB = 1
    local integer i = GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) )
    local integer j

	    loop
		exitwhen cyclB > 3
		set j = (3*i) + cyclB 
		if udg_SantaItem[j] == GetManipulatedItem() then
			set udg_SantaItem[j] = null
		endif
		set cyclB = cyclB + 1
	    endloop
endfunction

//===========================================================================
function InitTrig_SantaAdd takes nothing returns nothing
    set gg_trg_SantaAdd = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SantaAdd, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_SantaAdd, Condition( function Trig_SantaAdd_Conditions ) )
    call TriggerAddAction( gg_trg_SantaAdd, function Trig_SantaAdd_Actions )
endfunction

