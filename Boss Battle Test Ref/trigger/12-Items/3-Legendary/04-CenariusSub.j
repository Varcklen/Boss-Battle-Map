function Trig_CenariusSub_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04Y'
endfunction

function CenariusSubCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "cens" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "censc" ) )
    
    if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 900, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) then
                call healst( caster, u, 18 )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set dummy = null
    set caster = null
endfunction

function Trig_CenariusSub_Actions takes nothing returns nothing
    local integer id 
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A04Y'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
        call UnitAddAbility( bj_lastCreatedUnit, 'A04Z')
	call BlzSetUnitSkin( bj_lastCreatedUnit, 'nhcn' )
	call QueueUnitAnimationBJ( bj_lastCreatedUnit, "stand" )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 20 )
        call IssueImmediateOrder( bj_lastCreatedUnit, "tranquility" )
        set id = GetHandleId( bj_lastCreatedUnit )
        
        call SaveTimerHandle( udg_hash, id, StringHash( "cens" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "cens" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "cens" ), bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, id, StringHash( "censc" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "cens" ) ), 1, true, function CenariusSubCast )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_CenariusSub takes nothing returns nothing
    set gg_trg_CenariusSub = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CenariusSub, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_CenariusSub, Condition( function Trig_CenariusSub_Conditions ) )
    call TriggerAddAction( gg_trg_CenariusSub, function Trig_CenariusSub_Actions )
endfunction

