library Lightning

    globals
        private lightning TempLightning = null
    endglobals

    private function End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "light" ) ) )
        call FlushChildHashtable( udg_hash, id )
    endfunction

    public function CreateLightning takes string lightningType, real xStart, real yStart, real zStart, real xEnd, real yEnd, real zEnd, real lifeTime returns lightning
        local integer id
    
        set TempLightning = AddLightningEx("AFOD", true, xStart, yStart, zStart, xEnd, yEnd, zEnd )
                
        set id = GetHandleId( TempLightning )
        call SaveTimerHandle( udg_hash, id, StringHash( "light" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "light" ) ) ) 
        call SaveLightningHandle( udg_hash, id, StringHash( "light" ), TempLightning )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( TempLightning ), StringHash( "light" ) ), lifeTime, false, function End )
        
        return TempLightning
    endfunction

endlibrary