function Trig_BeornP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A00B'
endfunction

function BeornPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "brnp" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "brnplvl" ) )
    local integer i = 0
    local group g = CreateGroup()
    local unit u
    
    if n != null and GetUnitState( n, UNIT_STATE_LIFE) > 0.405 then
        call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 450, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( n, u, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO ) then
                set i = i + 1
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if i > 4 then
            set i = 4
        endif
        call SetUnitAbilityLevel( n, 'A008', ( 5 * ( i - 1 ) ) + lvl )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set n = null
endfunction

function Trig_BeornP_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    
    call UnitAddAbility( GetLearningUnit(), 'A008' )
    
    call DestroyTimer( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "brnp" )))
    call RemoveSavedHandle(udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "brnp" ) )
    
	call SaveTimerHandle( udg_hash, id, StringHash( "brnp" ), CreateTimer( ) ) 
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "brnp" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "brnp" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "brnplvl" ), GetUnitAbilityLevel(GetLearningUnit(), GetLearnedSkill()) ) 
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "brnp" ) ), 1, true, function BeornPCast )
endfunction

//===========================================================================
function InitTrig_BeornP takes nothing returns nothing
    set gg_trg_BeornP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BeornP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_BeornP, Condition( function Trig_BeornP_Conditions ) )
    call TriggerAddAction( gg_trg_BeornP, function Trig_BeornP_Actions )
endfunction

