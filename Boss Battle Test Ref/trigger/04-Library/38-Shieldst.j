library ShieldstLib requires BuffsLibLib

    globals
        real Event_ShieldDestroyed_Real
        unit Event_ShieldDestroyed_Hero
    endglobals

    function ShieldEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shield" ) )
        local texttag tt = LoadTextTagHandle( udg_hash, id, StringHash( "shieldtt" ) )

        if tt != null then
            call DestroyTextTag( tt )
        endif
        call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shield" ), 0 )
        call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shieldMax" ), 0 )
        
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction
    
    function RemoveShield takes unit u returns nothing
        local integer unitId = GetHandleId( u )
        local texttag tx = LoadTextTagHandle( udg_hash, unitId, StringHash( "shldtx" ) )
    
        call DestroyTextTag( tx )
        call SaveTextTagHandle( udg_hash, unitId, StringHash( "shldtx" ), null )
        call SaveReal( udg_hash, unitId, StringHash( "shield" ), 0 )
        call SaveReal( udg_hash, unitId, StringHash( "shieldMax" ), 0 )
        call UnitRemoveAbility( u, 'A11F' )
        call UnitRemoveAbility( u, 'B05P' )
        
        set Event_ShieldDestroyed_Hero = u
        set Event_ShieldDestroyed_Real = 0.00
        set Event_ShieldDestroyed_Real = 1.00
        set Event_ShieldDestroyed_Real = 0.00
        
        set tx = null
        set u = null
    endfunction

    function ShieldCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "shld" ) )
        local texttag tx = LoadTextTagHandle( udg_hash, GetHandleId( u ), StringHash( "shldtx" ) )
        local real l = LoadReal( udg_hash, GetHandleId( u ), StringHash( "shield" ) )
        local real lmax = LoadReal( udg_hash, GetHandleId( u ), StringHash( "shieldMax" ) )

        if l < 1 or GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 or tx == null then
            call RemoveShield(u)
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SetTextTagText(tx, I2S(R2I(l)) + "/" + I2S(R2I(lmax)), 0.03 )
            call SetTextTagPosUnit(tx, u, -300)
        endif
        
        set u = null
        set tx = null
    endfunction

    function shield takes unit caster, unit target, real sh, real t returns nothing
        local integer id
        local real l 
        local real lmax
        local texttag tt = null
        local unit u
        
        if target == null then
            set u = caster
        else
            set u = target
        endif
        
        if IsUnitType( u, UNIT_TYPE_HERO) or IsUnitType( u, UNIT_TYPE_ANCIENT) and sh > 0 then
            call effst( caster, u, null, 1, t )
        
            set sh = sh * GetUnitSpellPower(caster)
            set l = LoadReal( udg_hash, GetHandleId( u ), StringHash( "shield" ) ) + sh
            set lmax = LoadReal( udg_hash, GetHandleId( u ), StringHash( "shieldMax" ) )
            if l > lmax then
                set lmax = l
            endif
            
            if LoadTextTagHandle( udg_hash, GetHandleId( u ), StringHash( "shldtx" ) ) == null then
                if l >= 100 then
                    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl", u, "origin" ) )
                endif
                set id = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "shld" ) ) == null then
                    call SaveTimerHandle( udg_hash, id, StringHash( "shld" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shld" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "shld" ), u )
                set tt = CreateTextTag()
                call SetTextTagText(tt, I2S(R2I(l)) + "/" + I2S(R2I(lmax)), 0.03)
                call SetTextTagPosUnit(tt, u, -300)
                call SetTextTagColor(tt, 153, 153, 255, 127 )
                call SaveTextTagHandle( udg_hash, GetHandleId( u ), StringHash( "shldtx" ), tt )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "shld" ) ), 0.04, true, function ShieldCast )
            endif

            call UnitAddAbility( u, 'A11F' )
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shield"  ), l )
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "shieldMax" ), lmax )
            
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "shield" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "shield" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shield" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "shield" ), u )
            if tt != null then
                call SaveTextTagHandle( udg_hash, id, StringHash( "shieldtt" ), tt )
            endif
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "shield" ) ), t, false, function ShieldEnd )
        endif
        
        set target = null
        set caster = null
        set u = null
        set tt = null
    endfunction

endlibrary