scope Ogre initializer init

    globals
        private constant integer ID_BOSS = 'h001'
        private constant integer ID_BOSS_AWAKEN = 'h002'
        private constant integer ID_CHARGE_ANIMATION = 'A06Z'
        private constant integer ID_CHARGE_ANIMATION_BUFF = 'B019'
        
        private constant integer HEALTH_CHECK = 40
        private constant integer CHARGE_TICK = 1
        private constant integer CHARGE_TIME = 2
        private constant integer CHARGE_COOLDOWN = 10
        private constant real TICK = 0.04
        private constant integer FLIGHT_LENGTH = 32
        private constant integer DAMAGE = 200
        private constant integer SPEED = 42
        private constant integer AREA = 128
        
        private constant string AWAKE_ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
        private constant string WAVE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
    endglobals

    function Trig_Ogre1_Conditions takes nothing returns boolean
        return GetUnitTypeId( udg_DamageEventTarget ) == ID_BOSS and GetUnitLifePercent(udg_DamageEventTarget) <= HEALTH_CHECK
    endfunction

    private function DealDamage takes unit boss, effect wave, group nodmg returns nothing
        local group g = CreateGroup()
        local unit u
    
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, "enemy" ) and IsUnitInGroup( u, nodmg ) == false then
                call UnitDamageTarget( boss, u, DAMAGE, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call GroupAddUnit( nodmg, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set nodmg = null
        set u = null
        set boss = null
        set wave = null
    endfunction

    function OgreWave takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "bsog3" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "bsog3" ) )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsog3b" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "bsog3g" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "bsog3" ) )
        local point newPoint = 0

        if counter >= FLIGHT_LENGTH or wave == null then
            call DestroyEffect( wave )
            call GroupClear( nodmg )
            call DestroyGroup( nodmg )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set newPoint = GetMovedPoint( wave, yaw, SPEED )
            call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )
            call DealDamage( boss, wave, nodmg )
            call SaveInteger( udg_hash, id, StringHash( "bsog3" ), counter )
        endif

        call newPoint.destroy()
        set wave = null
        set boss = null
        set nodmg = null
    endfunction
    
    private function CreateWave takes unit boss returns nothing
        local unit target
        local effect wave
        local real yaw
        local integer id
    
        set wave = AddSpecialEffect( WAVE_ANIMATION, GetUnitX(boss), GetUnitY(boss))
        set yaw = Deg2Rad(GetUnitFacing(boss))
        call BlzSetSpecialEffectYaw( wave, yaw )
        
        set id = InvokeTimerWithEffect( wave, "bsog3", TICK, true, function OgreWave )
        call SaveUnitHandle( udg_hash, id, StringHash( "bsog3b" ), boss )
        call SaveReal( udg_hash, id, StringHash( "bsog3" ), yaw )
        call SaveGroupHandle( udg_hash, id, StringHash( "bsog3g" ), CreateGroup() )
        
        call IssueImmediateOrder( boss, "stop" )
        call SetUnitAnimation( boss, "attack slam" )
        set target = randomtarget( boss, 600, "enemy", "", "", "", "" )
        if target == null then
            call aggro( boss )
        endif
    
        set wave = null
        set boss = null
        set target = null
    endfunction

    function OgreEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "bsog2" ) ) + 1
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsog2" ) )
        
        if counter >= CHARGE_TIME then
            if IsUnitAlive(boss) and udg_fightmod[0] then
                call pausest( boss, -1 )
                call UnitRemoveAbility( boss, ID_CHARGE_ANIMATION)
                call UnitRemoveAbility( boss, ID_CHARGE_ANIMATION_BUFF)
                
                call CreateWave(boss)
            endif
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SaveInteger( udg_hash, id, StringHash( "bsog2" ), counter )
            if IsUnitAlive(boss) then
                call SetUnitAnimation( boss, "spell" )
            endif
        endif
        
        set boss = null
    endfunction

    function OgreCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bsog1" ) )
        
        if IsUnitDead(boss) or udg_fightmod[0] == false then
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id )
        else
            call pausest( boss, 1 )
            call SetUnitAnimation( boss, "spell" )
            call UnitAddAbility( boss, ID_CHARGE_ANIMATION )
            
            call InvokeTimerWithUnit(boss, "bsog2", CHARGE_TICK, true, function OgreEnd)
        endif
        
        set boss = null
    endfunction

    function Trig_Ogre1_Actions takes nothing returns nothing
        local unit boss = udg_DamageEventTarget
        local unit new = null
        local real hp = GetUnitState( boss, UNIT_STATE_LIFE )

        call DisableTrigger( GetTriggeringTrigger() )
        
        call ShowUnit( boss, false)
        set new = CreateUnit(GetOwningPlayer(boss), ID_BOSS_AWAKEN, GetUnitX(boss), GetUnitY(boss), GetUnitFacing(boss))
        call SaveUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( boss ), StringHash( "aggro" ) ) ) , StringHash( "aggro" ), new )
        call SetUnitState( new, UNIT_STATE_LIFE, hp )
        call GroupRemoveUnit( udg_Bosses, boss )

        if bossbar == boss then
            set bossbar = new
        endif
        if bossbar1 == boss then
            set bossbar1 = new
        endif
        
        call BlzSetUnitBaseDamage( new, BlzGetUnitBaseDamage(boss, 0), 0 )
        call BlzSetUnitArmor( new, BlzGetUnitArmor(boss) )
        call RemoveUnit(boss)
        
        call PlaySpecialEffect(AWAKE_ANIMATION, new)
        
        call dummyspawn( new, 1, 'A0H6', 0, 0 )
        call IssueImmediateOrder( bj_lastCreatedUnit, "stomp" )

        if GetOwningPlayer(new) != Player(10) then
            call UnitApplyTimedLife( new, 'BTLF', 20 )
        endif
        
        call InvokeTimerWithUnit(new, "bsog1", bosscast(CHARGE_COOLDOWN), true, function OgreCast)

        set new = null
        set boss = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Ogre1 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Ogre1_Actions, function Trig_Ogre1_Conditions )
        call DisableTrigger( gg_trg_Ogre1 )
    endfunction
endscope
