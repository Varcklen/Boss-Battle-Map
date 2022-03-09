function Trig_WagonE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0DN'
endfunction

function WagonECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "wgne" ) )
    local real money = LoadInteger( udg_hash, id, StringHash( "wgne" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "wgne" ) )
    local unit u
    local integer cyclA
    local real r = 200
    local real g = 0.5
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( caster ) ) and combat( caster, false, 0 ) then
        if GetUnitAbilityLevel( caster, 'A0DN') > 0 then
            call BlzStartUnitAbilityCooldown( caster, 'A0DN', 7 )
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 1
            set u = randomtarget( caster, r, "enemy", "", "", "", "" )
            if u == null and r <= 1000 then
                set cyclA = cyclA - 1
                set r = r + 100
                set g = g + 0.15
            endif
            set cyclA = cyclA + 1
        endloop
        if not(udg_fightmod[3]) then
            call moneyst( caster, R2I(money*g) )
        endif
        call healst( caster, null, heal*g )
    endif
    
    set caster = null
endfunction

function Trig_WagonE_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    local integer money = 4 + (2*GetUnitAbilityLevel( GetLearningUnit(), 'A0DN' ))
    local real heal = 4 + (4*GetUnitAbilityLevel( GetLearningUnit(), 'A0DN' ))
    
    if LoadTimerHandle( udg_hash, id, StringHash( "wgne" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "wgne" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "wgne" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "wgne" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "wgne" ), money )
    call SaveReal( udg_hash, id, StringHash( "wgne" ), heal )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "wgne" ) ), 7, true, function WagonECast )
endfunction

//===========================================================================
function InitTrig_WagonE takes nothing returns nothing
    set gg_trg_WagonE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WagonE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_WagonE, Condition( function Trig_WagonE_Conditions ) )
    call TriggerAddAction( gg_trg_WagonE, function Trig_WagonE_Actions )
endfunction

