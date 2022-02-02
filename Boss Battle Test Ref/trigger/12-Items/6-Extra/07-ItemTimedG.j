function Trig_ItemTimedG_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I01Q' or GetItemTypeId(GetManipulatedItem()) == 'I01R' or GetItemTypeId(GetManipulatedItem()) == 'I04Q' or GetItemTypeId(GetManipulatedItem()) == 'I04P' or GetItemTypeId(GetManipulatedItem()) == 'I04J' or GetItemTypeId(GetManipulatedItem()) == 'I02U' or GetItemTypeId(GetManipulatedItem()) == 'I0AI' or GetItemTypeId(GetManipulatedItem()) == 'I03J' or GetItemTypeId(GetManipulatedItem()) == 'I060' or GetItemTypeId(GetManipulatedItem()) == 'I03O' or GetItemTypeId(GetManipulatedItem()) == 'I03P' or GetItemTypeId(GetManipulatedItem()) == 'I03M' or GetItemTypeId(GetManipulatedItem()) == 'I03N' or GetItemTypeId(GetManipulatedItem()) == 'I03L' or GetItemTypeId(GetManipulatedItem()) == 'I03K' or GetItemTypeId(GetManipulatedItem()) == 'I03T' or GetItemTypeId(GetManipulatedItem()) == 'I03U' or GetItemTypeId(GetManipulatedItem()) == 'I05E' or GetItemTypeId(GetManipulatedItem()) == 'I05M' or GetItemTypeId(GetManipulatedItem()) == 'I08V' or GetItemTypeId(GetManipulatedItem()) == 'I08U' or GetItemTypeId(GetManipulatedItem()) == 'I08T' or GetItemTypeId(GetManipulatedItem()) == 'I08W' or GetItemTypeId(GetManipulatedItem()) == 'I08X' or GetItemTypeId(GetManipulatedItem()) == 'I08S' or GetItemTypeId(GetManipulatedItem()) == 'I08Y' or GetItemTypeId(GetManipulatedItem()) == 'I08Z' or GetItemTypeId(GetManipulatedItem()) == 'I090' or GetItemTypeId(GetManipulatedItem()) == 'I091' 
endfunction

function ItemTimedG_ItemAdded takes unit u, integer index returns nothing
    call UnitAddItem( u, CreateItem(index, GetUnitX( u ), GetUnitY( u )))
    set u = null
endfunction

function ItemTimedG_HealthRestore takes unit n returns nothing
    local group g = CreateGroup()
    local unit u

    call spectimeunit( n, "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl", "origin", 2 )
    //call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 5000, null )
    call GroupAddGroup( udg_otryad, g )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, n, "ally" ) then
            call healst( n, u, 200 )
            if n != u then
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", u, "origin" ) )
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set n = null
endfunction

function ItemTimedG_ManaRestore takes unit n returns nothing
    local group g = CreateGroup()
    local unit u

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", n, "origin" ) )
    //call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 5000, null )
    call GroupAddGroup( udg_otryad, g )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, n, "ally" ) and GetUnitState( u, UNIT_STATE_MAX_MANA) > 1 then
            call manast( n, u, 75 )
            if n != u then
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", u, "origin" ) )
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set n = null
endfunction

function Trig_ItemTimedG_Actions takes nothing returns nothing
    if GetItemTypeId(GetManipulatedItem()) == 'I03O' then
        call ItemTimedG_HealthRestore(GetManipulatingUnit())
    elseif GetItemTypeId(GetManipulatedItem()) == 'I0AI' then
        call JuleRef()
    elseif GetItemTypeId(GetManipulatedItem()) == 'I02U' then
        call moneyst( GetManipulatingUnit(), 10 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I04J' then
        call moneyst( GetManipulatingUnit(), 50 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I04P' then
        call moneyst( GetManipulatingUnit(), 100 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I04Q' then
        call moneyst( GetManipulatingUnit(), 500 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03P' then
        call ItemTimedG_ManaRestore(GetManipulatingUnit())
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03J' and GetHeroLevel(GetManipulatingUnit()) < 100 then
        call SetHeroLevel(GetManipulatingUnit(), GetHeroLevel(GetManipulatingUnit()) + 1, false)
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl", GetManipulatingUnit(), "origin" ) )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03N' then
        call BlzSetUnitMaxHP( GetManipulatingUnit(), BlzGetUnitMaxHP(GetManipulatingUnit()) + 25 )
        call textst( "|c0020FF20 +25 health", GetManipulatingUnit(), 64, 90, 10, 1 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I060' then
        call UnitStun(GetManipulatingUnit(), GetManipulatingUnit(), 5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetUnitX( GetManipulatingUnit() ), GetUnitY( GetManipulatingUnit() ) ) )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03M' then
        call BlzSetUnitBaseDamage( GetManipulatingUnit(), BlzGetUnitBaseDamage(GetManipulatingUnit(), 0) + 1, 0 )
        call textst( "|c00FF2020 +1 attack", GetManipulatingUnit(), 64, 90, 10, 1 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I01R' then
        call BlzSetUnitBaseDamage( GetManipulatingUnit(), BlzGetUnitBaseDamage(GetManipulatingUnit(), 0) + 1, 0 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I01Q' then
        call BlzSetUnitMaxHP( GetManipulatingUnit(), BlzGetUnitMaxHP(GetManipulatingUnit()) + 25 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03L' then
        call RandomStat(GetManipulatingUnit(), 1, 0, true)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03K' then
        call moneyst( GetManipulatingUnit(), 50 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03T' then
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01R' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01Q' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I03U' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I05M' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01P' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01N' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01O' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I01S' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I05E' )
        call ItemTimedG_ItemAdded(GetManipulatingUnit(), 'I03J' )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I03U' then
        call spdst( GetManipulatingUnit(), 0.75 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I05E' then
    	call BlzSetUnitMaxMana( GetManipulatingUnit(), BlzGetUnitMaxMana(GetManipulatingUnit()) + 8 )
    elseif GetItemTypeId(GetManipulatedItem()) == 'I05M' then
        call luckyst( GetManipulatingUnit(), 1 )
    endif
endfunction

//===========================================================================
function InitTrig_ItemTimedG takes nothing returns nothing
    set gg_trg_ItemTimedG = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ItemTimedG, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_ItemTimedG, Condition( function Trig_ItemTimedG_Conditions ) )
    call TriggerAddAction( gg_trg_ItemTimedG, function Trig_ItemTimedG_Actions )
endfunction

