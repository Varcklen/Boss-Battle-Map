globals
    constant integer GARITHOS_MEDALLION_SPELL_POWER_BONUS = 50
    constant real GARITHOS_MEDALLION_ATTACK_POWER_BONUS = 0.5
endglobals

function Trig_Medallion_of_Garithos_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I069'
endfunction 

function Medallion_of_GarithosCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "mdghu" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "mdgh" ) )
    local boolean active = LoadBoolean( udg_hash, id, StringHash( "mdgh" ) )
    local boolean noSetItems = true
    local integer i 

    if not(UnitHasItem(hero,it)) then
        if active then
            call spdst(hero, -GARITHOS_MEDALLION_SPELL_POWER_BONUS)
        endif
        if inv(hero, 'I069') == 0 then 
            call UnitRemoveAbility(hero, 'A0NZ')
            call UnitRemoveAbility(hero, 'B09X')
        endif
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( hero, UNIT_STATE_LIFE) > 0.405 then
        set i = 1
        loop
            exitwhen i > SETS_COUNT or noSetItems == false
            if SetCount_GetPieces(hero, i) > 0 then
                set noSetItems = false
            endif
            set i = i + 1
        endloop
        
        if noSetItems and active == false then
            call UnitAddAbility(hero, 'A0NZ')
            call spdst(hero, GARITHOS_MEDALLION_SPELL_POWER_BONUS)
            call SaveBoolean( udg_hash, id, StringHash( "mdgh" ), true )
        elseif noSetItems == false and active then
            if inv(hero, 'I069') == 0 then 
                call UnitRemoveAbility(hero, 'A0NZ')
                call UnitRemoveAbility(hero, 'B09X')
            endif
            call spdst(hero, -GARITHOS_MEDALLION_SPELL_POWER_BONUS)
            call SaveBoolean( udg_hash, id, StringHash( "mdgh" ), false )
        endif
    endif
    
    set it = null
    set hero = null
endfunction 

function Trig_Medallion_of_Garithos_Actions takes nothing returns nothing 
	local integer id 
	
    set id = InvokeTimerWithItem( GetManipulatedItem(), "mdgh", 4, true, function Medallion_of_GarithosCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "mdghu" ), GetManipulatingUnit() ) 
endfunction 

//=========================================================================== 
function InitTrig_Medallion_of_Garithos takes nothing returns nothing 
	set gg_trg_Medallion_of_Garithos = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Medallion_of_Garithos, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Medallion_of_Garithos, Condition( function Trig_Medallion_of_Garithos_Conditions ) ) 
	call TriggerAddAction( gg_trg_Medallion_of_Garithos, function Trig_Medallion_of_Garithos_Actions )
endfunction