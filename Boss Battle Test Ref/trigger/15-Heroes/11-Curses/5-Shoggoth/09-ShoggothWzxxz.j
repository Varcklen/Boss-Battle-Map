function Trig_ShoggothWzxxz_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0LG'
endfunction

function ShoggothWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real counter = LoadReal( udg_hash, id, StringHash( "shgtwt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "shgtw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "shgtw" ) ) 
    local unit dummy = LoadUnitHandle( udg_hash, id, StringHash( "shgtwd" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "shgtwlvl" ) )
    local real t
    local group g = CreateGroup()
    local unit u

    if counter > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitAbilityLevel( caster, 'A0X3' ) > 0 and not( IsUnitLoaded( caster ) ) then
        call SaveReal( udg_hash, id, StringHash( "shgtwt" ), counter - 1 )
        set t = timebonus(caster, 10)
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX(caster), GetUnitY(caster) ) )
        call GroupEnumUnitsInRange( g, GetUnitX(caster), GetUnitY(caster), 350, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call bufst( caster, u, 'A12Y', 'B06U', "shgtw1", t )
                call SetUnitAbilityLevel( u, 'A12E', lvl )
                if BuffLogic() then
                    call effst( caster, u, null, lvl, t )
                endif
                call UnitDamageTarget( dummy, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    else
        call RemoveUnit( dummy )
        call UnitRemoveAbility( caster, 'A0X3' )
        call UnitRemoveAbility( caster, 'B086' )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set dummy = null
    set caster = null
endfunction

function Trig_ShoggothWzxxz_Actions takes nothing returns nothing
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
        call textst( udg_string[0] + GetObjectName('A0LG'), caster, 64, 90, 10, 1.5 )
        set t = 15
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 15
    endif
    set t = timebonus(caster, t)
    
    set dmg = (8+(8 * lvl)) * udg_SpellDamage[GetPlayerId(GetOwningPlayer( caster ) ) + 1]
    call dummyspawn( caster, 0, 'A0N5', 0 , 0 )
    call UnitAddAbility( caster, 'A0X3' )
    
    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "shgtw" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "shgtw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "shgtw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "shgtw" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "shgtwd" ), bj_lastCreatedUnit )
    call SaveReal( udg_hash, id, StringHash( "shgtw" ), dmg )
    call SaveReal( udg_hash, id, StringHash( "shgtwt" ), t )
    call SaveInteger( udg_hash, id, StringHash( "shgtwlvl" ), lvl )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "shgtw" ) ), 1, true, function ShoggothWCast )
    
    if BuffLogic() then
        call effst( caster, caster, null, lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothWzxxz takes nothing returns nothing
    set gg_trg_ShoggothWzxxz = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothWzxxz, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothWzxxz, Condition( function Trig_ShoggothWzxxz_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothWzxxz, function Trig_ShoggothWzxxz_Actions )
endfunction

