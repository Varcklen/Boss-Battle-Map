scope Banshee2 initializer init

    globals
        private constant integer ID_BOSS = 'n03M'
    
        private constant integer HEALTH_CHECK = 75
        private constant integer HEALTH_LOCUST = 30
        private constant integer FIND_AREA = 600
        private constant integer TIME_LIMIT = 60
        private constant real CONSUME_HEALTH = 0.015
        private constant real HEALTH_TO_LEAVE = 0.4
        
        private constant real TICK = 0.5
        
        private constant string ANIMATION = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
        private constant string APPEAR = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl"
    endglobals

    function Trig_Banshi2_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK and IsUnitVisible( udg_DamageEventTarget, Player(PLAYER_NEUTRAL_AGGRESSIVE))
    endfunction

    function Banshi2Cast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bswf" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "bswft" ) )
        local integer time = LoadInteger( udg_hash, id, StringHash( "bswf" ) ) - 1
        
        if IsUnitDead(boss) or not( udg_fightmod[0] ) then
            call berserk( target, -1 )
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        else
            call SaveInteger( udg_hash, id, StringHash( "bswf" ), time )
            call SetUnitState( target, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( target, UNIT_STATE_LIFE) - ( GetUnitState( target, UNIT_STATE_MAX_LIFE) * CONSUME_HEALTH ) ) )
            if time <= 0 or GetUnitState( target, UNIT_STATE_LIFE) < GetUnitState( target, UNIT_STATE_MAX_LIFE) * HEALTH_TO_LEAVE then
                call SetUnitPosition( boss, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect) ) 
                call ShowUnit( boss, true )
                call PlaySpecialEffect(APPEAR, boss)
                call aggro( boss ) 
                call berserk( target, -1 )
                if GetUnitLifePercent(boss) <= HEALTH_LOCUST then
                    call UnitAddAbility( boss, 'A13R' )
                    call IssueImmediateOrder( boss, "locustswarm" )
                endif
                call PlaySpecialEffect(ANIMATION, boss)
                call PlaySpecialEffect(ANIMATION, target)
                call DestroyTimer( GetExpiredTimer() )
                call FlushChildHashtable( udg_hash, id )
            endif
        endif
        
        set boss = null
    endfunction

    function Trig_Banshi2_Actions takes nothing returns nothing
        local unit boss = udg_DamageEventTarget
        local unit target = randomtarget( boss, FIND_AREA, "enemy", "hero", "", "", "" )
        local integer timeLimit = R2I(TIME_LIMIT / TICK)
        local integer id
               
        if target != null then
            call DisableTrigger( GetTriggeringTrigger() )
            call PlaySpecialEffect(ANIMATION, boss)
            call PlaySpecialEffect(ANIMATION, target)

            call ShowUnit( boss, false )
            call SetUnitPosition( boss, GetRectCenterX( gg_rct_HeroesTp ), GetRectCenterY( gg_rct_HeroesTp ) ) 
            call IssueImmediateOrder( boss, "stop" )

            set id = InvokeTimerWithUnit(boss, "bswf", TICK, true, function Banshi2Cast)
            call SaveUnitHandle( udg_hash, id, StringHash( "bswft" ), target )
            call SaveInteger( udg_hash, id, StringHash( "bswf" ), timeLimit )
            
            call berserk( target, 1 )
        endif
        
        set target = null
        set boss = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Banshi2 = CreateTrigger(  )
        call DisableTrigger( gg_trg_Banshi2 )
        call TriggerRegisterVariableEvent( gg_trg_Banshi2, "udg_AfterDamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_Banshi2, Condition( function Trig_Banshi2_Conditions ) )
        call TriggerAddAction( gg_trg_Banshi2, function Trig_Banshi2_Actions )
    endfunction

endscope

