globals
    constant real MEAT_WAGON_R_GOLD_DISCOUNT = 0.8
endglobals

function Trig_WagonR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0OY' and not(udg_fightmod[3]) and combat( GetSpellAbilityUnit(), false, 0 )
endfunction

function WagonRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "mwgr" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mwgrdmg" ) )
    local real x = LoadReal( udg_hash, id, StringHash( "mwgrx" ) )
    local real y = LoadReal( udg_hash, id, StringHash( "mwgry" ) )
    local integer gold = LoadInteger( udg_hash, id, StringHash( "mwgrg" ) )
    local real xc = GetUnitX( dummy )
    local real yc = GetUnitY( dummy )
    local integer counter = LoadInteger( udg_hash, id, StringHash( "mwgr" ) ) + 1
    local real angle = Atan2( y - yc, x - xc )
    local real NewX = xc + 20 * Cos( angle )
    local real NewY = yc + 20 * Sin( angle )
    local group g = CreateGroup()
    local unit u
    local real dist = LoadReal( udg_hash, id, StringHash( "mwgrd" ) )
    local real IfX = ( x - xc ) * ( x - xc )
    local real IfY = ( y - yc ) * ( y - yc )
    local real IfS = SquareRoot( IfX + IfY )
    local real perc = (IfS * 100)/dist
    local boolean l = LoadBoolean( udg_hash, id, StringHash( "mwgr" ))
    local integer cyclA

    if perc <= 50 and not(l) then
        call SetUnitFlyHeight( dummy, -400, 1000 )
        call SaveBoolean( udg_hash, id, StringHash( "mwgr" ), true )
    endif

    if IfS < 100 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
        if GetUnitState( dummy, UNIT_STATE_LIFE) > 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\MeatwagonMissile\\MeatwagonMissile.mdl", x, y ) )
            call GroupEnumUnitsInRange( g, x, y, 300, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, dummy, "enemy" ) then
                    call UnitDamageTarget(dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                endif
                call GroupRemoveUnit(g,u)
                set u = FirstOfGroup(g) 
            endloop
        endif
        set gold  = R2I(gold * MEAT_WAGON_R_GOLD_DISCOUNT)
        set cyclA = 1
        loop
            exitwhen cyclA > 1
            if gold >= 500 then
                set gold = gold - 500
                set bj_lastCreatedItem = CreateItem( 'I04Q', x+GetRandomReal(-300, 300), y+GetRandomReal(-300, 300) )
                if not( RectContainsItem( bj_lastCreatedItem, udg_Boss_Rect) ) then
                    call SetItemPositionLoc( bj_lastCreatedItem, GetRectCenter( udg_Boss_Rect ) )
                endif
                set cyclA = cyclA - 1
            elseif gold >= 100 then
                set gold = gold - 100
                set bj_lastCreatedItem = CreateItem( 'I04P', x+GetRandomReal(-300, 300), y+GetRandomReal(-300, 300) )
                if not( RectContainsItem( bj_lastCreatedItem, udg_Boss_Rect) ) then
                    call SetItemPositionLoc( bj_lastCreatedItem, GetRectCenter( udg_Boss_Rect ) )
                endif
                set cyclA = cyclA - 1
            elseif gold >= 50 then
                set gold = gold - 50
                set bj_lastCreatedItem = CreateItem( 'I04J', x+GetRandomReal(-300, 300), y+GetRandomReal(-300, 300) )
                if not( RectContainsItem( bj_lastCreatedItem, udg_Boss_Rect) ) then
                    call SetItemPositionLoc( bj_lastCreatedItem, GetRectCenter( udg_Boss_Rect ) )
                endif
                set cyclA = cyclA - 1
            elseif gold >= 10 then
                set gold = gold - 10
                set bj_lastCreatedItem = CreateItem( 'I02U', x+GetRandomReal(-300, 300), y+GetRandomReal(-300, 300) )
                if not( RectContainsItem( bj_lastCreatedItem, udg_Boss_Rect) ) then
                    call SetItemPositionLoc( bj_lastCreatedItem, GetRectCenter( udg_Boss_Rect ) )
                endif
                set cyclA = cyclA - 1
            endif
            set cyclA = cyclA + 1
        endloop
        call RemoveUnit(dummy)
        call FlushChildHashtable( udg_hash, id ) 
        call DestroyTimer( GetExpiredTimer() )
    else
        call SaveInteger( udg_hash, id, StringHash( "mwgr" ), counter )
        call SetUnitPosition( dummy, NewX, NewY )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
endfunction

function Trig_WagonR_Actions takes nothing returns nothing
    local integer id 
    local integer lvl
    local unit caster
    local unit target
    local real dmg
    local real x
    local real y
    local real dist
    local real dx
    local real dy
    local integer g
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0OY'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call dummyspawn( caster, 0, 'A0PA', 0, 0 )
    call UnitAddAbility(bj_lastCreatedUnit, 'Amrf')
    
    set g = R2I(0.4 * GetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD))
    set dmg = g*(0.75+(0.25*lvl))
	set x = GetUnitX(target)
    set y = GetUnitY(target)
    set dx = x - GetUnitX(bj_lastCreatedUnit)
    set dy = y - GetUnitY(bj_lastCreatedUnit)
    set dist = SquareRoot(dx * dx + dy * dy)

    call SetUnitFlyHeight( bj_lastCreatedUnit, 400, 1000 )
    
    set id = GetHandleId( bj_lastCreatedUnit )
    if LoadTimerHandle( udg_hash, id, StringHash( "mwgr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mwgr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mwgr" ) ) )
    call SaveUnitHandle( udg_hash, id, StringHash( "mwgr" ), bj_lastCreatedUnit)
    call SaveReal( udg_hash, id, StringHash( "mwgrx" ), x )
    call SaveReal( udg_hash, id, StringHash( "mwgry" ), y )
    call SaveReal( udg_hash, id, StringHash( "mwgrd" ), dist)
    call SaveReal( udg_hash, id, StringHash( "mwgrdmg" ), dmg)
    call SaveInteger( udg_hash, id, StringHash( "mwgrg" ), g)
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "mwgr" ) ), 0.02, true, function WagonRCast )
    
    call SetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD, IMaxBJ( 0, GetPlayerState( GetOwningPlayer( caster ), PLAYER_STATE_RESOURCE_GOLD) - g ) )

    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_WagonR takes nothing returns nothing
    set gg_trg_WagonR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WagonR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WagonR, Condition( function Trig_WagonR_Conditions ) )
    call TriggerAddAction( gg_trg_WagonR, function Trig_WagonR_Actions )
endfunction