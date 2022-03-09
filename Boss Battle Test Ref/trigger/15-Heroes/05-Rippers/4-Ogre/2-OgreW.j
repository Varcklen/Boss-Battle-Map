function Trig_OgreW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EU'
endfunction

function OgreWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ogrw" ) )

    call UnitRemoveAbility( u, 'A0E1' )
    call UnitRemoveAbility( u, 'B068' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_OgreW_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer id
    local integer lvl
    local unit caster
    local real t
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0EU'), caster, 64, 90, 10, 1.5 )
        set t = 30
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 30
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    
    set dmg = 0.05 + (0.05*lvl)
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( caster ), GetUnitY( caster )) )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 250+(50*lvl), null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call UnitAddAbility( u, 'A0E1' )
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "ogrw" ) ) == null then 
                call SaveTimerHandle( udg_hash, id, StringHash( "ogrw" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ogrw" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "ogrw" ), u )
            call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( "ogrwc" ), u )
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "ogrw" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "ogrw" ) ), t, false, function OgreWCast )
            if BuffLogic() then
                call debuffst( caster, u, null, lvl, t )
            endif
        endif
        
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_OgreW takes nothing returns nothing
    set gg_trg_OgreW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OgreW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OgreW, Condition( function Trig_OgreW_Conditions ) )
    call TriggerAddAction( gg_trg_OgreW, function Trig_OgreW_Actions )
endfunction
