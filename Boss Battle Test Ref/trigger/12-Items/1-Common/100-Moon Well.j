globals
    constant integer MOON_WELL_MANA_CONDITION_02 = 90
    constant integer MOON_WELL_MANA_CONDITION_03 = 70
    constant integer MOON_WELL_MANA_CONDITION_04 = 50
    constant integer MOON_WELL_MANA_CONDITION_05 = 30
    constant integer MOON_WELL_MANA_CONDITION_06 = 10
endglobals

function Trig_Moon_Well_Conditions takes nothing returns boolean 
	return GetItemTypeId(GetManipulatedItem()) == 'I042'
endfunction 

function Moon_WellCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit hero = LoadUnitHandle( udg_hash, id, StringHash( "mnwlu" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "mnwl" ) )
    local integer currentBonus = 1
    local integer oldBonus = LoadInteger( udg_hash, id, StringHash( "mnwl" ) )
    local real manaPercent = GetUnitManaPercent(hero)
    //local ability itemAbility = BlzGetItemAbility( it, 'A0MM' )
    
    if not(UnitHasItem(hero,it)) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( hero, UNIT_STATE_LIFE) > 0.405 then
        if manaPercent <= MOON_WELL_MANA_CONDITION_06 then
            set currentBonus = 6
        elseif manaPercent <= MOON_WELL_MANA_CONDITION_05 then
            set currentBonus = 5
        elseif manaPercent <= MOON_WELL_MANA_CONDITION_04 then
            set currentBonus = 4
        elseif manaPercent <= MOON_WELL_MANA_CONDITION_03 then
            set currentBonus = 3
        elseif manaPercent <= MOON_WELL_MANA_CONDITION_02 then
            set currentBonus = 2
        else
            set currentBonus = 1
        endif
        
        if oldBonus != currentBonus then
            call SaveInteger( udg_hash, id, StringHash( "mnwl" ), currentBonus )
            call BlzSetItemIconPath( it, words( hero, BlzGetItemDescription(it), "|cffffffff", "|r", I2S( currentBonus ) ) )
            call UnitRemoveAbility(hero, 'B087')
            call SetUnitAbilityLevel( hero, 'A0MM', currentBonus )
        endif
    endif
    
    set it = null
    set hero = null
endfunction 

function Trig_Moon_Well_Actions takes nothing returns nothing 
	local integer id 
	
    set id = InvokeTimerWithItem( GetManipulatedItem(), "mnwl", 3, true, function Moon_WellCast )
    call SaveUnitHandle( udg_hash, id, StringHash( "mnwlu" ), GetManipulatingUnit() ) 
endfunction 

//=========================================================================== 
function InitTrig_Moon_Well takes nothing returns nothing 
	set gg_trg_Moon_Well = CreateTrigger( ) 
	call TriggerRegisterAnyUnitEventBJ( gg_trg_Moon_Well, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
	call TriggerAddCondition( gg_trg_Moon_Well, Condition( function Trig_Moon_Well_Conditions ) ) 
	call TriggerAddAction( gg_trg_Moon_Well, function Trig_Moon_Well_Actions ) 
endfunction