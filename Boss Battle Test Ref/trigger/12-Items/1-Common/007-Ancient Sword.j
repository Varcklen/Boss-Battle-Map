scope AncientSword initializer init

    globals
        private constant integer ID_ITEM = 'I02P'
        private constant integer ID_ULTIMATE_WEAPON = 'I030'
        private constant integer ULTIMATE_WEAPON_NUMBER = 8 
        
        private constant integer CHANCE = 5
        private constant integer DAMAGE = 60
        private constant real TICK = 0.04
        private constant integer FLIGHT_LENGTH = 32
        private constant integer AREA = 128
        private constant integer SPEED = 44
        
        private constant string WAVE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
        
        private trigger Wave_Use = null
    endglobals
    
    function Trig_Ancient_Sword_Conditions takes nothing returns boolean
        if udg_IsDamageSpell == true then
            return false
        elseif not( IsHeroHasItem( udg_DamageEventSource, ID_ITEM ) or ( IsHeroHasItem( udg_DamageEventSource, ID_ULTIMATE_WEAPON ) and udg_Set_Weapon_Logic[GetUnitUserData(udg_DamageEventSource) + ULTIMATE_WEAPON_NUMBER] ) ) then
            return false
        elseif LuckChance( udg_DamageEventSource, CHANCE + GetUnitLevel(udg_DamageEventSource) ) == false then
            return false
        endif
        return true
    endfunction
    
    /*private function DealDamage takes effect wave, group nodmg, unit caster, real damage returns nothing
        local group g = CreateGroup()
        local unit u
        
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                set IsDisableSpellPower = true
                call UnitTakeDamage(caster, u, damage, DAMAGE_TYPE_MAGIC)
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
        set caster = null
    endfunction

    function Ancient_SwordCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "anss" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "anss" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "anssc" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "anss" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "anssg" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "anssy" ) )
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
            call DealDamage( wave, nodmg, caster, damage )
            call SaveInteger( udg_hash, id, StringHash( "anss" ), counter )
        endif

        call newPoint.destroy()
        set wave = null
        set caster = null
        set nodmg = null
    endfunction*/
    
    private function Use takes nothing returns nothing
        local unit caster = Event_WaveHit_Caster
        local unit target = Event_WaveHit_Target
        local real damage = LoadReal( udg_hash, GetHandleId(Event_WaveHit_Wave), StringHash( "anss" ) )
        
        set IsDisableSpellPower = true
        call UnitTakeDamage(caster, target, damage, DAMAGE_TYPE_MAGIC)
                
        set caster = null
        set target = null
    endfunction
    
    function Trig_Ancient_Sword_Actions takes nothing returns nothing
        local unit caster = udg_DamageEventSource
        local unit target = udg_DamageEventTarget
        local effect wave
        //local real yaw
        local real damage = DAMAGE * GetUnitSpellPower(caster)
        //local integer id

        /*set wave = AddSpecialEffect( WAVE_ANIMATION, GetUnitX(caster), GetUnitY(caster))
        set yaw = Deg2Rad(AngleBetweenUnits(target, caster))
        call BlzSetSpecialEffectYaw( wave, yaw )
        
        set id = InvokeTimerWithEffect( wave, "anss", TICK, true, function Ancient_SwordCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "anssc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "anss" ), damage )
        call SaveReal( udg_hash, id, StringHash( "anssy" ), yaw )
        call SaveGroupHandle( udg_hash, id, StringHash( "anssg" ), CreateGroup() )*/
        
        set wave = Wave_CreateWave( caster, GetUnitX(caster), GetUnitY(caster), GetUnitFacing(caster), TICK, AREA, FLIGHT_LENGTH, SPEED, TARGET_ENEMY, WAVE_BASE_ANIMATION, Wave_Use, null )
        call SaveReal( udg_hash, GetHandleId(wave), StringHash( "anss" ), damage)
        
        set wave = null
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Ancient_Sword_Actions, function Trig_Ancient_Sword_Conditions )
        
        set Wave_Use = CreateTrigger()
        call TriggerAddAction( Wave_Use, function Use )
    endfunction
endscope

