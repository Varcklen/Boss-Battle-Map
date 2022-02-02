scope SuperBoom initializer init

    globals
        private constant integer ID_ABILITY = 'A02L'
        
        private constant integer WAVES = 6
        private constant integer ANGLE_DIFFERENCE = 60
        private constant integer DAMAGE = 100
        private constant real TICK = 0.04
        
        private constant integer FLIGHT_LENGTH = 60
        private constant integer AREA = 128
        private constant integer SPEED = 30
        
        private constant string WAVE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
    endglobals

    function Trig_SuperBoom_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function DealDamage takes effect wave, group nodmg, unit caster, real damage returns nothing
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
        set caster = null
        set wave = null
        set nodmg = null
    endfunction

    function SuperBoomCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "supb" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "supb" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "supbc" ) )
        local real damage = LoadReal( udg_hash, id, StringHash( "supbd" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "supbg" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "supby" ) )
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
            call SaveInteger( udg_hash, id, StringHash( "supb" ), counter )
        endif

        call newPoint.destroy()
        set wave = null
        set caster = null
        set nodmg = null
    endfunction
    
    private function CreateWave takes unit caster, real angle, real damage returns nothing
        local effect wave
        local real yaw
        local integer id
    
        set wave = AddSpecialEffect( WAVE_ANIMATION, GetUnitX(caster), GetUnitY(caster))
        set yaw = Deg2Rad(angle)
        call BlzSetSpecialEffectYaw( wave, yaw )
        
        set id = InvokeTimerWithEffect( wave, "supb", TICK, true, function SuperBoomCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "supbc" ), caster )
        call SaveReal( udg_hash, id, StringHash( "supby" ), yaw )
        call SaveReal( udg_hash, id, StringHash( "supbd" ), damage )
        call SaveGroupHandle( udg_hash, id, StringHash( "supbg" ), CreateGroup() )
    
        set wave = null
        set caster = null
    endfunction

    function Trig_SuperBoom_Actions takes nothing returns nothing
        local integer i
        local integer id 
        local unit caster
        local real damage
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        
        set damage = DAMAGE * GetUnitSpellPower(caster)
        
        set i = 1
        loop
            exitwhen i > WAVES
            call CreateWave(caster, ANGLE_DIFFERENCE * i, damage)
            set i = i + 1
        endloop
        
        set caster = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SuperBoom = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SuperBoom, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SuperBoom, Condition( function Trig_SuperBoom_Conditions ) )
        call TriggerAddAction( gg_trg_SuperBoom, function Trig_SuperBoom_Actions )
    endfunction

endscope