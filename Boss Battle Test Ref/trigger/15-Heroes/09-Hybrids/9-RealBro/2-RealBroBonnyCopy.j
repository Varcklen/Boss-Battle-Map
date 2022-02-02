function Trig_RealBroBonnyCopy_Conditions takes nothing returns boolean
    return GetUnitTypeId( CreateUnitCopy_Original ) == 'n030'
endfunction

function Trig_RealBroBonnyCopy_Actions takes nothing returns nothing
    local unit owner = LoadUnitHandle( udg_hash, GetHandleId( CreateUnitCopy_Original ), StringHash( "rlbqac" ) )
    
    call SaveUnitHandle( udg_hash, GetHandleId( CreateUnitCopy_Copy ), StringHash( "rlbqac" ), owner )

    if GetUnitAbilityLevel( CreateUnitCopy_Original, 'A1BA') > 0 then
        call BunnyAddAbilities(owner, CreateUnitCopy_Copy, 1)
    endif
    if GetUnitAbilityLevel( CreateUnitCopy_Original, 'A1B9') > 0 then
        call BunnyAddAbilities(owner, CreateUnitCopy_Copy, 2)
    endif
    if GetUnitAbilityLevel( CreateUnitCopy_Original, 'A1BB') > 0 then
        call BunnyAddAbilities(owner, CreateUnitCopy_Copy, 3)
    endif
    if GetUnitAbilityLevel( CreateUnitCopy_Original, 'A1BC') > 0 then
        call BunnyAddAbilities(owner, CreateUnitCopy_Copy, 4)
    endif
    
    set owner = null
endfunction

//===========================================================================
function InitTrig_RealBroBonnyCopy takes nothing returns nothing
    set gg_trg_RealBroBonnyCopy = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_RealBroBonnyCopy, "CreateUnitCopy_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_RealBroBonnyCopy, Condition( function Trig_RealBroBonnyCopy_Conditions ) )
    call TriggerAddAction( gg_trg_RealBroBonnyCopy, function Trig_RealBroBonnyCopy_Actions )
endfunction

