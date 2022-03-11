function Trig_AngelW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07F'
endfunction

function AngelWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "angwt" ) )
    local integer sp = LoadInteger( udg_hash, id, StringHash( "angwsp" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "angw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "angw1" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "angw" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "angw1" ) )
    local group g = CreateGroup()
    local unit u
    
    if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call healst( caster, target, heal )
    endif
    
    if counter > 0 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, sp ) > 0 then
        call SaveReal( udg_hash, id, StringHash( "angwt" ), counter - 1 )
        if counter == 1 then
            call DestroyEffect( AddSpecialEffectTarget( "Falling Light.mdx", target, "origin" ) )
        endif
    else
        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( target, sp ) > 0 then
            call dummyspawn( caster, 1, 0, 'A0N5', 0 )
            call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 450, null )
            loop
                set u = FirstOfGroup( g )
                exitwhen u == null
                if unitst( u, caster, "enemy" )  then
                    call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                endif
                call GroupRemoveUnit( g, u )
                set u = FirstOfGroup( g )
            endloop
        endif
        call UnitRemoveAbility( target, sp )
        call UnitRemoveAbility( target, 'B01Z' )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set target = null
    set caster = null
    set u = null
endfunction

function Trig_AngelW_Actions takes nothing returns nothing
    local integer id
    local integer cyclA = 1
    local real dmg
    local real heal
    local unit caster
    local unit target
    local integer lvl
    local integer sp
    local real t
    local unit n
    local integer i

    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "notfull", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07F'), caster, 64, 90, 10, 1.5 )
        set t = 12
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 12
    endif
    set t = timebonus(caster, t)
    set dmg = 10 + ( 20 * lvl )
    set heal = 8 + ( 8 * lvl )
    
    if udg_Database_Hero[6] == 'N03H' then
        set sp = 'A0VE'
    else
        set sp = 'A0BO'
    endif
    
    if lvl == 5  then
        if udg_BuffLogic then
            set i = 1
        else
            set i = 4
        endif
        loop
            exitwhen cyclA > i
            if udg_BuffLogic then
                set n = target
            else
                set n = udg_hero[cyclA]
            endif
            if unitst( n, caster, "ally" ) then
                set id = GetHandleId( n )
                call UnitAddAbility( n, sp )
                call DestroyEffect(AddSpecialEffectTarget("Life Magic.mdx", n, "chest"))
                
                if LoadTimerHandle( udg_hash, id, StringHash( "angw" ) ) == null then
                    call SaveTimerHandle( udg_hash, id, StringHash( "angw" ), CreateTimer() )
                endif
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "angw" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "angw" ), n )
                call SaveUnitHandle( udg_hash, id, StringHash( "angw1" ), caster )
                call SaveReal( udg_hash, id, StringHash( "angw" ), heal )
                call SaveReal( udg_hash, id, StringHash( "angw1" ), dmg )
                call SaveReal( udg_hash, id, StringHash( "angwt" ), t )
                call SaveInteger( udg_hash, id, StringHash( "angwsp" ), sp )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( n ), StringHash( "angw" ) ), 1, true, function AngelWCast )
                
                if BuffLogic() then
                    call effst( caster, n, "Trig_AngelW_Actions", lvl, t )
                endif
            endif
            set cyclA = cyclA + 1
        endloop
    else
        set id = GetHandleId( target )
        call UnitAddAbility( target, sp )
        call DestroyEffect(AddSpecialEffectTarget("Life Magic.mdx", target, "chest"))
        
        if LoadTimerHandle( udg_hash, id, StringHash( "angw" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "angw" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "angw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "angw" ), target )
        call SaveUnitHandle( udg_hash, id, StringHash( "angw1" ), caster )
        call SaveReal( udg_hash, id, StringHash( "angw" ), heal )
        call SaveReal( udg_hash, id, StringHash( "angw1" ), dmg )
        call SaveReal( udg_hash, id, StringHash( "angwt" ), t )
        call SaveInteger( udg_hash, id, StringHash( "angwsp" ), sp )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "angw" ) ), 1, true, function AngelWCast )
        if BuffLogic() then
            call effst( caster, target, "Trig_AngelW_Actions", lvl, t )
        endif
    endif
    
    set caster = null
    set target = null
    set n = null
endfunction

//===========================================================================
function InitTrig_AngelW takes nothing returns nothing
    set gg_trg_AngelW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AngelW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AngelW, Condition( function Trig_AngelW_Conditions ) )
    call TriggerAddAction( gg_trg_AngelW, function Trig_AngelW_Actions )
endfunction

