function Trig_GunMasterR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19K'
endfunction

function GunMasterRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "codr" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "codrdmg" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "codrx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "codry" ) )
    local group g = CreateGroup()
    local unit u
    local real xc
    local real yc
    
     if GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        call RemoveUnit( dummy )
        call DestroyTimer( GetExpiredTimer() )
        call FlushChildHashtable( udg_hash, id )
    else
        set xc = x+GetRandomReal( -250, 250 )
        set yc = y+GetRandomReal( -250, 250 )
        //call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\GyroCopter\\GyroCopterImpact.mdl", xc, yc ) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", xc, yc ) )
        call GroupEnumUnitsInRange( g, xc, yc, 175, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, dummy, "enemy" ) then
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set dummy = null
endfunction

function Trig_GunMasterR_Actions takes nothing returns nothing
    local real dmg
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A19H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', x, y, 270 )
    call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 10 )
    call UnitAddAbility( bj_lastCreatedUnit,'A19L' )
    call SetUnitScale( bj_lastCreatedUnit, 2.5, 2.5, 2.5 )
    
    set dmg = 52+(12*lvl)
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "codr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "codr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "codr" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "codr" ), bj_lastCreatedUnit)
    call SaveReal( udg_hash, id, StringHash( "codrx" ), x )
    call SaveReal( udg_hash, id, StringHash( "codry" ), y )
    call SaveReal( udg_hash, id, StringHash( "codrdmg" ), dmg)
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "codr" ) ), 0.5, true, function GunMasterRCast )

    set caster = null
endfunction

//===========================================================================
function InitTrig_GunMasterR takes nothing returns nothing
    set gg_trg_GunMasterR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GunMasterR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GunMasterR, Condition( function Trig_GunMasterR_Conditions ) )
    call TriggerAddAction( gg_trg_GunMasterR, function Trig_GunMasterR_Actions )
endfunction

