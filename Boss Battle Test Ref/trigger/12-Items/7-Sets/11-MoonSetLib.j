library MoonSetLib requires UnitstLib

    globals
        real Event_UntilMoonSetCast_Real
        unit Event_UntilMoonSetCast_Hero
        real Event_UntilMoonSetCast_Damage
        real Event_UntilMoonSetCast_Static_Damage
    endglobals

    function MoonACast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local integer counter = LoadInteger( udg_hash, id, StringHash( "moon" ) ) + 1
        local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "moon" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mooncs" ) )
        local real NewX = GetUnitX( dummy ) + 44 * Cos( 0.017 * GetUnitFacing( dummy ) )
        local real NewY = GetUnitY( dummy ) + 44 * Sin( 0.017 * GetUnitFacing( dummy ) )
        local real dmg = LoadReal( udg_hash, id, StringHash( "moon" ) )
        local group nodmg = LoadGroupHandle( udg_hash, id, StringHash( "moong" ) )
        local group g = CreateGroup()
        local unit u

        if counter >= 20 or GetUnitState( dummy, UNIT_STATE_LIFE) <= 0.405 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl", GetUnitX( dummy ), GetUnitY( dummy ) ) )
            call RemoveUnit( dummy )
            call GroupClear( nodmg )
            call DestroyGroup( nodmg )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SetUnitPosition( dummy, NewX, NewY )
            call SaveInteger( udg_hash, id, StringHash( "moon" ), counter )
            call GroupEnumUnitsInRange( g, GetUnitX( dummy ), GetUnitY( dummy ), 100, null )
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                if unitst( u, caster, "enemy" ) and not( IsUnitInGroup( u, nodmg ) ) then
                    call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                    call GroupAddUnit( nodmg, u )
                endif
                call GroupRemoveUnit(g,u)
            endloop
        endif
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set dummy = null
        set caster = null
    endfunction

    function MoonTrigger takes unit caster returns nothing
        local integer cyclA = 1
        local integer id
        local unit n = udg_hero[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
        local integer i = GetPlayerId(GetOwningPlayer( n ) ) + 1
        local real nr
        local real r
        local group g = CreateGroup()
        local unit u

        set r = (50 + (GetUnitState(caster, UNIT_STATE_MANA)/15)) 
        set nr = r
        
        set Event_UntilMoonSetCast_Hero = caster
        set Event_UntilMoonSetCast_Damage = r
        set Event_UntilMoonSetCast_Static_Damage = nr
        
        set Event_UntilMoonSetCast_Real = 0.00
        set Event_UntilMoonSetCast_Real = 1.00
        set Event_UntilMoonSetCast_Real = 0.00
        
        set r = Event_UntilMoonSetCast_Damage
        
        set r = r + (nr * (udg_SpellDamage[i]-1) )
        
        if inv( n, 'I0CH' ) > 0 then
            set r = r + (nr*0.5)
        endif
        
        
        
        set cyclA = 1
        loop
            exitwhen cyclA > 8
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 45 * cyclA )
            call UnitAddAbility( bj_lastCreatedUnit, 'A01Z')
            call UnitAddAbility( bj_lastCreatedUnit, 'A0N5')
            
            call SaveTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "moon" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "moon" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "moon" ), bj_lastCreatedUnit )
            call SaveUnitHandle( udg_hash, id, StringHash( "mooncs" ), caster )
            call SaveReal( udg_hash, id, StringHash( "moon" ), r )
            call SaveGroupHandle( udg_hash, id, StringHash( "moong" ), CreateGroup() )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "moon" ) ), 0.04, true, function MoonACast )
            set cyclA = cyclA + 1
        endloop

        if GetUnitTypeId(caster) != 'o01F' then
            set bj_livingPlayerUnitsTypeId = 'o01F'
            call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( caster ), filterLivingPlayerUnitsOfTypeId)
            loop
                set u = FirstOfGroup(g)
                exitwhen u == null
                call MoonTrigger(u)
                call GroupRemoveUnit(g,u)
            endloop
        endif

        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set n = null
        set caster = null
    endfunction

endlibrary