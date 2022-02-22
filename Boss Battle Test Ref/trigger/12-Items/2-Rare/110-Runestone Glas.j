globals
    constant integer RUNESTONE_GLAS_SPELL_POWER = 6
    constant integer RUNESTONE_GLAS_SPELL_POWER_REDUCTION = 30
endglobals

function Trig_Runestone_Glas_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I01Y'
endfunction

function Runestone_GlasCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "glas" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "glasi" ) )
    local real arm = LoadReal( udg_hash, id, StringHash( "glas" ) )
    local real count = PotionsUsedPerBattle[GetUnitUserData(caster)]
    local real spd = (count - arm) * RUNESTONE_GLAS_SPELL_POWER
    local real spdnow = LoadReal( udg_hash, GetHandleId( caster ), StringHash( "glasn" ) )

    if not(UnitHasItem(caster, it)) then
        call spdst( caster, -spdnow )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "glasn" ), 0 )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != count then
        call spdst( caster, spd )
        call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "glasn" ), spdnow+spd )
        call SaveReal( udg_hash, id, StringHash( "glas" ), count ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Runestone_Glas_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "glas" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "glas" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "glas" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "glas" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "glasi" ), GetManipulatedItem() )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "glas" ) ), 3, true, function Runestone_GlasCast )
endfunction

//===========================================================================
function InitTrig_Runestone_Glas takes nothing returns nothing
    set gg_trg_Runestone_Glas = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Runestone_Glas, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Runestone_Glas, Condition( function Trig_Runestone_Glas_Conditions ) )
    call TriggerAddAction( gg_trg_Runestone_Glas, function Trig_Runestone_Glas_Actions )
endfunction

//===========================================================================
scope RunestoneGlas initializer Triggs
    private function ItemAdd takes nothing returns nothing
        local integer i = GetUnitUserData(GetManipulatingUnit())
        if not( udg_logic[i + 26] ) and GetItemTypeId(GetManipulatedItem()) == 'I01Y' then
            call SpellPotion(i, -RUNESTONE_GLAS_SPELL_POWER_REDUCTION)
        endif
    endfunction
    
    private function ItemRemove takes nothing returns nothing
        local integer i = GetUnitUserData(GetManipulatingUnit())
        if not( udg_logic[i + 26] ) and GetItemTypeId(GetManipulatedItem()) == 'I01Y' then
            call SpellPotion(i, RUNESTONE_GLAS_SPELL_POWER_REDUCTION)
        endif
    endfunction
    
    private function Rune_Glas takes unit u, item it, boolean isBonusAdded returns nothing
        local integer number = inv(u, 'I01Y')
        local integer heroId = GetUnitUserData(u)
        local real count
        
        if isBonusAdded then
            set count = RUNESTONE_GLAS_SPELL_POWER_REDUCTION
        else
            set count = -RUNESTONE_GLAS_SPELL_POWER_REDUCTION
        endif
        
        if count < 0 and GetItemTypeId( it ) == 'I01Y' then
            set number = number - 1
        endif
        
        if number > 0 then
            call spdst(u, count*number)
        endif
        
        set u = null
        set it = null
    endfunction
    
    private function ItemSetAdd takes nothing returns nothing
        call Rune_Glas(udg_Event_RuneSetAdd_Hero, udg_Event_RuneSetAdd_Item, true)
    endfunction
    
    private function ItemSetRemove takes nothing returns nothing
        call Rune_Glas(udg_Event_RuneSetRemove_Hero, udg_Event_RuneSetRemove_Item, false)
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_PICKUP_ITEM )
        call TriggerAddAction( trig, function ItemAdd)
        
        set trig = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ( trig, EVENT_PLAYER_UNIT_DROP_ITEM )
        call TriggerAddAction( trig, function ItemRemove)
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_RuneSetAdd_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function ItemSetAdd)
        
        set trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_RuneSetRemove_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function ItemSetRemove)

        set trig = null
    endfunction
endscope

