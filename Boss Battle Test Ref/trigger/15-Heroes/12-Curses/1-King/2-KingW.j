function Trig_KingW_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0Q0' and udg_combatlogic[GetPlayerId( GetOwningPlayer( GetSpellAbilityUnit() ) ) + 1]
endfunction

function KingWMotion takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local real dmg = LoadReal( udg_hash, id, StringHash( "kngq" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "kngqc" ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "kngq" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "kngqx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "kngqy" ) )
    local real xc = GetUnitX( dummy )
    local real yc = GetUnitY( dummy )
    local real angle = Atan2( y - yc, x - xc )
    local real NewX = xc + 20 * Cos( angle )
    local real NewY = yc + 20 * Sin( angle )
    local real IfX = ( x - xc ) * ( x - xc )
    local real IfY = ( y - yc ) * ( y - yc )
    local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "kngqg" ) )
    local group g = CreateGroup()
    local unit u

    if SquareRoot( IfX + IfY ) > 10 and GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 and RectContainsUnit(udg_Boss_Rect, dummy) then
        call SetUnitPosition( dummy, NewX, NewY )
        call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 150, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call GroupAddUnit( nodmg, u )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    else
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
        set g = nodmg
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if RectContainsUnit(udg_Boss_Rect, dummy) and GetUnitDefaultMoveSpeed(u) != 0 and GetUnitState( u, UNIT_STATE_LIFE ) > 0.405 and not(IsUnitHidden(u)) then
                call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( u ), GetUnitY( u ) ) )
                call SetUnitPosition( u, GetUnitX(dummy), GetUnitY(dummy) )
                call DestroyEffect( AddSpecialEffect( "Void Teleport Caster.mdx", GetUnitX( u ), GetUnitY( u ) ) )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        call GroupClear( nodmg )
        call DestroyGroup( nodmg )
        call RemoveUnit( dummy )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set nodmg = null
    set dummy = null
    set caster = null
endfunction   

function Trig_KingW_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local unit caster
    local integer lvl
    local real x
    local real y

    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0Q0'), caster, 64, 90, 10, 1.5 )
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
    set dmg = ( 100 + ( 50 * lvl ) ) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    
    call dummyspawn( caster, 0, 'A0PS', 0, 0 )
    call SetUnitFacing( bj_lastCreatedUnit, GetUnitFacing( caster ) )

    set id = GetHandleId( bj_lastCreatedUnit )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "kngq" ), CreateTimer() )
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "kngq" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "kngq" ), bj_lastCreatedUnit )
    call SaveUnitHandle( udg_hash, id, StringHash( "kngqc" ), caster )
    call SaveReal( udg_hash, id, StringHash( "kngqx" ), x )
    call SaveReal( udg_hash, id, StringHash( "kngqy" ), y )
    call SaveReal( udg_hash, id, StringHash( "kngq" ), dmg )
    call SaveGroupHandle( udg_hash, id, StringHash( "kngqg" ), CreateGroup() )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "kngq" ) ), 0.04, true, function KingWMotion )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_KingW takes nothing returns nothing
    set gg_trg_KingW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KingW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KingW, Condition( function Trig_KingW_Conditions ) )
    call TriggerAddAction( gg_trg_KingW, function Trig_KingW_Actions )
endfunction