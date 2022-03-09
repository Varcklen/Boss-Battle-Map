scope CircusW initializer init

    globals
        private constant integer ID_ABILITY = 'A0SI'
        
        private constant integer WAVES = 8
        private constant integer ANGLE_DIFFERENCE = 45
        private constant integer DAMAGE_FIRST_LEVEL = 100
        private constant integer DAMAGE_LEVEL_BONUS = 25
        private constant real TICK = 0.04
        
        private constant integer FLIGHT_LENGTH = 30
        private constant integer AREA = 128
        private constant integer SPEED = 30
        
        private constant string WAVE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
        
        private trigger Wave_Use = null
    endglobals

    function Trig_CircusW_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    /*private function DealDamage takes effect wave, integer id returns nothing
        local group g = CreateGroup()
        local unit u
        local real currentDamage
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "crcwc" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "crcwd" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "crcwg" ) )
        
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                set currentDamage = damage
                if GetUnitAbilityLevel( u, 'B1B1') > 0 then
                    set currentDamage = currentDamage + damage
                endif
                if GetUnitAbilityLevel( u, 'B1B2') > 0 then
                    set currentDamage = currentDamage + damage
                endif
                if GetUnitAbilityLevel( u, 'B1B3') > 0 then
                    set currentDamage = currentDamage + damage
                endif
                if GetUnitAbilityLevel( u, 'B1B4') > 0 then
                    set currentDamage = currentDamage + damage
                endif
                call DemomanCurse( caster, u )
                set IsDisableSpellPower = true
                call UnitTakeDamage(caster, u, currentDamage, DAMAGE_TYPE_MAGIC)
                call GroupAddUnit( nodmg, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
        set wave = null
        set nodmg = null
    endfunction
    
    private function DeleteGroup takes group affected returns nothing
        local integer count = LoadInteger( udg_hash, GetHandleId(affected), StringHash( "crcwc" ) ) - 1
        
        if affected != null then
            if count <= 0 then
                call RemoveSavedInteger( udg_hash, GetHandleId(affected), StringHash( "crcwc" ) )
                call GroupClear( affected )
                call DestroyGroup( affected )
            else
                call SaveInteger( udg_hash, GetHandleId(affected), StringHash( "crcwc" ), count )
            endif
        endif
    
        set affected = null
    endfunction

    private function WaveCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "crcw" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "crcw" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "crcwy" ) )
        local point newPoint = 0
        
        if counter >= FLIGHT_LENGTH or wave == null then
            call DestroyEffect( wave )
            call DeleteGroup( LoadGroupHandle( udg_hash, id, StringHash( "crcwg" ) ) )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set newPoint = GetMovedPoint( wave, yaw, SPEED )
            call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )
            call DealDamage( wave, id )
            call SaveInteger( udg_hash, id, StringHash( "crcw" ), counter )
        endif

        call newPoint.destroy()
        set wave = null
    endfunction
    
    private function CreateWave takes unit caster, real angle, real damage, group affected returns nothing
        local effect wave
        local real yaw
        local integer id
        local integer count = LoadInteger( udg_hash, GetHandleId(affected), StringHash( "crcwc" ) )
    
        set wave = AddSpecialEffect( WAVE_ANIMATION, GetUnitX(caster), GetUnitY(caster))
        set yaw = Deg2Rad(angle)
        call BlzSetSpecialEffectYaw( wave, yaw )
        
        set id = InvokeTimerWithEffect( wave, "crcw", TICK, true, function WaveCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "crcwc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "crcwy" ), yaw )
        call SaveReal( udg_hash, id, StringHash( "crcwd" ), damage )
        call SaveGroupHandle( udg_hash, id, StringHash( "crcwg" ), affected )
        call SaveInteger( udg_hash, GetHandleId(affected), StringHash( "crcwc" ), count + 1 )
    
        set wave = null
        set caster = null
        set affected = null
    endfunction*/
    
    private function DealDamage takes nothing returns nothing
        local unit caster = Event_WaveHit_Caster
        local unit target = Event_WaveHit_Target
        local real damage = LoadReal( udg_hash, GetHandleId(Event_WaveHit_Wave), StringHash( "crcwd" ) )
        local real currentDamage = damage
        
        if GetUnitAbilityLevel( target, 'B1B1') > 0 then
            set currentDamage = currentDamage + damage
        endif
        if GetUnitAbilityLevel( target, 'B1B2') > 0 then
            set currentDamage = currentDamage + damage
        endif
        if GetUnitAbilityLevel( target, 'B1B3') > 0 then
            set currentDamage = currentDamage + damage
        endif
        if GetUnitAbilityLevel( target, 'B1B4') > 0 then
            set currentDamage = currentDamage + damage
        endif
        call DemomanCurse( caster, target )
        set IsDisableSpellPower = true
        call UnitTakeDamage(caster, target, currentDamage, DAMAGE_TYPE_MAGIC)
                
        set caster = null
        set target = null
    endfunction

    function Trig_CircusW_Actions takes nothing returns nothing
        local integer i
        local real damage
        local unit caster
        local integer lvl
        local group affected
        local effect wave
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        endif

        set damage = (DAMAGE_FIRST_LEVEL+(DAMAGE_LEVEL_BONUS*lvl)) * GetUnitSpellPower(caster)
        set affected = CreateGroup()
        
        set i = 1
        loop
            exitwhen i > WAVES
            //call CreateWave(caster, ANGLE_DIFFERENCE * i, damage, affected)
            set wave = Wave_CreateWave( caster, GetUnitX(caster), GetUnitY(caster), ANGLE_DIFFERENCE * i, TICK, AREA, FLIGHT_LENGTH, SPEED, TARGET_ENEMY, WAVE_BASE_ANIMATION, Wave_Use, affected )
            call SaveReal( udg_hash, GetHandleId(wave), StringHash( "crcwd" ), damage)
            set i = i + 1
        endloop
        
        set affected = null
        set caster = null
        set wave = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_CircusW = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_CircusW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_CircusW, Condition( function Trig_CircusW_Conditions ) )
        call TriggerAddAction( gg_trg_CircusW, function Trig_CircusW_Actions )
        
        set Wave_Use = CreateTrigger()
        call TriggerAddAction( Wave_Use, function DealDamage )
    endfunction

endscope