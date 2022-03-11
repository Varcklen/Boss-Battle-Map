scope Totem1 initializer init

    globals
        public constant integer ID_BOSS = 'o007'
        
        private constant integer HEALTH_CHECK = 90
        private constant integer DAMAGE = 45
        private constant integer SCATTER = 400
        private constant integer AREA = 200
        private constant integer EXPLODE_DELAY = 1
        private constant integer EXPLODE_COOLDOWN = 5
        private constant integer TICKS = 8
        
        private constant real DAMAGE_TICK = 0.5
        
        private constant string FIRE_ANIMATION = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl"
    endglobals

    private function Trig_Totem1_Conditions takes nothing returns boolean
        return GetUnitTypeId(udg_DamageEventTarget) == ID_BOSS and GetUnitLifePercent( udg_DamageEventTarget ) <= HEALTH_CHECK
    endfunction
    
    private function DealDamage takes effect area, integer id returns nothing
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstmeb" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "bstme" ) )
        local group g = CreateGroup()
        local unit u
    
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( area ), BlzGetLocalSpecialEffectY( area ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, boss, TARGET_ENEMY ) then
                call UnitTakeDamage(boss, u, damage, DAMAGE_TYPE_MAGIC)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set area = null
    endfunction

    private function CastFire takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local effect area = LoadEffectHandle(udg_hash, id, StringHash( "bstme" ) )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "bstme" ) ) + 1
        
        if counter >= TICKS or area == null then
            call DestroyEffect(area)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call DealDamage(area, id)
            call SaveInteger( udg_hash, id, StringHash( "bstme" ), counter )
        endif
        
        set area = null
    endfunction

    private function DelayEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local effect area = LoadEffectHandle(udg_hash, id, StringHash( "bstmf" ) )
        local unit caster = LoadUnitHandle(udg_hash, id, StringHash( "bstmfb" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "bstmf" ) )
        local effect fire
        local integer id1
        
        if IsUnitAlive(caster) then
            set fire = AddSpecialEffect(FIRE_ANIMATION, BlzGetLocalSpecialEffectX( area ), BlzGetLocalSpecialEffectY( area ) )
            set id1 = InvokeTimerWithEffect(fire, "bstme", EXPLODE_DELAY, true, function CastFire )
            call SaveUnitHandle( udg_hash, id1, StringHash( "bstmeb" ), caster )
            call SaveReal( udg_hash, id1, StringHash( "bstme" ), damage )
        endif
        call DestroyEffect(area)
        call FlushChildHashtable( udg_hash, id )
        
        set caster = null
        set area = null
        set fire = null
    endfunction

    public function SpawnFireArea takes unit caster, real x, real y, real damage returns nothing
        local integer id
        local effect area = AddSpecialEffect(DEATH_AREA, x, y)
        
        call BlzSetSpecialEffectScale( area, AREA/100 )
        
        set id = InvokeTimerWithEffect(area, "bstmf", EXPLODE_DELAY, false, function DelayEnd )
        call SaveUnitHandle( udg_hash, id, StringHash( "bstmfb" ), caster )
        call SaveReal( udg_hash, id, StringHash( "bstmf" ), damage )
        
        set caster = null
        set area = null
    endfunction
        
    public function TotemCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit boss = LoadUnitHandle( udg_hash, id, StringHash( "bstm1" ))
        local unit target 
        
        if IsUnitDead(boss) or not( udg_fightmod[0] ) then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set target = GroupPickRandomUnit(udg_otryad)
            if GetRandomInt(1, 3) == 1 and target != null then
                call SpawnFireArea(boss, GetUnitX( target ), GetUnitY( target ), DAMAGE )
            else
                call SpawnFireArea(boss, Math_GetUnitRandomX(boss, SCATTER), Math_GetUnitRandomY(boss, SCATTER), DAMAGE )
            endif
        endif
        
        set target = null
        set boss = null
    endfunction

    private function Trig_Totem1_Actions takes nothing returns nothing
        call DisableTrigger( GetTriggeringTrigger() )
        call InvokeTimerWithUnit(udg_DamageEventTarget, "bstm1", bosscast(EXPLODE_COOLDOWN), true, function TotemCast )
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Totem1 = CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Totem1_Actions, function Trig_Totem1_Conditions )
        call DisableTrigger( gg_trg_Totem1 )
    endfunction

endscope