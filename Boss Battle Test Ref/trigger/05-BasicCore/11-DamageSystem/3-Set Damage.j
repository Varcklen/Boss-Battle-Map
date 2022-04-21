function AdmWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit c = LoadUnitHandle( udg_hash, id, StringHash( "admr" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "admr" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "admrlvl" ) )
    local group g = CreateGroup()
    local unit u
    local integer gold = 0
    
    call dummyspawn( c, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "BarbarianSkinW.mdx", c, "origin") )
    call GroupEnumUnitsInRange( g, GetUnitX( c ), GetUnitY( c ), 500, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, c, "enemy" ) then
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
            set gold = gold + lvl
        endif
        call GroupRemoveUnit(g,u)
    endloop
    if udg_combatlogic[GetPlayerId( GetOwningPlayer( c ) ) + 1] and not(udg_fightmod[3]) then
        call moneyst(c, gold)
    endif
    
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set c = null
endfunction

function Trig_Set_Damage_Actions takes nothing returns nothing
    local integer i = GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1
    local integer k = GetPlayerId( GetOwningPlayer(udg_DamageEventTarget) ) + 1
    local integer cyclA = 1
    local real l 
    local real sh
    local real dmg = udg_DamageEventAmount
    local integer id
    local integer g
    local unit u 
    local real t
    local integer p
   
    if udg_DamageReduction[k] != 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (udg_DamageReduction[k]*dmg) 
    endif
    if ( inv( udg_hero[k], 'I0AF' ) > 0 and not(udg_logic[k + 26]) ) or inv( udg_hero[i], 'I0AF' ) > 0  then
        set udg_DamageEventAmount = udg_DamageEventAmount + (0.25*dmg)   
    endif
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'BPSE') > 0 and GetUnitAbilityLevel( udg_DamageEventSource, 'B05J') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount * 2  
    endif
    if GetUnitAbilityLevel( udg_DamageEventSource, 'B07Y') > 0 then
        call UnitRemoveAbility( udg_DamageEventSource, 'A02Z' )
        call UnitRemoveAbility( udg_DamageEventSource, 'B07Y' )
        set udg_DamageEventAmount = udg_DamageEventAmount + (3*dmg) 
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B073') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (dmg*0.2)
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B07U') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*0.25)
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'B088') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*0.75)
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'B09J') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + dmg
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B09J') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (0.5*dmg)
    endif
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0LH') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount + LoadInteger( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "wndrb" ) )
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'B08L') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*0.4)
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'B08P') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*0.4)
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'B035') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*0.4)
    endif
    if GetUnitAbilityLevel( udg_DamageEventSource, 'B04O') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount + (LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "pckrb" ))*dmg) 
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B08Q') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (dmg*0.15)
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A0VW') > 0 then
        set udg_DamageEventAmount = ( 0.95 - ( 0.05 * GetUnitAbilityLevel(udg_DamageEventTarget, 'A0VW') ) ) * udg_DamageEventAmount
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'A165') > 0 and inv( udg_hero[i], 'I03R' ) > 0 and GetUnitAbilityLevel(udg_DamageEventTarget, 'A16A') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount + (0.4*dmg)
    endif
    if GetUnitAbilityLevel(udg_hero[i], 'A0JV') > 0 and GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE ) <= ((0.2+(0.05*GetUnitAbilityLevel(udg_hero[i], 'A0JV')))*GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) ) and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventType = udg_DamageTypeCriticalStrike
        set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
    endif
    if inv(udg_DamageEventSource, 'I02Z') > 0 and IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT) then
        set udg_DamageEventAmount = udg_DamageEventAmount * 1.3
    endif
    if inv(udg_hero[i], 'I0DT') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = udg_DamageEventAmount + 15
    endif
    if GetUnitTypeId(udg_DamageEventSource) == 'n04F' then
        set l = LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "bdmg" ) ) + (0.02*udg_DamageEventAmount)
        set udg_DamageEventAmount = udg_DamageEventAmount + l
        if udg_DamageEventAmount >= GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE) then
            call SaveReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "bdmg" ), 1 )
        else
            call SaveReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "bdmg" ), l )
        endif
    endif
    if ( inv( udg_DamageEventTarget, 'I0D4') > 0 or ( udg_Set_Weapon_Logic[k + 84] and inv(udg_hero[k], 'I030') > 0 ) ) and ( GetUnitAbilityLevel( udg_DamageEventTarget, 'BPSE' ) > 0 or GetUnitAbilityLevel( udg_DamageEventTarget, 'BNsi' ) > 0 or GetUnitAbilityLevel( udg_DamageEventTarget, 'B043' ) > 0 ) then
        set udg_DamageEventAmount = udg_DamageEventAmount - (0.6*dmg) 
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A15P') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (dmg*LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "prdw1" )))
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A0DZ') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount + (LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "sslq" ))*dmg)
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A15Q') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount - (dmg*(0.03+(0.03*GetUnitAbilityLevel(udg_DamageEventTarget, 'A15Q'))))
    endif
    if GetUnitAbilityLevel(udg_DamageEventSource, 'A16N') > 0 and IsUnitEnemy( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) and udg_combatlogic[i] then
        set l = GetUnitAbilityLevel(udg_DamageEventSource, 'A16N') + 1
        set t = timebonus(udg_DamageEventSource, l)
    	call UnitAddAbility( udg_DamageEventTarget, 'A16P' )
        set id = GetHandleId( udg_DamageEventTarget )
        if LoadTimerHandle( udg_hash, id, StringHash( "mdne" ) ) == null then
          call SaveTimerHandle( udg_hash, id, StringHash( "mdne" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdne" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mdne" ), udg_DamageEventTarget )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "mdne" ) ), t, false, function MaidenECast )
    	
        call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, GetUnitAbilityLevel(udg_DamageEventSource, 'A16N'), t )
    endif
    if GetUnitTypeId(udg_DamageEventTarget) == 'e000' and (GetUnitTypeId(udg_DamageEventSource) == 'u000' or IsUnitType( udg_DamageEventSource, UNIT_TYPE_HERO)) then
        set udg_DamageEventAmount = udg_DamageEventAmount + (3*dmg) 
    endif
    //Физ. Урон
    if not( udg_IsDamageSpell ) then //GetUnitTypeId(udg_DamageEventSource) != 'u000' and
        if GetUnitTypeId(udg_DamageEventSource) == 'e004' then
            if GetUnitState( udg_DamageEventTarget, UNIT_STATE_MANA ) <= 30 then
                set udg_DamageEventAmount = udg_DamageEventAmount + 100 
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", udg_DamageEventTarget, "origin" ) )
            endif
            call SetUnitState( udg_DamageEventTarget, UNIT_STATE_MANA, RMaxBJ(0, GetUnitState( udg_DamageEventTarget, UNIT_STATE_MANA ) - ( 40 * GetUnitSpellPower(udg_DamageEventSource) ) ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'A0FL') > 0 then
            call MarshalRDamage(udg_DamageEventSource, GetUnitAbilityLevel( udg_DamageEventSource, 'A0FF'), dmg)
        endif
        
        if GetUnitAbilityLevel(udg_DamageEventSource, 'A0NZ') > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount + ( dmg * GARITHOS_MEDALLION_ATTACK_POWER_BONUS )
        endif
        
        if GetUnitName(udg_DamageEventSource) == "Crisp" then
            if GetUnitAbilityLevel(LoadUnitHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "bggrac" )), 'A0FD') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + ( ( 0.001 * GetUnitAbilityLevel( LoadUnitHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "bggrac" ) ), 'A0FD') ) * GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE ) )
            endif
        endif
        if GetUnitAbilityLevel(udg_DamageEventSource, 'A14R') > 0 and udg_combatlogic[GetPlayerId( GetOwningPlayer( udg_DamageEventSource ) ) + 1] and not(udg_fightmod[3]) then
            set p = LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mephw" ) ) + 1
            call moneyst( udg_DamageEventSource, IMaxBJ(2,p ) )
        endif
        
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0OG') > 0 then
            call EntW_Damage(udg_DamageEventTarget, udg_DamageEventSource)
        endif
        if IsUnitInGroup(udg_hero[i], udg_heroinfo) then
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A03X') > 0 then
                if CountLivingPlayerUnitsOfTypeId('n020', GetOwningPlayer(udg_DamageEventSource)) == 0 then
                    set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*(0.1+(0.1*GetUnitAbilityLevel(udg_DamageEventSource, 'A03X'))))
                endif
            endif
            if inv( udg_DamageEventSource, 'I090') > 0 then
                call bufst( udg_DamageEventSource, udg_DamageEventTarget, 'A0DS', 'B090', "orbf", 4 )
                call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, 1 )
            endif
            if inv( udg_DamageEventSource, 'I0EP') > 0 then
                call bufst( udg_DamageEventSource, udg_DamageEventTarget, 'A0RJ', 'B096', "orbe", 4 )
                call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, 1 )
            endif
            if inv( udg_DamageEventSource, 'I0DF') > 0 then
                call bufst( udg_DamageEventSource, udg_DamageEventTarget, 'A0HX', 'B092', "orbkl", 4 )
                call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, 1 )
            endif
            set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*udg_BossDamagePhysical[i])
            if inv( udg_DamageEventTarget, 'I0DB') > 0 or ( udg_Set_Weapon_Logic[i + 88] and inv(udg_DamageEventTarget, 'I030') > 0 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount - (0.1*dmg) 
            endif
            if inv( udg_DamageEventTarget, 'I09P') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + dmg
            endif
            if inv( udg_DamageEventTarget, 'I051') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount - (0.4*dmg)
            endif
            if GetUnitAbilityLevel( udg_DamageEventSource, 'A0TC') > 0 and BlzGetUnitAbilityCooldownRemaining(udg_DamageEventSource, 'A0TC') > 2 then
                call BlzStartUnitAbilityCooldown( udg_DamageEventSource, 'A0TC', BlzGetUnitAbilityCooldownRemaining(udg_DamageEventSource, 'A0TC') - 2 )
            endif
    	    if inv( udg_DamageEventSource, 'I0DU' ) > 0 and not(udg_logic[i + 26]) then
                set udg_DamageEventAmount = udg_DamageEventAmount - (0.9*dmg)  
    	    endif
            if inv( udg_DamageEventSource, 'I09P') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + dmg
            endif
            if GetUnitAbilityLevel( udg_DamageEventSource, 'B06H' ) > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + LoadInteger( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mtmqd" ) )
            endif
            if inv( udg_DamageEventSource, 'I05Z') > 0 or ( udg_Set_Weapon_Logic[i + 96] and inv(udg_hero[i], 'I030') > 0 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.45*dmg) 
            endif
            if inv( udg_DamageEventSource, 'I011') > 0 then
                set l = LoadReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "ktrs" ) ) + 1
                if l >= 7 then
                    call SaveReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "ktrs" ), 0 )
                    set udg_DamageEventType = udg_DamageTypeCriticalStrike
                    set udg_DamageEventAmount = udg_DamageEventAmount + (2*dmg)
                else
                    call SaveReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "ktrs" ), l )
                endif
            endif
            if GetUnitAbilityLevel( udg_DamageEventSource, 'A0B7' ) > 0 then
                set l = LoadReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "admr1" ) ) + 1
                if l >= 10 - GetUnitAbilityLevel( udg_DamageEventSource, 'A0B7' ) then
                    call SaveReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "admr1" ), 0 )

                    set id = GetHandleId( udg_DamageEventSource )
                    if LoadTimerHandle( udg_hash, id, StringHash( "admr" ) ) == null then
                        call SaveTimerHandle( udg_hash, id, StringHash( "admr" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "admr" ) ) ) 
                    call SaveReal( udg_hash, id, StringHash( "admr" ), udg_DamageEventAmount*2 )
                    call SaveInteger( udg_hash, id, StringHash( "admrlvl" ), GetUnitAbilityLevel( udg_DamageEventSource, 'A0B7' ) )
                    call SaveUnitHandle( udg_hash, id, StringHash( "admr" ), udg_DamageEventSource )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "admr" ) ), 0.01, false, function AdmWCast )
                else
                    call SaveReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "admr1" ), l )
                endif
            endif
            if inv(udg_DamageEventSource, 'I0AT') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + GetHeroInt( udg_DamageEventSource, true)
            endif
            if inv(udg_DamageEventSource, 'I06J') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*(GetUnitSpellPower(udg_DamageEventSource)-1))
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A0BQ') > 0 and not(IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO)) and not(IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT)) then
                set udg_DamageEventAmount = udg_DamageEventAmount + ( GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE ) * 0.5 )
    	    endif
            if GetUnitAbilityLevel( udg_DamageEventSource, 'A0GB') > 0 and luckylogic( udg_DamageEventSource, 20, 1, 100 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + GetUnitState(udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) * 0.005 * udg_SpellDamageSpec[i]
            endif
            if GetUnitAbilityLevel( udg_DamageEventSource, 'A03B') > 0 and luckylogic( udg_DamageEventSource, 40, 1, 100 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + GetUnitState(udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) * 0.01 * udg_SpellDamageSpec[i]
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A152') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*LoadReal( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "trme" ) ))
                set g = LoadInteger( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "trme" ) ) - 1
                call SaveInteger( udg_hash, GetHandleId(udg_DamageEventSource), StringHash( "trme" ), g )
                if g <= 0 then
                    call UnitRemoveAbility( udg_DamageEventSource, 'A152' )
                    call UnitRemoveAbility( udg_DamageEventSource, 'B06X' )
                endif
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'B05R') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + (3*dmg)
                call UnitRemoveAbility( udg_DamageEventSource, 'A128' )
                call UnitRemoveAbility( udg_DamageEventSource, 'B05R' )
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A0JI') > 0 and udg_hero[i] != null then
                set l = LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "pig" ) ) + 1
                if l >= 4 then
                    call SaveReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "pig" ), 0 )
                    set udg_DamageEventAmount = udg_DamageEventAmount + GetHeroAgi( udg_hero[i], true )
                else
                    call SaveReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "pig" ), l )
                endif
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A0VW') > 0 then
                set udg_DamageEventAmount = ( 1.05 + ( 0.05 * GetUnitAbilityLevel(udg_DamageEventSource, 'A0VW') ) ) * udg_DamageEventAmount
            endif
            if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0DP') > 0 then
                set id = GetHandleId( udg_DamageEventTarget )
                if LoadUnitHandle( udg_hash, id, StringHash( "ogrqt" ) ) == udg_DamageEventTarget and LoadUnitHandle( udg_hash, id, StringHash( "ogrqc" ) ) == udg_DamageEventSource then
                    set udg_DamageEventAmount = udg_DamageEventAmount + LoadReal( udg_hash, id, StringHash( "ogrq" ) )
                    set t = timebonus(udg_DamageEventSource, 3)
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "ogrq" ) ), t, false, function OgreQEnd )
                    call debuffst( udg_DamageEventSource, udg_DamageEventTarget, null, 1, t )
                endif
            endif 
            if GetUnitAbilityLevel( udg_DamageEventSource, 'A0EO') > 0 then
                set id = GetHandleId( udg_DamageEventSource )
                set l = LoadReal( udg_hash, id, StringHash( "ogrr" ) ) + LoadReal( udg_hash, id, StringHash( "ogrrc" ) )
                call SaveReal( udg_hash, id, StringHash( "ogrr" ), l )
                set udg_DamageEventAmount = udg_DamageEventAmount + (l*dmg)
            endif
            if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0E1') > 0 then
                set udg_DamageEventAmount = udg_DamageEventAmount + ( LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "ogrw" ) ) * dmg )
            endif
            if inv( udg_hero[i], 'I079') > 0 or ( udg_Set_Weapon_Logic[i + 56] and inv(udg_hero[i], 'I030') > 0 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount+ (0.1*dmg)
            endif
            if inv( udg_DamageEventSource, 'I0CP') > 0 or ( udg_Set_Weapon_Logic[i + 76] and inv(udg_DamageEventSource, 'I030') > 0 ) then
                if luckylogic( udg_DamageEventSource, 50, 1, 100 ) then
                    set udg_DamageEventAmount = udg_DamageEventAmount + (2*dmg) 
                else
                    set udg_DamageEventAmount = 0
                    set udg_DamageEventType = udg_DamageTypeBlocked
                endif
            endif
            if inv( udg_DamageEventSource, 'I0CF') > 0 or ( udg_Set_Weapon_Logic[i + 72] and inv(udg_DamageEventSource, 'I030') > 0 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + IMinBJ( 30, GetRandomInt( 1+GetUnitLuck(udg_DamageEventSource), 30 ) )
            endif
            if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0RK') > 0 then
                set l = LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "nerwd" ) )
                set udg_DamageEventAmount = udg_DamageEventAmount - (l*dmg)
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A0J8') > 0 and luckylogic( udg_DamageEventSource, 25, 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + dmg
            endif
            if inv(udg_DamageEventSource, 'I06A') > 0 and luckylogic( udg_DamageEventSource, 15, 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
            endif
            if inv(udg_DamageEventSource, 'I06K') > 0 and luckylogic( udg_DamageEventSource, 25, 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
            endif
            if inv(udg_DamageEventSource, 'I06K') > 0 and luckylogic( udg_DamageEventSource, 25, 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
            endif
            
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A09R') > 0 and luckylogic( udg_DamageEventSource, 4+(2*GetUnitAbilityLevel(udg_DamageEventSource, 'A09R')), 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
                call bufallst( udg_DamageEventSource, udg_DamageEventTarget, 'A09T', 'A0AE', 0, 0, 0, 'B08Z', "armr", 8 )
            endif
            if ( inv(udg_DamageEventSource, 'I04W') > 0 or ( udg_Set_Weapon_Logic[i + 24] and inv(udg_DamageEventSource, 'I030') > 0 ) ) and luckylogic( udg_DamageEventSource, 10, 1, 100 ) then
                set udg_DamageEventType = udg_DamageTypeCriticalStrike
                set udg_DamageEventAmount = udg_DamageEventAmount + (2*dmg)
            endif
            if ( inv(udg_DamageEventSource, 'I02O') > 0 or ( udg_Set_Weapon_Logic[i + 40] and inv(udg_DamageEventSource, 'I030') > 0 ) ) and luckylogic( udg_DamageEventSource, 15, 1, 100 ) then
                call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 0.75 )
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'B023') > 0 then
                call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 0.3 )
            endif
            if GetUnitAbilityLevel(udg_DamageEventSource, 'A0EW') > 0 and luckylogic( udg_DamageEventSource, GetUnitAbilityLevel(udg_DamageEventSource, 'A0EW'), 1, 100 ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + 50 + (50*GetUnitAbilityLevel(udg_DamageEventSource, 'A0EW'))
                call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 0.25+(0.25*GetUnitAbilityLevel(udg_DamageEventSource, 'A0EW')) )
            endif
            if inv( udg_DamageEventSource, 'I09H') > 0 and not( IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO) ) and not( IsUnitType(udg_DamageEventTarget, UNIT_TYPE_ANCIENT) ) then
                set udg_DamageEventAmount = udg_DamageEventAmount + (2*dmg)
            endif
            if inv(udg_DamageEventSource, 'I02M') > 0 and GetUnitStatePercent(udg_DamageEventSource, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) >= 95 then
                set udg_DamageEventAmount = udg_DamageEventAmount + (0.7*dmg)
            endif
            if inv(udg_DamageEventSource, 'I06B') > 0 and luckylogic( udg_DamageEventSource, 15, 1, 100 ) then
                call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 1 )
            endif
            if inv(udg_DamageEventSource, 'I06K') > 0 and luckylogic( udg_DamageEventSource, 25, 1, 100 ) then
                call UnitStun(udg_DamageEventSource, udg_DamageEventTarget, 1 )
            endif
            if GetUnitAbilityLevel(udg_DamageEventTarget, 'A09R') > 0 and luckylogic( udg_DamageEventTarget, 4+(2*GetUnitAbilityLevel(udg_DamageEventTarget, 'A09R')), 1, 100 ) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl", udg_DamageEventTarget, "origin" ) )
                set udg_DamageEventAmount = udg_DamageEventAmount - 0.8*dmg
                set udg_DamageEventType = udg_DamageTypeBlocked
            endif
            if udg_modgood[24] and IsUnitType( udg_DamageEventSource, UNIT_TYPE_HERO) then
                call healst(udg_DamageEventSource, null, udg_DamageEventAmount * 0.1 )
            endif
        endif
	    if GetUnitAbilityLevel( udg_DamageEventTarget, 'A09B' ) > 0 then
            set l = dmg*0.05*GetUnitAbilityLevel( udg_DamageEventTarget, 'A09B' )
            if l > 1 then
                set udg_DamageEventAmount = udg_DamageEventAmount - l
                set id = GetHandleId( udg_DamageEventSource )
                if LoadTimerHandle( udg_hash, id, StringHash( "mmcr" ) ) == null then
                    call SaveTimerHandle( udg_hash, id, StringHash( "mmcr" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mmcr" ) ) ) 
                call SaveReal( udg_hash, id, StringHash( "mmcr" ), l )
                call SaveUnitHandle( udg_hash, id, StringHash( "mmcr" ), udg_DamageEventSource )
                call SaveUnitHandle( udg_hash, id, StringHash( "mmcrc" ), udg_DamageEventTarget )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mmcr" ) ), 0.01, false, function MimicRCast )
            endif
	    endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B097' ) > 0 then
            set l = dmg*0.15
            if l > 1 then
                set udg_DamageEventAmount = udg_DamageEventAmount - l
                set id = GetHandleId( udg_DamageEventSource )
                if LoadTimerHandle( udg_hash, id, StringHash( "crnn" ) ) == null then
                    call SaveTimerHandle( udg_hash, id, StringHash( "crnn" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "crnn" ) ) ) 
                call SaveReal( udg_hash, id, StringHash( "crnn" ), l )
                call SaveUnitHandle( udg_hash, id, StringHash( "crnn" ), udg_DamageEventSource )
                call SaveUnitHandle( udg_hash, id, StringHash( "crnnc" ), udg_DamageEventTarget )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "crnn" ) ), 0.01, false, function CairneCast )
            endif
	    endif
        if IsUnitInGroup(udg_hero[k], udg_heroinfo) then
            if inv(udg_DamageEventTarget, 'I09Z') > 0 and luckylogic( udg_DamageEventTarget, 1 + GetUnitLevel(udg_DamageEventTarget), 1, 100 ) then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
            elseif ( GetUnitAbilityLevel( udg_DamageEventSource, 'B01N') > 0 ) and luckylogic( LoadUnitHandle( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mnkq1" ) ) ), StringHash( "mnkq1c" ) ), LoadInteger( udg_hash, GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mnkq1" ) ) ), StringHash( "mnkq1" ) ), 1, 100 ) then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
            elseif GetUnitTypeId(udg_DamageEventSource) == 'n02U' and GetRandomInt(1, 4) == 1 then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
            elseif inv(udg_DamageEventTarget, 'I05V') > 0 and luckylogic( udg_DamageEventTarget, 15, 1, 100 ) then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
            elseif inv(udg_DamageEventTarget, 'I06K') > 0 and luckylogic( udg_DamageEventTarget, 25, 1, 100 ) then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
    	    elseif GetUnitAbilityLevel(udg_DamageEventSource, 'B07U') > 0 and GetRandomInt( 1, 5 ) == 1 then
                set udg_DamageEventAmount = 0
                set udg_DamageEventType = udg_DamageTypeBlocked
            endif
        endif
        if inv( udg_DamageEventSource, 'I036' ) > 0 then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.2 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if inv( udg_DamageEventSource, 'I012' ) > 0 then
            if GetUnitState( udg_DamageEventSource, UNIT_STATE_MAX_LIFE ) == GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE ) then
                call shield( udg_DamageEventSource, udg_DamageEventSource, udg_DamageEventAmount * 0.1, 60 )
            else
                call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.1 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
            endif
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'B024' ) > 0  then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount*LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "mrlqv" ) ) )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'B049' ) > 0  then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.15 * GetUnitAbilityLevel( udg_DamageEventSource, 'A0ZN' ) )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'B08O' ) > 0  then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.2 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'B05Y' ) > 0  then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.15 )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'A0JJ' ) > 0  then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.1 * udg_SpellDamageSpec[i] )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'A0JK' ) > 0 then
            call healst( udg_DamageEventSource, null, udg_DamageEventAmount * 0.2 * udg_SpellDamageSpec[i] )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_DamageEventSource, "origin" ) )
        endif
        if inv( udg_DamageEventSource, 'I0A2' ) > 0 then
            call manast( udg_DamageEventSource, null, udg_DamageEventAmount * 0.1 )
        endif
        if GetUnitAbilityLevel( udg_DamageEventSource, 'B030' ) > 0 then
             call manast( udg_DamageEventSource, null, udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "snpw1m" ) ) )
        endif
        if inv( udg_DamageEventSource, 'I0C5' ) > 0 and combat( udg_DamageEventSource, false, 0 ) and not( udg_fightmod[3]) and IsUnitEnemy( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) then
        	call moneyst(udg_DamageEventSource, 3)  
    	endif
    //Маг. Урон
    else
        set udg_DamageEventAmount = udg_DamageEventAmount + (dmg*udg_BossDamageMagical[i])
        if GetUnitAbilityLevel(udg_DamageEventTarget, 'B08I') > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount + (LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "flne1m" ) )*dmg)
        endif
        if GetUnitTypeId( udg_DamageEventTarget ) == 'n009' then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.2*dmg)
        endif
        if GetUnitTypeId(udg_DamageEventTarget) == 'h011' or GetUnitTypeId(udg_DamageEventTarget) == 'h00O' then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.4*dmg)
        endif
        if inv(udg_hero[i], 'I0E5') > 0 and luckylogic( udg_hero[i], 20, 1, 100 ) then
            set udg_DamageEventType = udg_DamageTypeCriticalStrike
            set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0D9' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.5*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A05K' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.3*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A05O' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.3*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A14V' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.5*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0T8') >= 5 or (GetUnitAbilityLevel( udg_hero[k], 'A0T8') >= 5 and GetUnitTypeId(udg_DamageEventTarget) == 'u00X') then
            set udg_DamageEventAmount = udg_DamageEventAmount - (dmg* 0.2)	
        endif
        if GetUnitTypeId(udg_DamageEventTarget) == 'n041' then
            set udg_DamageEventAmount = udg_DamageEventAmount * 0.6
        endif
        if inv(udg_hero[i], 'I09K') > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount + (0.75*dmg)
        endif
        
        if GetUnitAbilityLevel( udg_hero[i], 'A0V4' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount + ((0.04+(0.04*GetUnitAbilityLevel( udg_hero[i], 'A0V4' )))*dmg)
        endif
        if inv( udg_hero[i], 'I04F' ) > 0 and not(udg_logic[i + 26]) then
            call SetUnitState( udg_hero[i], UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState( udg_hero[i], UNIT_STATE_LIFE ) - (udg_DamageEventAmount*0.15) ) )
        endif
        if inv( udg_DamageEventTarget, 'I08C' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount - (0.33*dmg)
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B04S') > 0 then
            set udg_DamageEventAmount = 1.5 * udg_DamageEventAmount
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B01V' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bknw" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B00L' ) > 0  then
            set udg_DamageEventAmount = udg_DamageEventAmount * 0.5   
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B05E' ) > 0  then
            set udg_DamageEventAmount = udg_DamageEventAmount * 0.5   
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B05W' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "advrd" ) )
            call manast( udg_DamageEventTarget, null, LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "advrm" ) ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B06O' ) > 0 then
            set udg_DamageEventAmount = udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shmrd" ) )
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B04H' ) > 0 then
            set udg_DamageEventAmount = 0
        endif
        if GetUnitAbilityLevel( udg_DamageEventTarget, 'B07F' ) > 0 then
            set udg_DamageEventAmount = 0
        endif
    endif

    if ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) and GetUnitAbilityLevel( udg_hero[i], 'B08J') > 0 then
        set udg_DamageHealLoop = true
        call healst( udg_hero[i], null, udg_DamageEventAmount * 0.15 )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_hero[i], "origin" ))
    endif
    
    if inv( udg_DamageEventSource, 'I00A' ) > 0 and not(IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO)) and not(IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT)) and not(udg_logic[i + 26]) then
        set udg_DamageEventAmount = udg_DamageEventAmount * 0.7
    endif
    if inv( udg_hero[i], 'I09I' ) > 0 and udg_DamageEventAmount >= 300 then
        call manast( udg_hero[i], null, GetUnitState( udg_hero[i], UNIT_STATE_MAX_MANA) * 0.1 )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", udg_hero[i], "origin" ) )
    endif
    if inv( udg_DamageEventTarget, 'I0BN' ) > 0 then
        call manast( udg_DamageEventTarget, null, 2 )
    endif
    if GetUnitName(udg_DamageEventTarget) == "Crisp" then
        set udg_DamageEventAmount = udg_DamageEventAmount * ( 1 - ( 0.1 * GetUnitAbilityLevel( LoadUnitHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bggrac" ) ), 'A0FD') ) )
    endif
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'B05U') > 0 then
        set udg_DamageEventAmount = udg_DamageEventAmount * LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "advwd" ) )
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A0GX') > 0 and LoadBoolean( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "drdw" ) ) then
        set l = LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "drdw" ) )*dmg
        set udg_DamageEventAmount = udg_DamageEventAmount - l
        call healst( udg_DamageEventTarget, null, l )
    endif
    if GetUnitAbilityLevel(udg_DamageEventSource, 'A0GX') > 0 and not(LoadBoolean( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "drdw" ) ) ) then
        set l = LoadReal( udg_hash, GetHandleId( udg_DamageEventSource ), StringHash( "drdw" ) )*dmg
        set udg_DamageEventAmount = udg_DamageEventAmount - l
        call SetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) - l ))
    endif
    if inv(udg_hero[i], 'I02B') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageHealLoop = true
        call healst( udg_hero[i], null, udg_DamageEventAmount * 0.6 )
        call DestroyEffect(AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", udg_hero[i], "origin" ))
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B012') > 0 then
        call Channel_Energy(udg_DamageEventTarget, udg_DamageEventAmount)
    endif
    /////////
	if udg_DamageEventAmount < (0.2*dmg) and udg_DamageEventType != udg_DamageTypeBlocked then
		set udg_DamageEventAmount = (0.2*dmg)
	endif
    /////////
    if inv( udg_DamageEventTarget, 'I0BM' ) > 0 and udg_DamageEventAmount >= GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) * 0.08 then
        set udg_DamageEventAmount = GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) * 0.08
    endif
    if inv( udg_hero[k], 'I0AP' ) > 0 and udg_DamageEventAmount >= 1 then
        set l = LoadReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "arth" ) )
        if l >= 8 then
            call healst( udg_hero[k], null, udg_DamageEventAmount )
            set udg_DamageEventAmount = 0
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", udg_hero[k], "origin" ) )
            call SaveReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "arth" ), 0 )
        else
            call SaveReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "arth" ), l + 1 )
        endif
    endif
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'A0NG') > 0 and udg_DamageEventAmount >= 1 then
	set l = LoadReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "bksb" ) ) + 1
        if l >= 11 - GetUnitAbilityLevel( udg_DamageEventTarget, 'A0NG') then
            set udg_DamageEventAmount = 0
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl", udg_hero[k], "origin" ) )
            call SaveReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "bksb" ), 0 )
        else
            call SaveReal( udg_hash, GetHandleId( udg_hero[k] ), StringHash( "bksb" ), l )
        endif
    endif
    if udg_modbad[18] and GetOwningPlayer(udg_DamageEventTarget) == Player(10) then
        set l = GetUnitState( udg_DamageEventTarget, UNIT_STATE_MAX_LIFE) * 0.4
        if udg_DamageEventAmount > l then
            set udg_DamageEventAmount = l
        endif
    endif
    if inv( udg_DamageEventSource, 'I0F4' ) > 0 and udg_DamageEventAmount >= 1 and IsUnitAlly(udg_DamageEventTarget, GetOwningPlayer(udg_DamageEventSource)) and udg_combatlogic[i] then
        call healst( udg_DamageEventSource, udg_DamageEventTarget, udg_DamageEventAmount )
        call healst( udg_DamageEventSource, null, udg_DamageEventAmount )
        set udg_DamageEventAmount = 0
    endif
    if GetUnitAbilityLevel(udg_DamageEventSource, 'A16N') > 0 and IsUnitAlly( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) then
        call healst( udg_DamageEventSource, udg_DamageEventTarget, udg_DamageEventAmount*(0.7+(0.1*GetUnitAbilityLevel(udg_DamageEventSource, 'A16N'))) )
        set udg_DamageEventAmount = 0
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B07S') > 0 then
        set udg_DamageEventAmount = 0
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'A0SV') > 0 then
        call UnitRemoveAbility( udg_DamageEventTarget, 'A0SV' )
        call UnitRemoveAbility( udg_DamageEventTarget, 'B07Z' )
        set udg_DamageEventAmount = 0
    endif
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B08E') > 0 and udg_DamageEventAmount > 0 then
        call UnitRemoveAbility( udg_DamageEventTarget, 'A01I' )
        call UnitRemoveAbility( udg_DamageEventTarget, 'B08E' )
        set udg_DamageEventAmount = 0
    endif
    
    if GetUnitAbilityLevel(udg_DamageEventTarget, 'B08M') > 0 then
        set udg_DamageEventAmount = 0
    endif
    if GetUnitTypeId(udg_DamageEventTarget) == 'n04O' then
        set u = LoadUnitHandle( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "bsdl" ) )
        if u != null and not(u == udg_DamageEventSource or (GetUnitTypeId(udg_DamageEventSource) == 'u000' and GetOwningPlayer(udg_DamageEventSource) == GetOwningPlayer(u) )) then
            set udg_DamageEventAmount = 0
        endif
    endif
    if udg_DamageEventAmount < 30 and inv(udg_hero[i], 'I0DQ') > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_DamageEventAmount = 30
    endif
    if udg_DamageEventAmount >= 100000 then
        set udg_DamageEventAmount = 100000
    endif
    /////////
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'A1A5') > 0 and udg_DamageEventAmount > 0 then
        call InfernalE( udg_DamageEventTarget, udg_DamageEventAmount )
    endif
    if udg_combatlogic[i] and not(udg_fightmod[3]) and inv(udg_hero[i], 'I0AN') > 0 and udg_DamageEventAmount > 0 and ( GetUnitTypeId(udg_DamageEventSource) == 'u000' or udg_DamageEventSource == udg_hero[i] ) then
        set udg_OrbManaburn[i] = udg_OrbManaburn[i] + (udg_DamageEventAmount*GetRandomReal(0.1,0.3))
        if udg_OrbManaburn[i] > 2000 then
            set udg_OrbManaburn[i] = 2000
        endif
        set udg_TimedItem = GetItemOfTypeFromUnitBJ(udg_hero[i], 'I0AN')
        call BlzSetItemIconPath( udg_TimedItem, words( udg_hero[i], BlzGetItemDescription(udg_TimedItem), "|cFF959697(", ")|r", I2S( R2I(udg_OrbManaburn[i]) ) + "/2000" ) )
    endif
    if GetUnitAbilityLevel(udg_DamageEventSource, 'B02O') > 0 and not( udg_IsDamageSpell ) then
        call CommandoWAt( udg_DamageEventSource, 0.2*udg_DamageEventAmount, GetUnitAbilityLevel(udg_DamageEventSource, 'A19F') )
        set udg_DamageEventAmount = 0
    endif
    /////////
    if udg_DamageEventAmount > 0 and IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO) and not( udg_fightmod[3] ) then
        if udg_DamageEventAmount > 0 then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if inv( udg_hero[cyclA], 'I09Q' ) > 0 and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and inv( udg_DamageEventTarget, 'I09Q' ) == 0 and IsUnitAlly(udg_DamageEventTarget, GetOwningPlayer(udg_hero[cyclA])) and udg_DamageEventTarget != udg_hero[cyclA] then
                    call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE ) - udg_DamageEventAmount ) ) 
                    set udg_DamageEventAmount = 0
                    set cyclA = 4
                endif
                set cyclA = cyclA + 1
            endloop
        endif
    endif
    if GetUnitAbilityLevel( udg_DamageEventTarget, 'B05P') > 0 then
        set sh = LoadReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shield" ) )
        if udg_DamageEventAmount >= sh then
            set udg_DamageEventAmount = udg_DamageEventAmount - sh
            set sh = 0
        else
            set sh = sh - udg_DamageEventAmount
            set udg_DamageEventAmount = 0
        endif
        call SaveReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shield" ), sh )
        if sh <= 0 then
            call UnitRemoveAbility( udg_DamageEventTarget, 'A11F' )
            call UnitRemoveAbility( udg_DamageEventTarget, 'B05P' )
            call SaveInteger( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shieldnum" ), 0 )
            call SaveReal( udg_hash, GetHandleId( udg_DamageEventTarget ), StringHash( "shieldMax" ), 0 )
        endif
    endif
    
    if (IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget)) or GetOwningPlayer(udg_DamageEventTarget) == GetOwningPlayer(udg_DamageEventSource) ) and not( udg_fightmod[3] ) and not( udg_logic[43] ) and udg_DamageEventAmount > 0 then
        if udg_DamageEventAmount >= GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE ) then
            set l = GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE )
        else
            set l = udg_DamageEventAmount
        endif
        if IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO) and udg_combatlogic[k] then
            set udg_DamagedAllTime[k] = udg_DamagedAllTime[k] + l
            set udg_DamagedFight[k] = udg_DamagedFight[k] + l
            call MultiSetValue( udg_multi, ( ( udg_Multiboard_Position[k] * 3 ) - 1 ), 13, I2S( R2I( udg_DamagedAllTime[k] ) ) )
            call MultiSetValue( udg_multi, ( ( udg_Multiboard_Position[k] * 3 ) - 1 ), 14, I2S( R2I( udg_DamagedFight[k] ) ) )
        endif
        if IsUnitInGroup(udg_hero[i], udg_heroinfo) and udg_combatlogic[i] then
            set udg_DamageAllTime[i] = udg_DamageAllTime[i] + l
            set udg_DamageFight[i] = udg_DamageFight[i] + l
            call MultiSetValue( udg_multi, ( ( udg_Multiboard_Position[i] * 3 ) - 1 ), 6, I2S( R2I( udg_DamageAllTime[i] ) ) )
            call MultiSetValue( udg_multi, ( ( udg_Multiboard_Position[i] * 3 ) - 1 ), 7, I2S( R2I( udg_DamageFight[i] ) ) )
            if udg_IsDamageSpell then
                set udg_Info_DamageMagic[i] = udg_Info_DamageMagic[i] + l
            else
                set udg_Info_DamagePhysical[i] = udg_Info_DamagePhysical[i] + l
            endif
        endif
    endif

    if GetUnitTypeId(udg_DamageEventSource) != 'u000' and not( udg_IsDamageSpell ) and inv(udg_DamageEventSource, 'I0CG' ) > 0 then
    	call SetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( udg_DamageEventSource, UNIT_STATE_LIFE) - (0.2*udg_DamageEventAmount) ))
    endif
    
	set u = null
endfunction

//===========================================================================
function InitTrig_Set_Damage takes nothing returns nothing
    set gg_trg_Set_Damage = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Set_Damage, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddAction( gg_trg_Set_Damage, function Trig_Set_Damage_Actions )
endfunction

