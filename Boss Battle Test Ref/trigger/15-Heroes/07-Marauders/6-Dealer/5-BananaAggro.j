function Trig_BananaAggro_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o01B'
endfunction

function BananaAggroCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "bann" ) )
	local unit u

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        set u = randomtarget( caster, 600, TARGET_ENEMY, RANDOM_TARGET_NOT_PROVOKED, "", "", "" )
        if u != null then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", GetUnitX(caster),GetUnitY(caster) ) )
            call taunt( caster, u, 3 )
        endif
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer( ) )
    endif

    set caster = null
    set u = null
endfunction 

function Trig_BananaAggro_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )

	call SaveTimerHandle( udg_hash, id, StringHash( "bann" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bann" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "bann" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bann" ) ), GetRandomReal(2,5), true, function BananaAggroCast ) 
endfunction 

//===========================================================================
function InitTrig_BananaAggro takes nothing returns nothing
    set gg_trg_BananaAggro = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_BananaAggro, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_BananaAggro, Condition( function Trig_BananaAggro_Conditions ) )
    call TriggerAddAction( gg_trg_BananaAggro, function Trig_BananaAggro_Actions )
endfunction

