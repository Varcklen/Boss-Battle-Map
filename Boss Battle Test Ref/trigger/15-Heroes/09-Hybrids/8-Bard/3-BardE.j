function Trig_BardE_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A1AT') > 0 and luckylogic( GetSpellAbilityUnit(), 3 + GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A1AT'), 1, 100 )
endfunction

function BardECast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "brde" ) )

    call spdst( u, -LoadReal( udg_hash, GetHandleId( u ), StringHash( "brde" ) ) )
    call UnitRemoveAbility( u, 'A1AU' )
    call UnitRemoveAbility( u, 'B09K' )
    call RemoveSavedReal( udg_hash, GetHandleId( u ), StringHash( "brde" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function BardEUse takes unit caster, unit target, integer lvl returns nothing
    local integer id 
    local integer array a
    local boolean array l
    local integer rand
    local integer cyclA
    local integer i
    local real spd
    local real rsum
    local real t = timebonus(caster, 5)
    
    if target != null then
        set spd = 10 + (10*lvl )

        set i = GetPlayerId(GetOwningPlayer(target)) + 1
        call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\TimeUpheaval.mdx", target, "origin" ) )
        
        set a[1] = Database_Hero_Abilities[1][udg_HeroNum[i]]
        set a[2] = Database_Hero_Abilities[2][udg_HeroNum[i]]
        set a[3] = Database_Hero_Abilities[3][udg_HeroNum[i]]
        set a[4] = Database_Hero_Abilities[4][udg_HeroNum[i]]

        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if BlzGetUnitAbilityCooldownRemaining( target,a[cyclA]) > 1 then
                set l[cyclA] = true
            else
                set l[cyclA] = false
            endif
            set cyclA = cyclA + 1
        endloop

        if l[1] or l[2] or l[3] or l[4] then
            set cyclA = 1
            loop
                exitwhen cyclA > 1
                set rand = GetRandomInt( 1, 4 )
                if l[rand] then
                    call BlzStartUnitAbilityCooldown( target, a[rand], 0.01 )
                else
                    set cyclA = cyclA - 1
                endif
                set cyclA = cyclA + 1
            endloop
        endif
         
        set rsum = LoadReal( udg_hash, GetHandleId( target ), StringHash( "brde" ) ) + spd
        call spdst( target, spd )
        call UnitAddAbility( target, 'A1AU')
        call SetUnitAbilityLevel( target, 'A1AU', lvl )
        
        set id = GetHandleId( target )
        if LoadTimerHandle( udg_hash, id, StringHash( "brde" ) ) == null   then
            call SaveTimerHandle( udg_hash, id, StringHash( "brde" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "brde" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "brde" ), target )
        call SaveReal( udg_hash, GetHandleId( target ), StringHash( "brde" ), rsum )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "brde" ) ), t, false, function BardECast ) 
        
        call effst( caster, target, null, 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_BardE_Actions takes nothing returns nothing
    call BardEUse( GetSpellAbilityUnit(), GroupPickRandomUnit(udg_otryad), GetUnitAbilityLevel(GetSpellAbilityUnit(), 'A1AT') )
endfunction

//===========================================================================
function InitTrig_BardE takes nothing returns nothing
    set gg_trg_BardE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BardE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BardE, Condition( function Trig_BardE_Conditions ) )
    call TriggerAddAction( gg_trg_BardE, function Trig_BardE_Actions )
endfunction

