function Trig_Perfectly_Cut_Lens_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I03R'
endfunction

function Perfectly_Cut_LensCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pcln" ) )
    local integer pl = LoadInteger( udg_hash, id, StringHash( "pclnpl" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "pclni" ) )
    local integer crystals = (udg_Set_Cristall_Number[pl+1]*100)
    local integer arm = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "pcln" ) )
    
    if not(UnitHasItem(caster, it)) then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif arm != crystals then
        call BlzSetAbilityRealLevelFieldBJ( BlzGetItemAbility(it, 'A0BL'), ABILITY_RLF_AREA_OF_EFFECT, 0, crystals )
        call BlzSetItemExtendedTooltip( it, words( caster, BlzGetItemExtendedTooltip(it), "|cffbe81f7", "|r", I2S(crystals) ) )
        call BlzSetItemExtendedTooltip( it, words( caster, BlzGetItemExtendedTooltip(it), "|cffffffff", "|r", I2S(crystals) ) )
        call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "pcln" ), crystals ) 
    endif

    set caster = null
    set it = null
endfunction

function Trig_Perfectly_Cut_Lens_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )

    if LoadTimerHandle( udg_hash, id, StringHash( "pcln" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "pcln" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pcln" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "pcln" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "pclni" ), GetManipulatedItem() )
    call SaveInteger( udg_hash, id, StringHash( "pclnpl" ), CorrectPlayer(GetManipulatingUnit())-1 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "pcln" ) ), 4, true, function Perfectly_Cut_LensCast )
endfunction

//===========================================================================
function InitTrig_Perfectly_Cut_Lens takes nothing returns nothing
    set gg_trg_Perfectly_Cut_Lens = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Perfectly_Cut_Lens, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Perfectly_Cut_Lens, Condition( function Trig_Perfectly_Cut_Lens_Conditions ) )
    call TriggerAddAction( gg_trg_Perfectly_Cut_Lens, function Trig_Perfectly_Cut_Lens_Actions )
endfunction

