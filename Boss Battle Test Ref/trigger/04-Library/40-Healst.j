library HealstLib requires DummyspawnLib, Inventory, TimebonusLib, RandomTargetLib, Multiboard, ShieldstLib

    globals
        real Event_OnHealChange_Real
        real Event_OnHealChange_StaticHeal
        real Event_OnHealChange_Heal
        unit Event_OnHealChange_Caster
        unit Event_OnHealChange_Target
        
        real Event_AfterHealChange_Real
        real Event_AfterHealChange_StaticHeal
        real Event_AfterHealChange_Heal
        unit Event_AfterHealChange_Caster
        unit Event_AfterHealChange_Target
        
        real Event_AfterHeal_Real
        real Event_AfterHeal_Heal
        unit Event_AfterHeal_Caster
        unit Event_AfterHeal_Target
        
        boolean IsHealFromPotion = false
    endglobals

    function PeacelockE_End takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit n = LoadUnitHandle( udg_hash, id, StringHash( "pcke" ) )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "pckec" ) )
        local real dmg = LoadReal( udg_hash, id, StringHash( "pcke" ) )

        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", n, "origin" ) )
        call dummyspawn( u, 1, 0, 0, 0 )
        call UnitDamageTarget( bj_lastCreatedUnit, n, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)

        call FlushChildHashtable( udg_hash, id )

        set n = null
        set u = null
    endfunction

    function OrbHolyFire takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "orbhf" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "orbhfc" ) )
        local real dmg = LoadReal( udg_hash, id, StringHash( "orbhf" ) )
        local group g = CreateGroup()
        local unit u

        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", target, "origin" ) )
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then 
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
        endloop

        call FlushChildHashtable( udg_hash, id )

        call GroupClear( g )
        call DestroyGroup( g )
        set g = null
        set u = null
        set target = null
        set caster = null
    endfunction

    private function HealUnit takes unit caster, unit target, real r returns nothing
        local integer i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
        local integer cyclA = 1
        local integer id
        local real t
        local real tm
        local real rst
        local real rfun
        local real rsp = r
        local real hlp = LoadReal( udg_hash, GetHandleId( udg_hero[i] ), StringHash( "healpot" ) )
        local unit u
        local unit n
        local real h = r
        local real p

        if target == null then
            set u = caster
        else
            set u = target
        endif
        
        set Event_OnHealChange_StaticHeal = h
        set Event_OnHealChange_Heal = h
        set Event_OnHealChange_Caster = caster
        set Event_OnHealChange_Target = u
    
        set Event_OnHealChange_Real = 0.00
        set Event_OnHealChange_Real = 1.00
        set Event_OnHealChange_Real = 0.00
        
        set rsp = Event_OnHealChange_Heal
        
        if GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            set rsp = rsp + ( h * ( udg_BossHeal[i] - 1 ) )
        endif
        set rsp = rsp + ( h * ( RMaxBJ( 0, GetUnitSpellPower(caster) ) - 1 ) )
        
        if GetUnitAbilityLevel( u, 'B04T') > 0 then
            set rsp = rsp+h
        endif
        if GetUnitAbilityLevel( u, 'B04S') > 0 then
            set rsp = rsp + (h*0.5)
        endif
        if inv( caster, 'I0A0') > 0 and luckylogic( caster, 25, 1, 100 ) then
            set rsp = rsp + h
        endif
        if inv( caster, 'I0AU') > 0 then
            set rsp = rsp + (h*0.2)
        endif
        if GetUnitAbilityLevel( u, 'B08R' ) > 0 then
            set rsp = rsp + (h*LoadReal( udg_hash, GetHandleId( u ), StringHash( "snkwh" ) ) )
        endif
        if inv( u, 'I00D') > 0 and not(udg_logic[GetPlayerId( GetOwningPlayer( u ) ) + 1 + 26]) then
            set rsp = rsp - (h*0.4)
        endif
        if GetUnitAbilityLevel(caster, 'B09J') > 0 then
            set rsp = rsp + h
        endif
        if udg_modbad[13] then
            set rsp = rsp - (h*0.15)
        endif
        if inv( caster, 'I0DZ') > 0 then
            set rsp = rsp + (h*1.5)
        endif
        if GetUnitAbilityLevel( u, 'B04O') > 0 then
            set rsp = rsp + (LoadReal( udg_hash, GetHandleId( u ), StringHash( "pckrb" ))*h) 
        endif
        if GetUnitAbilityLevel( u, 'A0VX') > 0 then
            set rsp = rsp + ( h * ( 0.2 * GetUnitAbilityLevel( u, 'A0VX') ) )
        endif
        if GetUnitAbilityLevel( caster, 'B014') > 0 then
            set rsp = rsp + (h*0.75)
        endif 
        if GetUnitAbilityLevel( caster, 'B04T') > 0 then
            set rsp = rsp + h
        endif
        ///
        set Event_AfterHealChange_StaticHeal = rsp
        set Event_AfterHealChange_Heal = rsp
        set Event_AfterHealChange_Caster = caster
        set Event_AfterHealChange_Target = u
    
        set Event_AfterHealChange_Real = 0.00
        set Event_AfterHealChange_Real = 1.00
        set Event_AfterHealChange_Real = 0.00
        
        set rsp = Event_AfterHealChange_Heal
        
        if udg_logic[73] then
            set rsp = rsp * udg_real[0]
        endif
        if GetUnitAbilityLevel( u, 'B03F') > 0 then
            set rsp = 0
        endif
        if inv( u, 'I09N') > 0 then
            set rsp = 0
        endif
        if GetUnitAbilityLevel( u, 'B07E') > 0 then
            set rsp = 0
        endif
        if GetUnitAbilityLevel( u, 'B07W') > 0 then
            set rsp = 0
        endif
        ///
        if GetUnitState( u, UNIT_STATE_LIFE) >= ( GetUnitState( u, UNIT_STATE_MAX_LIFE ) - rsp ) then
            if inv( caster, 'I0CN') > 0 then
                call shield( u, u, rsp*0.3, 60 )
            endif
            set rfun = GetUnitState( u, UNIT_STATE_MAX_LIFE ) - GetUnitState( u, UNIT_STATE_LIFE )
        else
            set rfun = rsp
        endif
        ///
        if rfun >= 1 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            set t = 8
            set rst = rfun
            loop
                exitwhen cyclA > 1
                if rst >= 200 then
                    set rst = rst - 200
                    set t = t + 1
                    set cyclA = cyclA - 1
                endif
                set cyclA = cyclA + 1
            endloop
            if t > 16 then
                set t = 16
            endif
              
            if inv( caster, 'I08E') > 0 and rfun >= 200 then
                call bufst( caster, u, 'A0SX', 'B013', "smou", timebonus(caster, 7) )
            endif
            if inv( caster, 'I0DZ') > 0 and GetUnitAbilityLevel( u, 'B07W') == 0 then
                call bufst( caster, u, 'A0P0', 'B07W', "idos", 5 )
            endif
            if not(udg_DamageHealLoop) then
                if GetUnitAbilityLevel( u, 'B03A') > 0 then
                    set n = randomtarget( u, 600, "enemy", "", "", "", "" )
                    if n != null then
                        set id = GetHandleId( n )
                
                        if LoadTimerHandle( udg_hash, id, StringHash( "pcke" ) ) == null then
                            call SaveTimerHandle( udg_hash, id, StringHash( "pcke" ), CreateTimer() )
                        endif
                        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pcke" ) ) ) 
                        call SaveUnitHandle( udg_hash, id, StringHash( "pcke" ), n )
                        call SaveUnitHandle( udg_hash, id, StringHash( "pckec" ), udg_unit[0] )
                        call SaveReal( udg_hash, id, StringHash( "pcke" ), rfun*udg_real[2] )
                        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( n ), StringHash( "pcke" ) ), 0.01, false, function PeacelockE_End )
                    endif
                endif
                if inv( u, 'I0FN') > 0 then
                    set id = GetHandleId( u )
            
                    if LoadTimerHandle( udg_hash, id, StringHash( "orbhf" ) ) == null then
                        call SaveTimerHandle( udg_hash, id, StringHash( "orbhf" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "orbhf" ) ) ) 
                    call SaveUnitHandle( udg_hash, id, StringHash( "orbhf" ), u )
                    call SaveUnitHandle( udg_hash, id, StringHash( "orbhfc" ), caster )
                    call SaveReal( udg_hash, id, StringHash( "orbhf" ), rfun*0.4 )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "orbhf" ) ), 0.01, false, function OrbHolyFire )
                endif
            endif
            
            call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_LIFE ) + rfun )
            call textst( "|c0000C800 +" + I2S( R2I( rfun ) ), u, 64, GetRandomReal( 45, 135 ), t, 1 )
            if udg_combatlogic[i] and not( udg_fightmod[3] ) and not( udg_logic[43] ) then
                set udg_HealFight[i] = udg_HealFight[i] + rfun
                set udg_HealAllTime[i] = udg_HealAllTime[i] + rfun
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 9,  I2S( R2I( udg_HealAllTime[i] ) ) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 10, I2S( R2I( udg_HealFight[i] ) ) )
                if inv(caster, 'I0E3') > 0 then
                    call ChangeToolItem( caster, 'I0E3', "|cffbe81f7", "|r", I2S(R2I(0.35*udg_HealFight[i])) )
                endif
            endif

            set Event_AfterHeal_Heal = rfun
            set Event_AfterHeal_Caster = caster
            set Event_AfterHeal_Target = u
            set Event_AfterHeal_Real = 0.00
            set Event_AfterHeal_Real = 1.00
            set Event_AfterHeal_Real = 0.00
            
            set udg_DamageHealLoop = false
        endif
        
        set IsHealFromPotion = false
        
        set caster = null
        set target = null
        set u = null
        set n = null
    endfunction
    
    function EndHealTimer takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "heal" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "healc" ) )
        local real r = LoadReal( udg_hash, id, StringHash( "heal" ) )
    
        call HealUnit( caster, target, r )
        call FlushChildHashtable( udg_hash, id )
    
        set caster = null
        set target = null
    endfunction

    function healst takes unit caster, unit target, real r returns nothing
        local integer id = 0
        if IsAttack then
            set id = GetHandleId( caster )
            call SaveTimerHandle( udg_hash, id, StringHash("heal"), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash("heal") ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash("healc"), caster )
            call SaveUnitHandle( udg_hash, id, StringHash( "heal" ), target ) 
            call SaveReal( udg_hash, id, StringHash( "heal" ), r ) 
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash("heal") ), 0.01, false, function EndHealTimer)
        else
            call HealUnit( caster, target, r )
        endif
        
        set caster = null
        set target = null
    endfunction

endlibrary