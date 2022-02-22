library ManastLib requires Inventory, LuckylogicLib, ShieldstLib, Multiboard, HealstLib

    function manast takes unit caster, unit target, real r returns nothing
        local integer i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
        local integer cyclA = 1
        local real t = 8
        local real rst
        local real rfun
        local real rsp = r
        local unit u
        local real h = r

        if target == null then
            set u = caster
        else
            set u = target
        endif
        
        set rsp = rsp+(h*(udg_BossHeal[i]-1))
        set rsp = rsp+(h*(RMaxBJ(0, GetUnitSpellPower(caster))-1))
        if inv( caster, 'I08I' ) > 0 then
            set rsp = rsp + (h*0.1*GetUnitLevel(caster))
        endif
        if GetUnitAbilityLevel( u, 'B04S') > 0 then
            set rsp = rsp + (h*0.5)
        endif
        if inv( caster, 'I0CW' ) > 0 then
            set rsp = rsp + h
        endif
        if GetUnitAbilityLevel( caster, 'B04T') > 0 then
            set rsp = rsp + h
        endif
        if udg_modbad[13] then
            set rsp = rsp - (h*0.15)
        endif
        if GetUnitState( u, UNIT_STATE_MANA ) >= ( GetUnitState( u, UNIT_STATE_MAX_MANA ) - rsp ) then
            set rfun = GetUnitState( u, UNIT_STATE_MAX_MANA ) - GetUnitState( u, UNIT_STATE_MANA )
        else
            set rfun = rsp
        endif
        
        if GetUnitAbilityLevel( u, 'B03F') > 0 then
            set rfun = 0
        endif

        if inv( caster, 'I0CW' ) > 0 then
            call healst( caster, target, rfun )
        endif
        
        if rfun >= 1 then
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

            if not(udg_DamageHealLoop) then
                if inv( u, 'I0DG') > 0 and caster != u then
                    set udg_DamageHealLoop = true
                    call manast(caster, null, rfun )
                endif
            endif
            set udg_DamageHealLoop = false
        
            call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA ) + rfun )
            call textst( "|c000000C8 +" + I2S( R2I( rfun ) ), u, 64, GetRandomReal( 45, 135 ), t, 1 )
            
            if udg_combatlogic[i] and not( udg_fightmod[3] ) and not( udg_logic[43] ) then
                set udg_ManaFight[i] = udg_ManaFight[i] + rfun
                set udg_ManaAllTime[i] = udg_ManaAllTime[i] + rfun
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 11, I2S( R2I( udg_ManaAllTime[i] ) ) )
                call MultiSetValue( udg_multi, ( udg_Multiboard_Position[i] * 3 ) - 1, 12, I2S( R2I( udg_ManaFight[i] ) ) )
            endif
        endif
        
        set caster = null
        set target = null
        set u = null
    endfunction

endlibrary