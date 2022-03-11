function Trig_VampW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0AB' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function VampWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local group g = CreateGroup()
    local unit u
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "vamw" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "vamw" ) )
    local real health = LoadReal( udg_hash, id, StringHash( "vamwh" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "vamwx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "vamwy" ) )
    
    if udg_combatlogic[GetPlayerId(GetOwningPlayer(caster)) + 1] and udg_fightmod[0] then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 250, null )
        call DestroyEffect( AddSpecialEffect( "Blood Explosion.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if udg_fightmod[0] then
            call SetUnitPosition( caster, x + GetRandomReal( -128, 128 ), y + GetRandomReal( -128, 128 ) )
            call GroupClear( g )
            call dummyspawn( caster, 1, 0, 0, 0 )
            call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 250, null )
            call DestroyEffect( AddSpecialEffect( "Blood Explosion.mdx", GetUnitX( caster ), GetUnitY( caster ) ) )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "enemy" ) then
                    call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g)
            endloop
        endif
        
        call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0, GetUnitState( caster, UNIT_STATE_LIFE) - health ) )
    endif
    
    call FlushChildHashtable( udg_hash, id )
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

function Trig_VampW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer id
    local real dmg 
    local real health
    local real x 
    local real y 
    local integer lvl

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 600, "enemy", "org", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0AB'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set x = GetUnitX( target )
    set y = GetUnitY( target )
    
    if udg_fightmod[3] and not( RectContainsUnit(udg_Boss_Rect, target) ) then
        set caster = null
        set target = null
        return
    endif
    
    set id = GetHandleId( caster )
    set dmg = 90 + ( 30 * lvl )
    set health = 55 + ( 5 * lvl )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "vamw" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "vamw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "vamw" ), caster )
    call SaveReal( udg_hash, id, StringHash( "vamw" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "vamwh" ), health )
    call SaveReal( udg_hash, id, StringHash( "vamwx" ), x )
    call SaveReal( udg_hash, id, StringHash( "vamwy" ), y )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "vamw" ) ), 0.01, false, function VampWCast )
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_VampW takes nothing returns nothing
    set gg_trg_VampW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_VampW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_VampW, Condition( function Trig_VampW_Conditions ) )
    call TriggerAddAction( gg_trg_VampW, function Trig_VampW_Actions )
endfunction

