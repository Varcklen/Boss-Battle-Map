globals
    constant integer WOOL_ARMOR_ARMOR = 1
endglobals

function Trig_Wool_Armor_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I0EW'
endfunction

function Wool_ArmorCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wlar" ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "wlarpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "wlari" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "wlar" ) )
    local real count = CountLivingPlayerUnitsOfTypeId(ID_SHEEP, Player(i-1))
    local real armor = (count - arm) * WOOL_ARMOR_ARMOR
    local real armorAll = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "wlarn" ) )

    if not(UnitHasItem(caster, it)) then
        call BlzSetUnitArmor( caster, BlzGetUnitArmor(caster) - armorAll )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "wlarn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != count then
        call BlzSetUnitArmor( caster, BlzGetUnitArmor(caster) + armor )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "wlarn" ), armorAll+armor )
        call SaveReal( udg_hash, id, StringHash( "wlar" ), count ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Wool_Armor_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "wlar" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "wlar" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wlar" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "wlar" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "wlari" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "wlarpl" ), GetUnitUserData(GetManipulatingUnit()) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "wlar" ) ), 3, true, function Wool_ArmorCast )
endfunction

//===========================================================================
function InitTrig_Wool_Armor takes nothing returns nothing
    set gg_trg_Wool_Armor = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Wool_Armor, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Wool_Armor, Condition( function Trig_Wool_Armor_Conditions ) )
    call TriggerAddAction( gg_trg_Wool_Armor, function Trig_Wool_Armor_Actions )
endfunction

