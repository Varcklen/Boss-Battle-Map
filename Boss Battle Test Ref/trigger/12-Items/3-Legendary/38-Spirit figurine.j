function Trig_Spirit_figurine_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I02S'
endfunction

function Spirit_figurineCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sprf" ) )
    local item it = LoadItemHandle( udg_hash, id, StringHash( "sprfi" ) )
    local unit spir = LoadUnitHandle( udg_hash, id, StringHash( "sprfs" ) )
    local real dist = DistanceBetweenPoints(GetUnitLoc(caster), GetUnitLoc(spir))
    
    if not(UnitHasItem(caster,it )) then
        call RemoveUnit( spir )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif dist > 700 then
        call SetUnitPosition( spir, GetUnitX(caster) + GetRandomReal( -200, 200 ), GetUnitY(caster) + GetRandomReal( -200, 200 ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( spir ), GetUnitY( spir ) ) )
    elseif dist > 300 then
        call IssuePointOrder( spir, "move", GetUnitX(caster) + GetRandomReal( -100, 100 ), GetUnitY(caster) + GetRandomReal( -100, 100 ) )
    endif

    set caster = null
    set spir = null
    set it = null
endfunction

function Trig_Spirit_figurine_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetManipulatedItem() )
    local boolean l = false

    if LoadTimerHandle( udg_hash, id, StringHash( "sprf" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "sprf" ), CreateTimer() )
        set l = true
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sprf" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "sprf" ), GetManipulatingUnit() ) 
    call SaveItemHandle( udg_hash, id, StringHash( "sprfi" ), GetManipulatedItem() )
    if l then
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetManipulatingUnit() ), 'o01F', GetUnitX(GetManipulatingUnit()) + GetRandomReal( -300, 300 ), GetUnitY(GetManipulatingUnit()) + GetRandomReal( -300, 300 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        call SaveUnitHandle( udg_hash, id, StringHash( "sprfs" ), bj_lastCreatedUnit )
    endif
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetManipulatedItem() ), StringHash( "sprf" ) ), 1, true, function Spirit_figurineCast )
endfunction

//===========================================================================
function InitTrig_Spirit_figurine takes nothing returns nothing
    set gg_trg_Spirit_figurine = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Spirit_figurine, EVENT_PLAYER_UNIT_PICKUP_ITEM ) 
    call TriggerAddCondition( gg_trg_Spirit_figurine, Condition( function Trig_Spirit_figurine_Conditions ) )
    call TriggerAddAction( gg_trg_Spirit_figurine, function Trig_Spirit_figurine_Actions )
endfunction

