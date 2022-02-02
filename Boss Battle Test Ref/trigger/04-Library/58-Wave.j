library Wave

    globals
        private constant string WAVE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
    endglobals

    private function WaveUse takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "wave" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "wave" ) )
        local unit mainer = LoadUnitHandle( udg_hash, id, StringHash( "wavem" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "waveg" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "wavey" ) )
        local real speed = LoadReal( udg_hash, id, StringHash( "waves" ) )
        local integer range = LoadInteger( udg_hash, id, StringHash( "waver" ) )
        local point newPoint = 0
        
        if counter >= range or wave == null then
            call DestroyEffect( wave )
            call GroupClear( nodmg )
            call DestroyGroup( nodmg )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set newPoint = GetMovedPoint( wave, yaw, speed )
            call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )
            
            
            //call DealDamage( wave, nodmg, mainer )
            call SaveInteger( udg_hash, id, StringHash( "wave" ), counter )
        endif

        call newPoint.destroy()
        set wave = null
        set mainer = null
        set nodmg = null
    endfunction
    
    private function CreateWave takes unit mainer, real x, real y, real angle, real tick, integer range, real speed returns nothing
        local effect wave
        local real yaw
        local integer id
    
        set wave = AddSpecialEffect( WAVE_ANIMATION, x, y)
        set yaw = Deg2Rad(angle)
        call BlzSetSpecialEffectYaw( wave, yaw )
        
        set id = InvokeTimerWithEffect( wave, "wave", tick, true, function WaveUse )
        call SaveUnitHandle( udg_hash, id, StringHash( "wavem" ), mainer )
        call SaveReal( udg_hash, id, StringHash( "wavey" ), yaw )
        call SaveReal( udg_hash, id, StringHash( "waves" ), speed )
        call SaveInteger( udg_hash, id, StringHash( "waver" ), range )
        call SaveGroupHandle( udg_hash, id, StringHash( "waveg" ), CreateGroup() )
    
        set wave = null
        set mainer = null
    endfunction
endlibrary
