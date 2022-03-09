function Trig_AltarE_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A129'
endfunction

function AltarEMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "alte" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "altet" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "alte" ) ) + 1
    local integer k = LoadInteger( udg_hash, id, StringHash( "altek" ) ) - 1
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "altel" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "alte" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "alteh" ) )

    if k > 0 and GetUnitAbilityLevel(target, 'A12X') > 0 and DistanceBetweenUnits(caster, target) < 900 and caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SaveInteger( udg_hash, id, StringHash( "altek" ), k )
        call MoveLightningUnits( l, caster, target )
        if c >= 50 then
            call SaveInteger( udg_hash, id, StringHash( "alte" ), 0 )
            call dummyspawn( caster, 1, 0, 0, 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call healst( caster, null, heal)
        else
            call SaveInteger( udg_hash, id, StringHash( "alte" ), c )
        endif
    else
        call UnitRemoveAbility( target, 'A12X' )
        call UnitRemoveAbility( target, 'B08B' )
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function AltarEAltMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "alte" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "altet" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "alte" ) ) + 1
    local integer k = LoadInteger( udg_hash, id, StringHash( "altek" ) ) - 1
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "altel" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "alte" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "alteh" ) )

    if k > 0 and GetUnitAbilityLevel(target, 'A12X') > 0 and DistanceBetweenUnits(caster, target) < 900 and caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call SaveInteger( udg_hash, id, StringHash( "altek" ), k )
        call MoveLightningUnits( l, caster, target )
        if c >= 50 then
            call SaveInteger( udg_hash, id, StringHash( "alte" ), 0 )
            call dummyspawn( caster, 1, 0, 0, 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call manast( caster, null, heal)
        else
            call SaveInteger( udg_hash, id, StringHash( "alte" ), c )
        endif
    else
        call UnitRemoveAbility( target, 'A12X' )
        call UnitRemoveAbility( target, 'B08B' )
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_AltarE_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real dmg
    local real heal
    local lightning l
    local real t
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = 20
        call textst( udg_string[0] + GetObjectName('A129'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    
    set t = timebonus(caster, t)
    set dmg = 7 + lvl
    set heal = 2 + lvl

    call DestroyEffect( AddSpecialEffect( "Blood Explosion.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
    if GetUnitAbilityLevel( caster, 'A12W') > 0 then
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and GetUnitAbilityLevel(u, 'A12X') == 0 then
                set l = AddLightningEx("DRAM", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) , GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u))

                call UnitAddAbility( u, 'A12X' )

                set id = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "alte" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "alte" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "alte" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "alte" ), caster )
                call SaveUnitHandle( udg_hash, id, StringHash( "altet" ), u )
                call SaveLightningHandle( udg_hash, id, StringHash( "altel" ), l )
                call SaveReal( udg_hash, id, StringHash( "alte" ), dmg )
                call SaveReal( udg_hash, id, StringHash( "alteh" ), heal )
                call SaveInteger( udg_hash, id, StringHash( "altek" ), R2I(t/0.02) )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "alte" ) ), 0.02, true, function AltarEAltMove ) 
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) - (95+(5*lvl)) ))
    else
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and GetUnitAbilityLevel(u, 'A12X') == 0 then
                set l = AddLightningEx("DRAL", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) , GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u))

                call UnitAddAbility( u, 'A12X' )

                set id = GetHandleId( u )
                if LoadTimerHandle( udg_hash, id, StringHash( "alte" ) ) == null  then
                    call SaveTimerHandle( udg_hash, id, StringHash( "alte" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "alte" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "alte" ), caster )
                call SaveUnitHandle( udg_hash, id, StringHash( "altet" ), u )
                call SaveLightningHandle( udg_hash, id, StringHash( "altel" ), l )
                call SaveReal( udg_hash, id, StringHash( "alte" ), dmg )
                call SaveReal( udg_hash, id, StringHash( "alteh" ), heal )
                call SaveInteger( udg_hash, id, StringHash( "altek" ), R2I(t/0.02) )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "alte" ) ), 0.02, true, function AltarEMove ) 
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set l = null
endfunction

//===========================================================================
function InitTrig_AltarE takes nothing returns nothing
    set gg_trg_AltarE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarE, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AltarE, Condition( function Trig_AltarE_Conditions ) )
    call TriggerAddAction( gg_trg_AltarE, function Trig_AltarE_Actions )
endfunction