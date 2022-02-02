function Trig_FallenOneW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05F' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function FallenOneWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real counter = LoadReal( udg_hash, id, StringHash( "flnw" ) ) - 1
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "flnwc" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "flnw" ) )
    local group g = CreateGroup()
    local unit u
    
    if counter > 0 then
        call SaveReal( udg_hash, id, StringHash( "flnw" ), counter )
        if LoadReal( udg_hash, GetHandleId( target ), StringHash( "shield" ) ) <= 0 then
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\BlackChakraExplosion.mdx", GetUnitX(target), GetUnitY(target) ) )
            call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, target, "enemy" ) then 
                    call UnitStun(caster, u, 2 )
                endif
                call GroupRemoveUnit(g,u)
            endloop
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", caster, "origin" ) )
            call DestroyTimer( GetExpiredTimer() )
            call FlushChildHashtable( udg_hash, id ) 
        endif
    else
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id ) 
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
    set target = null
endfunction

function Trig_FallenOneW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real sh
    local integer id
    local real t
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A05F'), caster, 64, 90, 10, 1.5 )
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
    
    if lvl > 4 then
        set lvl = 4
    endif
    set sh = 120 + ( 60 * lvl )
    set t = timebonus(caster, t)
    
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 600, null )
    call AddSpecialEffect( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", GetUnitX( target ), GetUnitY( target ) )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, target, "enemy" ) then 
            call taunt( target, u, t )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call shield( caster, target, sh, t )
    call effst( caster, target, null, lvl, t )
    
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "flnw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "flnw" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle(udg_hash, id, StringHash( "flnw" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "flnw" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "flnwc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "flnw" ), t*2 )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "flnw" ) ), 0.5, true, function FallenOneWCast )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_FallenOneW takes nothing returns nothing
    set gg_trg_FallenOneW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FallenOneW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_FallenOneW, Condition( function Trig_FallenOneW_Conditions ) )
    call TriggerAddAction( gg_trg_FallenOneW, function Trig_FallenOneW_Actions )
endfunction

