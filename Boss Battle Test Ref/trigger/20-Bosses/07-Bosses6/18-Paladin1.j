scope Paladin01

    globals
        private constant integer HEALTH_CHECK = 75
        
        private constant integer LIMIT = 30
        private constant integer SPEED = 40
        private constant integer AREA = 128
        private constant integer DAMAGE = 150
        private constant integer PATH_LIMIT = 100
        private constant real CREATION_COOLDOWN = 0.5
        private constant real TIME_MOVE = 0.04
        
        private constant string TELEPORTATION_ANIMATION = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl"
        private constant string ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
        
        private trigger Wave_Use = null
    endglobals

    function Trig_Paladin1_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == 'h00M' and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction
    
    /*private function PaladinDealDamage takes unit boss, effect wave, group nodmg returns nothing
        local group g = CreateGroup()
        local unit u
    
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                call UnitTakeDamage(boss, u, DAMAGE, DAMAGE_TYPE_MAGIC)
                call GroupAddUnit( nodmg, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set wave = null
        set nodmg = null
        set boss = null
    endfunction
    
    private function PaladinWave takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "bspl2" ) )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "bspl2" ) ) + 1
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspl2cs" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "bspl2" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "bspl2g" ) )
        local point newPoint = 0
        
        if counter >= PATH_LIMIT or wave == null then
            call DestroyEffect( wave )
            call GroupClear( nodmg )
            call DestroyGroup( nodmg )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set newPoint = GetMovedPoint( wave, yaw, SPEED )
            call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )
            call PaladinDealDamage(boss, wave, nodmg)
            call SaveInteger( udg_hash, id, StringHash( "bspl2" ), counter )
        endif
        
        call newPoint.destroy()
        set nodmg = null
        set wave = null
        set boss = null
    endfunction*/

    private function EndWaves takes unit boss returns nothing
        call SetUnitAnimation( boss, "stand" )
        call pausest(boss, -1)
        call UnitRemoveAbility( boss, 'Avul' )
        call UnitRemoveAbility( boss, 'A0AC' )

        set boss = null
    endfunction
    
    function RotateEffect takes unit target, point startPoint returns real
        local point unitPoint = point.create()
        local real yaw = 0
        
        set unitPoint.x = GetUnitX(target)
        set unitPoint.y = GetUnitY(target)
        
        set yaw = GetAngleBetweenPoints(unitPoint, startPoint)

        call startPoint.destroy()
        call unitPoint.destroy()
        set target = null
        return yaw
    endfunction
    
    private function DealDamage takes nothing returns nothing
        call UnitTakeDamage(Event_WaveHit_Caster, Event_WaveHit_Target, DAMAGE, DAMAGE_TYPE_MAGIC)
    endfunction
    
    private function CreateWave takes unit boss, unit target returns nothing
        //local integer id = 0
        local integer rand = 0
        local point startPoint = point.create()
        //local real yaw = 0
    
        set rand = GetRandomInt( 1, 4 )
        set startPoint.x = GetRectCenterX( udg_Boss_Rect ) + 2000 * Cos( ( 45 + ( 90 * rand ) ) * bj_DEGTORAD )//startPoint.
        set startPoint.y = GetRectCenterY( udg_Boss_Rect ) + 2000 * Sin( ( 45 + ( 90 * rand ) ) * bj_DEGTORAD )//startPoint.
        
        /*set wave = AddSpecialEffect( ANIMATION, startPoint.x, startPoint.y)
        set yaw = RotateEffect(wave, target, startPoint )
        //call BJDebugMsg("yaw: " + R2S(yaw))
        
        set id = InvokeTimerWithEffect( wave, "bspl2", TIME_MOVE, true, function PaladinWave )
        call SaveUnitHandle( udg_hash, id, StringHash( "bspl2cs" ), boss )
        call SaveReal( udg_hash, id, StringHash( "bspl2" ), yaw )
        call SaveGroupHandle( udg_hash, id, StringHash( "bspl2g" ), CreateGroup() )*/
        
        call Wave_CreateWave( boss, startPoint.x, startPoint.y, RotateEffect(target, startPoint), TIME_MOVE, AREA, PATH_LIMIT, SPEED, TARGET_ENEMY, WAVE_BASE_ANIMATION, Wave_Use, null )

        call startPoint.destroy()
        set boss = null
        set target = null
    endfunction

    function PaladinCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bspl" ) )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "bspl" ) ) + 1
        local unit target = null
        
        if IsUnitDead(boss) or udg_fightmod[0] == false or counter >= LIMIT then
            call EndWaves(boss)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SaveInteger( udg_hash, id, StringHash( "bspl" ), counter )
            
            if Math_IsNumberInteger(I2R(counter)/5) then
                call SetUnitAnimationWithRarity( boss, "spell channel", RARITY_FREQUENT )
            endif
            
            set target = GroupPickRandomUnit(udg_otryad)
            if target != null then
                call CreateWave(boss, target)
                
                //set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( boss ), 'u000', x, y, bj_RADTODEG * Atan2( GetUnitY( u ) - y, GetUnitX( u ) - x ) )
                //call UnitAddAbility( bj_lastCreatedUnit, 'A02M')
                //call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
                /*call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bspl2" ), CreateTimer() )
                set id1 = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bspl2" ) ) ) 
                call SaveUnitHandle( udg_hash, id1, StringHash( "bspl2" ), bj_lastCreatedUnit )
                
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "bspl2" ) ),  )*/
            endif
        endif
        
        set target = null
        set boss = null
    endfunction

    public function WaveStart takes unit boss, real cooldown returns nothing
        call UnitAddAbility( boss, 'Avul')
        call UnitAddAbility( boss, 'A0AC')
        call DestroyEffect( AddSpecialEffect( TELEPORTATION_ANIMATION, GetUnitX(boss), GetUnitY(boss)) )
        call SetUnitPosition( boss, GetRectCenterX(udg_Boss_Rect), GetRectCenterY(udg_Boss_Rect) + 600 )
        call DestroyEffect( AddSpecialEffectTarget( TELEPORTATION_ANIMATION, boss, "origin") )
        call pausest(boss, 1)
        call SetUnitFacing( boss, bj_UNIT_FACING )
        call SetUnitAnimationWithRarity( boss, "spell channel", RARITY_FREQUENT )
        
        call InvokeTimerWithUnit(boss, "bspl", cooldown, true, function PaladinCast)
        
        set boss = null
    endfunction

    function Trig_Paladin1_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call WaveStart(udg_DamageEventTarget, CREATION_COOLDOWN)
    endfunction

    //===========================================================================
    function InitTrig_Paladin1 takes nothing returns nothing
        set gg_trg_Paladin1 = CreateTrigger(  )
        call DisableTrigger( gg_trg_Paladin1 )
        call TriggerRegisterVariableEvent( gg_trg_Paladin1, "udg_AfterDamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition( gg_trg_Paladin1, Condition( function Trig_Paladin1_Conditions ) )
        call TriggerAddAction( gg_trg_Paladin1, function Trig_Paladin1_Actions )
        
        set Wave_Use = CreateTrigger()
        call TriggerAddAction( Wave_Use, function DealDamage )
    endfunction

endscope