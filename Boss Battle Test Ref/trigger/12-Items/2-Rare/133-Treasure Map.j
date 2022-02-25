function Trig_Treasure_Map_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I01I'
endfunction

function Trig_Treasure_Map_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer( GetManipulatingUnit() ) ) + 1
    local integer cyclA
    local integer cyclAEnd
    local integer array count
    local integer rand
    
    set cyclA = 1
    loop
        exitwhen cyclA > 6
        set count[cyclA] = 0
        set cyclA = cyclA + 1
    endloop
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    
    set cyclA = 1
    set cyclAEnd = udg_CorruptedUsed[i]
    loop
        exitwhen cyclA > cyclAEnd
        set rand = GetRandomInt(1, 6)
        if rand == 1 then
            set count[1] = count[1] + 1
        elseif rand == 2 then
            set count[2] = count[2] + 1
        elseif rand == 3 then
            set count[3] = count[3] + 1
        elseif rand == 4 then
            set count[4] = count[4] + 1
        elseif rand == 5 then
            set count[5] = count[5] + 1
        elseif rand == 6 then
            set count[6] = count[6] + 1
        endif
        set cyclA = cyclA + 1
    endloop
    
    if count[1] > 0 then
        call statst( GetManipulatingUnit(), 0, count[1], 0, 0, true )
        call textst( "|c0020FF20 +"+I2S(count[1])+" agility", GetManipulatingUnit(), 64, 60, 10, 3 )
    endif
	if count[2] > 0 then
		call luckyst( GetManipulatingUnit(), count[2] )
        call textst( "|cFFFE8A0E +"+I2S(count[2])+" luck", GetManipulatingUnit(), 64, 120, 10, 3 )
    endif
	if count[3] > 0 then
		call spdst( GetManipulatingUnit(), 0.25*count[3] )
        call textst( "|cFF7EBFF1 +"+R2SW( 0.25*count[3], 1, 2 )+udg_perc+" spell power", GetManipulatingUnit(), 64, 180, 10, 3 )
    endif
	if count[4] > 0 then
		call moneyst( GetManipulatingUnit(), 20*count[4] )
        call textst( "|cFFFFFC01 +"+I2S(20*count[4])+" gold", GetManipulatingUnit(), 64, 240, 10, 3 )
	endif
    if count[5] > 0 then
		call statst( GetManipulatingUnit(), count[5], 0, 0, 0, true )
        call textst( "|c00FF2020 +"+I2S(count[5])+" strength", GetManipulatingUnit(), 64, 300, 10, 3 )
	endif
    if count[6] > 0 then
		call statst( GetManipulatingUnit(), 0, 0, count[6], 0, true )
        call textst( "|c002020FF +"+I2S(count[6])+" intelligence", GetManipulatingUnit(), 64, 0, 10, 3 )
	endif
    
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )
endfunction

//===========================================================================
function InitTrig_Treasure_Map takes nothing returns nothing
    set gg_trg_Treasure_Map = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Treasure_Map, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Treasure_Map, Condition( function Trig_Treasure_Map_Conditions ) )
    call TriggerAddAction( gg_trg_Treasure_Map, function Trig_Treasure_Map_Actions )
endfunction

