library Wave

    globals
        constant string WAVE_BASE_ANIMATION = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
        
        unit Event_WaveHit_Caster
        unit Event_WaveHit_Target
        effect Event_WaveHit_Wave
        
        private effect tempEffect = null
    endglobals
    
    private function AddGroupCount takes group waveGroup, boolean isAdded returns nothing
        local integer count
        local integer add = -1
        
        if waveGroup == null then
            return
        endif
        
        if isAdded then
            set add = 1
        endif
        set count = LoadInteger( udg_hash, GetHandleId(waveGroup), StringHash( "wavec" ) ) + add
        if count <= 0 then
            call RemoveSavedReal( udg_hash, GetHandleId( waveGroup ), StringHash( "wavec" ) )
            call GroupClear( waveGroup )
            call DestroyGroup( waveGroup )
        else
            call SaveInteger( udg_hash, GetHandleId(waveGroup), StringHash( "wavec" ), count )
        endif
        
        set waveGroup = null
    endfunction

    private function End takes integer id, effect wave returns nothing
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "waveg" ) )
        local group waveGroup = LoadGroupHandle( udg_hash, id, StringHash( "wavewg" ) )
    
        call AddGroupCount(waveGroup, false)
        call DestroyEffect( wave )
        call GroupClear( nodmg )
        call DestroyGroup( nodmg )
        
        set wave = null
    endfunction
    
    private function DealDamage takes integer id, effect wave returns nothing
        local unit mainer = LoadUnitHandle( udg_hash, id, StringHash( "wavem" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "waveg" ) )
        local group waveGroup = LoadGroupHandle( udg_hash, id, StringHash( "wavewg" ) )
        local real area = LoadReal( udg_hash, id, StringHash( "wavea" ) )
        local trigger usedTrigger = LoadTriggerHandle(udg_hash, id, StringHash( "wavet" ) )
        local string targetRelation = LoadStr( udg_hash, id, StringHash( "wavetr" ) )
        local group g = CreateGroup()
        local unit u
        
        call GroupEnumUnitsInRange( g, BlzGetLocalSpecialEffectX( wave ), BlzGetLocalSpecialEffectY( wave ), area, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, mainer, targetRelation ) and IsUnitInGroup( u, nodmg ) == false and IsUnitInGroup( u, waveGroup ) == false then
                set Event_WaveHit_Caster = mainer
                set Event_WaveHit_Target = u
                set Event_WaveHit_Wave = wave
                call TriggerExecute( usedTrigger )
                call GroupAddUnit( nodmg, u )
                if waveGroup != null then
                    call GroupAddUnit( waveGroup, u )
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set mainer = null
        set nodmg = null
        set wave = null
        set waveGroup = null
    endfunction
    
    private function ChangePosition takes integer id, effect wave returns nothing
        local real speed = LoadReal( udg_hash, id, StringHash( "waves" ) )
        local real yaw = LoadReal( udg_hash, id, StringHash( "wavey" ) )
        local point newPoint = 0
        
        set newPoint = GetMovedPoint( wave, yaw, speed )
        call BlzSetSpecialEffectPosition( wave, newPoint.x, newPoint.y, BlzGetLocalSpecialEffectZ(wave) )
        
        call newPoint.destroy()
        set wave = null
    endfunction

    private function WaveUse takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "wave" ) ) + 1
        local effect wave = LoadEffectHandle( udg_hash, id, StringHash( "wave" ) )
        local integer range = LoadInteger( udg_hash, id, StringHash( "waver" ) )
        
        if counter >= range or wave == null then
            call End(id, wave)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call ChangePosition(id, wave)
            call DealDamage( id, wave )
            call SaveInteger( udg_hash, id, StringHash( "wave" ), counter )
        endif
        
        set wave = null
    endfunction
    
    public function CreateWave takes unit mainer, real x, real y, real angle, real tick, real area, integer range, real speed, string targetRelation, string waveAnimation, trigger usedTrigger, group waveGroup returns effect
        local real yaw
        local integer id
        local group nodmg = CreateGroup()
    
        if waveAnimation == null or mainer == null or speed <= 0 or usedTrigger == null or targetRelation == null then
            call BJDebugMsg("Warning! The wave cannot be created!")
            call BJDebugMsg("waveAnimation: " + waveAnimation )
            call BJDebugMsg("mainer: " + GetUnitName(mainer))
            call BJDebugMsg("speed: " + R2S(speed))
            call BJDebugMsg("targetRelation: " + targetRelation)
            if usedTrigger == null then
                call BJDebugMsg("usedTrigger is null")
            endif
            return null
        endif
        
        set tempEffect = AddSpecialEffect( waveAnimation, x, y)
        set yaw = Deg2Rad(angle)
        call BlzSetSpecialEffectYaw( tempEffect, yaw )
        
        set id = InvokeTimerWithEffect( tempEffect, "wave", tick, true, function WaveUse )
        call SaveUnitHandle( udg_hash, id, StringHash( "wavem" ), mainer )
        call SaveReal( udg_hash, id, StringHash( "wavey" ), yaw )
        call SaveReal( udg_hash, id, StringHash( "waves" ), speed )
        call SaveReal( udg_hash, id, StringHash( "wavea" ), area )
        call SaveStr( udg_hash, id, StringHash( "wavetr" ), targetRelation )
        call SaveInteger( udg_hash, id, StringHash( "waver" ), range )
        call SaveGroupHandle( udg_hash, id, StringHash( "waveg" ), nodmg )
        call SaveTriggerHandle(udg_hash, id, StringHash( "wavet" ), usedTrigger )
        if waveGroup != null then
            call SaveGroupHandle( udg_hash, id, StringHash( "wavewg" ), waveGroup )
            call AddGroupCount(waveGroup, true)
        endif
    
        set mainer = null
        set waveGroup = null
        set nodmg = null
        return tempEffect
    endfunction
endlibrary
