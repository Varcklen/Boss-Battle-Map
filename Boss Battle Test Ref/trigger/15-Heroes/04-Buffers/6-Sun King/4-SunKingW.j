function Trig_SunKingW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A02U'
endfunction

function SunKingWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "snkw" ) )
    
    call UnitRemoveAbility( u, 'A02Y' )
    call UnitRemoveAbility( u, 'B08S' )
    call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "snkws" ), 0 )
    call FlushChildHashtable( udg_hash, id )
    
     set u = null
endfunction

function Trig_SunKingW_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real t
    local integer stack
    local real bns
    local group g = CreateGroup()
    local unit u
    local real dmg 
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A02U'), caster, 64, 90, 10, 1.5 )
        set t = 20
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( target )
    
    set stack = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "snkws" ) )
    if stack >= 3 then
        set dmg = 50 + (50*lvl)
        call DestroyEffect( AddSpecialEffect( "AngelSkinQ.mdx", GetUnitX(target), GetUnitY(target) ) )
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            elseif unitst( u, caster, "ally" ) then
                call healst( caster, u, dmg )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    else
        set stack = stack + 1
        call textst( "|cFFFE8A0E" + I2S(stack), target, 64, GetRandomReal( 80, 100 ), 12, 1 )
    endif
    
    set bns = 0.03*lvl*stack
    call UnitAddAbility( target, 'A02Y' )
        
    if LoadTimerHandle( udg_hash, id, StringHash( "snkw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "snkw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "snkw" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "snkw" ), target )
    call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "snkws" ), stack )
    call SaveReal( udg_hash, GetHandleId( target ), StringHash( "snkwb" ), bns )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "snkw" ) ), t, false, function SunKingWCast )
    if BuffLogic() then
        call debuffst( caster, target, null, lvl, t )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction
//===========================================================================
function InitTrig_SunKingW takes nothing returns nothing
    set gg_trg_SunKingW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SunKingW, Condition( function Trig_SunKingW_Conditions ) )
    call TriggerAddAction( gg_trg_SunKingW, function Trig_SunKingW_Actions )
endfunction

