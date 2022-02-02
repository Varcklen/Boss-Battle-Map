function Trig_Fool_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0CB'
endfunction

function Trig_Fool_Actions takes nothing returns nothing
    local integer rand = GetRandomInt( 1, 10 )
    local integer cyclA = 1
    local item it

    if GetLocalPlayer() == GetOwningPlayer(GetManipulatingUnit()) then
    	call StartSound(gg_snd_SargerasLaugh)
    endif
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    call stazisst( GetManipulatingUnit(), GetManipulatedItem() )

    if rand == 1 then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 10, "Nothing has happened." )
    elseif rand == 2 then
        call moneyst( GetManipulatingUnit(), 1000 )
    elseif rand == 3 then
    	call UnitAddItem( GetManipulatingUnit(), CreateItem('I05J', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()) ) )
    elseif rand == 4 then
        call UnitAddItem( GetManipulatingUnit(), CreateItem(udg_Database_Item_Potion[GetRandomInt( 1, udg_Database_NumberItems[9] )], GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()) ) )
    elseif rand == 5 then
	set cyclA = 1
    	loop
        	exitwhen cyclA > 6
        	if UnitInventoryCount(GetManipulatingUnit()) < 6 then
            		call ItemRandomizer( GetManipulatingUnit(), "rare" )
        	else
            		set cyclA = 6
        	endif
        	set cyclA = cyclA + 1
    	endloop
    elseif rand == 6 then
    	call UnitAddItem( GetManipulatingUnit(), CreateItem('I0CB', GetUnitX(GetManipulatingUnit()), GetUnitY(GetManipulatingUnit()) ) )
    elseif rand == 7 then
        call luckyst( GetManipulatingUnit(), 20 )
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 10, "You are lucky!" )
    elseif rand == 8 then
        call spdst( GetManipulatingUnit(), -20 )
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 10, "You are unlucky! -20% spell damage." )
    elseif rand == 9 then
    	call SetHeroLevel( GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 1, true)
    elseif rand == 10 then
        call DisplayTimedTextToPlayer( GetOwningPlayer(GetManipulatingUnit()), 0, 0, 10, "Chameleon power!" )
	    set cyclA = 0
    loop
        exitwhen cyclA > 5
        set it = UnitItemInSlot(GetManipulatingUnit(), cyclA)
            if it != null then
                call BlzSetItemIconPath( it, "|cff00cceeChameleon|r|n" + BlzGetItemDescription(it) )
                call BlzSetItemDescription( it, "|cff00cceeChameleon|r|n" + BlzGetItemDescription(it) )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    set it = null
endfunction

//===========================================================================
function InitTrig_Fool takes nothing returns nothing
    set gg_trg_Fool = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fool, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Fool, Condition( function Trig_Fool_Conditions ) )
    call TriggerAddAction( gg_trg_Fool, function Trig_Fool_Actions )
endfunction

