function Trig_SoulstealerR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0FN'
endfunction

function SoulstealerRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "sslrt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "sslr" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sslr" ) ) 
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "sslrd" ) )
    local group g = CreateGroup()
    local unit u
    local real r = 0

    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
    	call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 1000, null )
    	loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and GetUnitAbilityLevel(u, 'A0DZ') > 0 then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmDamage.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                set r = r + dmg
            endif
            call GroupRemoveUnit(g,u)
    	endloop
        if r > 0 then
            call shield( caster, null, r, 60 )
        endif
    endif
    if counter > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'A0FP' ) > 0 and not( IsUnitLoaded( caster ) ) then
        call SaveReal( udg_hash, id, StringHash( "sslrt" ), counter - 1 )
    else
        call RemoveUnit( dummy )
        call UnitRemoveAbility( caster, 'A0FP' )
        call UnitRemoveAbility( caster, 'B07O' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set dummy = null
    set caster = null
endfunction

function Trig_SoulstealerR_Actions takes nothing returns nothing
    local integer id 
    local real dmg 
    local integer lvl
    local unit caster
    local integer sp
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0FN'), caster, 64, 90, 10, 1.5 )
        set t = 22
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 22
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( caster )
    set dmg = (6 + (4*lvl)) * GetUnitSpellPower(caster)
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    
    call UnitAddAbility( caster, 'A0FP' )
    if LoadTimerHandle( udg_hash, id, StringHash( "sslr" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "sslr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sslr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "sslr" ), caster )
	call SaveUnitHandle( udg_hash, id, StringHash( "sslrd" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "sslr" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "sslrt" ), t )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "sslr" ) ), 1, true, function SoulstealerRCast )
    
    if BuffLogic() then
        call effst( caster, caster, null, lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_SoulstealerR takes nothing returns nothing
    set gg_trg_SoulstealerR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulstealerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SoulstealerR, Condition( function Trig_SoulstealerR_Conditions ) )
    call TriggerAddAction( gg_trg_SoulstealerR, function Trig_SoulstealerR_Actions )
endfunction

