function Trig_DiabloAggro_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetEnteringUnit()) == 'o00H'
endfunction

function DiabloAggroCast takes nothing returns nothing 
	local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "diablo" ) )
    local group g = CreateGroup()
    local unit u
    
	if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", LoadUnitHandle( udg_hash, id, StringHash( "diablo" ) ), "origin" ) )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 640, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitType( u, UNIT_TYPE_MECHANICAL) ) then
                call IssueTargetOrder( u, "attackonce", caster )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    else
        call DestroyTimer( GetExpiredTimer( ) )
        call FlushChildHashtable( udg_hash, id )
	endif
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction 

function Trig_DiabloAggro_Actions takes nothing returns nothing
	local integer id = GetHandleId( GetEnteringUnit() )
	
	call SaveTimerHandle( udg_hash, id, StringHash( "diablo" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "diablo" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "diablo" ), GetEnteringUnit() ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "diablo" ) ), 1, true, function DiabloAggroCast ) 
endfunction 

//===========================================================================
function InitTrig_DiabloAggro takes nothing returns nothing
    set gg_trg_DiabloAggro = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_DiabloAggro, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_DiabloAggro, Condition( function Trig_DiabloAggro_Conditions ) )
    call TriggerAddAction( gg_trg_DiabloAggro, function Trig_DiabloAggro_Actions )
endfunction

