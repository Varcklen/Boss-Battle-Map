globals
    real Event_SomeoneDied_Real
    unit Event_SomeoneDied_WhoDied
    unit Event_SomeoneDied_Unit
endglobals

function Trig_KillUnit_Conditions takes nothing returns boolean
    return GetUnitName(GetDyingUnit()) != "dummy"
endfunction

function CamPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "camp" ) ), 'A0UU' )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "camp" ) ), 'B055' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function PhoenixEgg takes unit caster, unit dead returns nothing
    if GetUnitState( caster, UNIT_STATE_LIFE) <= 0.405 then
        call SaveBoolean( udg_hash, GetHandleId( caster ), StringHash( "pheg" ), true )
        call ReviveHero( caster, GetUnitX(dead), GetUnitY(dead), true )
        call SetUnitState( caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MAX_MANA) )
        if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            set udg_Heroes_Deaths = udg_Heroes_Deaths - 1
            call GroupRemoveUnit( udg_DeadHero, caster)
            call GroupAddUnit( udg_otryad, caster)
        endif
    endif
endfunction

function Trig_KillUnit_Actions takes nothing returns nothing
    //local group g = CreateGroup()
    local unit u
    local integer n
    local unit i = LoadUnitHandle( udg_hash, 1, StringHash( "sklp" ) )
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer id
    local integer k = GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1
    local integer j = GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1
    local integer p
    local real pr

    if GetUnitTypeId(GetDyingUnit()) == 'h012' then
        call PhoenixEgg( LoadUnitHandle( udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "fnx" ) ), GetDyingUnit() )
        call RemoveSavedHandle(udg_hash, GetHandleId( GetDyingUnit() ), StringHash( "fnx" ) )
    endif
    if GetUnitTypeId(GetDyingUnit()) == 'u00X' then
        set u = LoadUnitHandle( udg_hash, GetHandleId(GetDyingUnit()), StringHash( "sldg" ) )
        if u != null then
            call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u)+BlzGetUnitMaxHP(GetDyingUnit())) )
            call BlzSetUnitBaseDamage( u, R2I(BlzGetUnitBaseDamage(u, 0)+BlzGetUnitBaseDamage(GetDyingUnit(), 0)+1), 0 )
        endif
    endif
	   
    /*set Event_SomeoneDied_WhoDied = GetDyingUnit()
    call GroupEnumUnitsInRange( g, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), 450, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if u != GetDyingUnit() then
            set Event_SomeoneDied_Unit = u
            set Event_SomeoneDied_Real = 0.00
            set Event_SomeoneDied_Real = 1.00
            set Event_SomeoneDied_Real = 0.00
            if inv( u, 'I07W') > 0 and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call manast( u, null, 12 )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouchTarget.mdl", u, "origin") )
            elseif GetUnitTypeId(u) == 'h01M' then
                if GetDyingUnit() != udg_hero[GetPlayerId( GetOwningPlayer(GetDyingUnit()) ) + 1] then
                    set n = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfabu" ) ) + 1
                    call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "sfabu" ), n )
                endif
                if LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfabu" ) ) >= 7 then
                    set udg_Heroes_Deaths = udg_Heroes_Deaths - 1
                call GroupRemoveUnit( udg_DeadHero, udg_hero[LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfab" ) )])
                    call ReviveHero( udg_hero[LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfab" ) )], GetUnitX(u), GetUnitY(u), true )
                    call GroupAddUnit( udg_otryad, udg_hero[LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfab" ) )])
                    call SetUnitState( udg_hero[LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfab" ) )], UNIT_STATE_MANA, GetUnitState(udg_hero[LoadInteger( udg_hash, GetHandleId( u ), StringHash( "sfab" ) )], UNIT_STATE_MAX_MANA) )
                    call RemoveSavedHandle(udg_hash, GetHandleId( u ), StringHash( "sfabu" ) )
                    call RemoveSavedInteger(udg_hash, GetHandleId( u ), StringHash( "sfabu" ) )
                    call RemoveUnit( u )
                else
                    call textst( "|c00ffffff " + I2S( n ) + "/7", u, 64, GetRandomReal( 45, 135 ), 8, 1.5 )
                endif
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop*/

    //When hero kill someone...
    if GetUnitState( udg_hero[j], UNIT_STATE_LIFE) > 0.405 and not( udg_fightmod[3] ) and combat( udg_hero[j], false, 0 ) and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer(udg_hero[j])) and ( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == udg_hero[j] ) then
        if inv(udg_hero[j], 'I04R') > 0 then
            call spdst( udg_hero[j], 0.3 )
            call textst( "|c00808080 +0.3%", udg_hero[j], 64, GetRandomReal( 0, 360 ), 8, 1.5 )
            set udg_Data[j + 64] = udg_Data[j + 64] + 1 
        endif
        if inv(udg_hero[j], 'I074') > 0 then
            call healst( udg_hero[j], null, 20 )
            call moneyst( udg_hero[j], 20 )
            set udg_Data[j + 180] = udg_Data[j + 180] + 20
        endif
        if inv(udg_hero[j], 'I0BR') > 0 and udg_Item_Souls[j] < 9800 then
            set udg_Item_Souls[j] = udg_Item_Souls[j] + 200
            call ChangeToolItem( udg_hero[j], 'I0BR', "|cffbe81f2", "|r", I2S(200+udg_Item_Souls[j]) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", GetUnitX( udg_hero[j] ), GetUnitY( udg_hero[j] ) ) )
        endif
    endif
    if GetUnitAbilityLevel(GetDyingUnit(), 'A10I') > 0 then
        set u = LoadUnitHandle( udg_hash, GetHandleId(GetDyingUnit()), StringHash( "dvred" ))
        if combat( u, false, 0 ) and not( udg_fightmod[3] ) then
            call spdst( u, LoadReal( udg_hash, GetHandleId(GetDyingUnit()), StringHash( "dvred" )) )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        endif
        call SaveReal( udg_hash, GetHandleId(GetDyingUnit()), StringHash( "dvred" ), 0 )
        call SaveUnitHandle( udg_hash, GetHandleId(GetDyingUnit()), StringHash( "dvred" ), null )
    endif
    if inv(udg_hero[j], 'I07A') > 0 and ( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == udg_hero[j] ) and GetUnitState( udg_hero[j], UNIT_STATE_LIFE) > 0.405 then
        call RemoveItem( GetItemOfTypeFromUnitBJ( udg_hero[j], 'I07A') )
        set bj_lastCreatedItem = CreateItem( 'I07Q', GetUnitX(udg_hero[j]), GetUnitY(udg_hero[j]))
        call UnitAddItemSwapped( bj_lastCreatedItem, udg_hero[j] )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", udg_hero[j], "origin" ) )
    elseif inv(udg_hero[j], 'I07Q') > 0 and ( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == udg_hero[j] ) and GetUnitState( udg_hero[j], UNIT_STATE_LIFE) > 0.405 then
        call RemoveItem( GetItemOfTypeFromUnitBJ( udg_hero[j], 'I07Q') )
        set bj_lastCreatedItem = CreateItem( 'I07A', GetUnitX(udg_hero[j]), GetUnitY(udg_hero[j]))
        call UnitAddItemSwapped( bj_lastCreatedItem, udg_hero[j] )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", udg_hero[j], "origin" ) )
    endif

    if inv(udg_hero[k], 'I06W') > 0 and GetUnitState( udg_hero[k], UNIT_STATE_LIFE) > 0.405 then
        set u = randomtarget( GetDyingUnit(), 600, "enemy", "", "", "", "" )
        if u != null then
            call dummyspawn( GetDyingUnit(), 1, 0, 0, 0 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, 50, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        endif
    endif

    if GetUnitTypeId(GetDyingUnit()) != 'h01F' and udg_combatlogic[j] and ( ( inv( GetKillingUnit(), 'I0CR') > 0 ) or ( ( inv( GetKillingUnit(), 'I030') > 0 ) and udg_Set_Weapon_Logic[j + 80] ) ) and ( GetUnitTypeId(GetKillingUnit()) == 'u000' or GetKillingUnit() == udg_hero[j] ) and not(IsUnitType( GetDyingUnit(), UNIT_TYPE_HERO)) and not(IsUnitType( GetDyingUnit(), UNIT_TYPE_ANCIENT)) then
        call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetKillingUnit() ), GetUnitTypeId(GetDyingUnit()), GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), GetUnitFacing( GetDyingUnit() ) )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 10 )
    endif

    if GetUnitTypeId(GetDyingUnit()) == 'n044' then
        set udg_logic[96] = true
        call StartSound(gg_snd_QuestLog)
        set udg_DeathPig = udg_DeathPig + 1
        if udg_DeathPig > 3 and GetRandomInt(1,3) == 1 then
            set udg_DeathPig = 0 
            set cyclA = 1
            set cyclAEnd = udg_Heroes_Amount
            loop
                exitwhen cyclA > cyclAEnd
                set bj_lastCreatedUnit = CreateUnitAtLoc( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n045', Location(GetRandomReal(GetRectMinX(gg_rct_Spawn), GetRectMaxX(gg_rct_Spawn)), GetRandomReal(GetRectMinY(gg_rct_Spawn), GetRectMaxY(gg_rct_Spawn))), GetRandomReal( 0, 360 ) )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
                call IssueTargetOrder( bj_lastCreatedUnit, "attackonce", GroupPickRandomUnit(udg_otryad) ) 
                set cyclA = cyclA + 1
            endloop
        endif
    endif
    
    if GetUnitAbilityLevel( GetDyingUnit(), 'A196') > 0 and not(udg_fightmod[3]) then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitTypeId(udg_hero[cyclA]) == 'O016' and udg_combatlogic[cyclA] and luckylogic( udg_hero[cyclA], 40, 1, 100 ) then
                call entropy( udg_hero[cyclA], 1 )
            endif
            set cyclA = cyclA + 1
        endloop
    endif

    if i != null then
        if GetUnitAbilityLevel( i, 'A0CK' ) > 0 and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer( i ) ) and GetUnitState( i, UNIT_STATE_LIFE) > 0.405 and GetUnitName(GetDyingUnit()) != "dummy" and GetUnitTypeId(GetDyingUnit()) != 'u001' and GetUnitTypeId(GetDyingUnit()) != 'h009' and GetUnitTypeId(GetDyingUnit()) != 'h01F' then
            call skeletsp( i, GetDyingUnit() )
        endif
    endif
    
	if inv(udg_hero[k], 'I026') > 0 and luckylogic( udg_hero[k], 20, 1, 100 ) and GetUnitState( udg_hero[k], UNIT_STATE_LIFE) > 0.405 and combat( udg_hero[k], false, 0 ) and not( udg_fightmod[3] ) then
        call CreateItem( 'I03J' + GetRandomInt(1, 6), GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) )
    endif

    if GetUnitTypeId(GetDyingUnit()) == ID_SHEEP or GetUnitTypeId(GetDyingUnit()) == 'n00E' then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if (GetUnitAbilityLevel( udg_hero[cyclA], 'A0MG' ) > 0 or GetUnitAbilityLevel( udg_hero[cyclA], 'A0MH' ) > 0) and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl", udg_hero[cyclA], "origin" ) )
                call BlzEndUnitAbilityCooldown( udg_hero[cyclA], udg_Ability_Uniq[cyclA] )
            endif
            if inv( udg_hero[cyclA], 'I0EY' ) > 0 and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and udg_combatlogic[cyclA] and not(udg_fightmod[3]) then
                call moneyst( udg_hero[cyclA], 3)
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if inv( udg_hero[cyclA],'I04L') > 0 and GetUnitTypeId(GetDyingUnit()) != ID_SHEEP and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
            set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(udg_hero[cyclA]), ID_SHEEP, GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()), GetRandomInt( 0, 360 ))
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 30 )
        endif
        if inv( udg_hero[cyclA],'I0FZ') > 0 and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitEnemy(GetDyingUnit(), GetOwningPlayer( udg_hero[cyclA] ) ) then
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ) ) )
            set bj_lastCreatedUnit = CreateUnit(GetOwningPlayer(udg_hero[cyclA]), 'e009', GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()), GetRandomInt( 0, 360 ))
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 15 )
        endif
        set cyclA = cyclA + 1
    endloop

    if GetUnitAbilityLevel( GetDyingUnit(), 'A0CF' ) > 0 then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(GetDyingUnit(), GetOwningPlayer(udg_hero[cyclA])) then
                call healst( udg_hero[cyclA], null, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE)*0.2 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    if IsUnitType( GetDyingUnit(), UNIT_TYPE_HERO) then
        if IsUnitInGroup(GetDyingUnit(), udg_heroinfo) and udg_combatlogic[k] then
            set udg_Death[k] = true
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if GetPlayerSlotState( Player( cyclA - 1 ) ) == PLAYER_SLOT_STATE_PLAYING and inv( udg_hero[cyclA], 'I09K') > 0 and combat( udg_hero[cyclA], false, 0 ) and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(GetDyingUnit(), GetOwningPlayer(udg_hero[cyclA])) and GetOwningPlayer(GetDyingUnit()) != Player(4) then
            	call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIso\\AIsoTarget.mdl", udg_hero[cyclA], "origin") )
            	call KillUnit( udg_hero[cyclA] )
            endif
            if inv( udg_hero[cyclA], 'I07K') > 0 and not( udg_fightmod[3] ) and combat( udg_hero[cyclA], false, 0 ) and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(GetDyingUnit(), GetOwningPlayer(udg_hero[cyclA])) then
                call statst( udg_hero[cyclA], 1, 1, 1, 0, true )
                set udg_Data[cyclA + 4] = udg_Data[cyclA + 4] + 1
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            endif
            if udg_hero[cyclA] != GetDyingUnit() and GetUnitAbilityLevel( udg_hero[cyclA], 'A0EY') > 0 and not( udg_fightmod[3] ) and GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(GetDyingUnit(), GetOwningPlayer(udg_hero[cyclA])) then
                set p = GetUnitAbilityLevel( udg_hero[cyclA], 'A0EY')
                call healst( udg_hero[cyclA], null, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * (0.05+(0.15*p)) )
                call manast( udg_hero[cyclA], null, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_MANA) * (0.05+(0.15*p)) )
                call shield( udg_hero[cyclA], null, 100+(100*p), 60 )
                call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
            endif
            set cyclA = cyclA + 1
        endloop
        if GetUnitAbilityLevel( GetDyingUnit(), 'A0UQ') > 0 then
            set cyclA = 1
            loop
                exitwhen cyclA > 4
                if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                    set id = GetHandleId( udg_hero[cyclA] )
        
                    call UnitAddAbility( udg_hero[cyclA], 'A0UU' )
                    call SetUnitAbilityLevel( udg_hero[cyclA], 'A0US', GetUnitAbilityLevel( GetDyingUnit(), 'A0UQ' ) )
                    call SetUnitAbilityLevel( udg_hero[cyclA], 'A0UT', GetUnitAbilityLevel( GetDyingUnit(), 'A0UQ' ) )
                    
                    if udg_Database_Hero[29] == 'O00Z' then
                        call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\RequiemofGhostsCaster.mdx", udg_hero[cyclA], "origin" ) )
                    else
                        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", udg_hero[cyclA], "origin" ) )
                    endif
                    
                    if LoadTimerHandle( udg_hash, id, StringHash( "camp" ) ) == null then
                        call SaveTimerHandle( udg_hash, id, StringHash( "camp" ), CreateTimer() )
                    endif
                    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "camp" ) ) ) 
                    call SaveUnitHandle( udg_hash, id, StringHash( "camp" ), udg_hero[cyclA] )
                    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( udg_hero[cyclA] ), StringHash( "camp" ) ), timebonus(GetDyingUnit(), 60), false, function CamPCast )
                endif
                set cyclA = cyclA + 1
            endloop
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if inv( udg_hero[cyclA], 'I045') > 0 and (GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 or udg_hero[cyclA] == GetDyingUnit() ) then
                set cyclB = 1
                loop
                    exitwhen cyclB > 4
                    if GetUnitState( udg_hero[cyclB], UNIT_STATE_LIFE) > 0.405 and unitst( udg_hero[cyclB], udg_hero[cyclA], "ally" ) and not( udg_fightmod[3] ) then
                        call healst( udg_hero[cyclA], udg_hero[cyclB], GetUnitState(udg_hero[cyclB], UNIT_STATE_MAX_LIFE) * 0.2 )
                        call manast( udg_hero[cyclA], udg_hero[cyclB], GetUnitState(udg_hero[cyclB], UNIT_STATE_MAX_MANA) * 0.2 )
                        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", udg_hero[cyclB], "origin") )
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            if GetUnitAbilityLevel(udg_hero[cyclA], 'A0TP') > 0 and (GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 or udg_hero[cyclA] == GetDyingUnit() ) then
                set pr = 0.04 * GetUnitAbilityLevel(udg_hero[cyclA], 'A0TP')
                set cyclB = 1
                loop
                    exitwhen cyclB > 4
                    if GetUnitState( udg_hero[cyclB], UNIT_STATE_LIFE) > 0.405 and unitst( udg_hero[cyclB], udg_hero[cyclA], "ally" ) and not( udg_fightmod[3] ) then
                        call healst( udg_hero[cyclA], udg_hero[cyclB], GetUnitState(udg_hero[cyclB], UNIT_STATE_MAX_LIFE) * pr )
                        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", udg_hero[cyclB], "origin") )
                    endif
                    set cyclB = cyclB + 1
                endloop
            endif
            set cyclA = cyclA + 1
        endloop
    else
        call FlushChildHashtable( udg_hash, GetHandleId(GetDyingUnit()) )
    endif
    
    /*call GroupClear( g )
    call DestroyGroup( g )
    set g = null*/
    set u = null
    set i = null
endfunction

//===========================================================================
function InitTrig_KillUnit takes nothing returns nothing
    set gg_trg_KillUnit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KillUnit, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_KillUnit, Condition( function Trig_KillUnit_Conditions ) )
    call TriggerAddAction( gg_trg_KillUnit, function Trig_KillUnit_Actions )
endfunction

