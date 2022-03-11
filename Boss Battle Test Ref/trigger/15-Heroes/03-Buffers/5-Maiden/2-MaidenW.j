function Trig_MaidenW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A16K'
endfunction

function MaidenWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit n = LoadUnitHandle( udg_hash, id, StringHash( "mdnw" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mdnwc" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mdnw" ) )
    local group g = CreateGroup()
    local unit u
    
    call UnitRemoveAbility( n, 'A16M' )
    call UnitRemoveAbility( n, 'B07B' )

    call dummyspawn( caster, 1, 'A0N5', 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( n ), GetUnitY( n ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, n, "enemy") then
    	    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetUnitX(u), GetUnitY(u) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set caster = null
    set u = null
    set g = null
    set n = null
endfunction

function Trig_MaidenW_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    local real t
    local real heal
    local real dmg
    local integer k
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A16K'), caster, 64, 90, 10, 1.5 )
        set t = 5
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        set t = 5
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    set heal = 50+(25*lvl)
    set dmg = (heal/2) * GetUnitSpellPower(caster)
    
    set k = 0
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally") and k <= 10 then
    	    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX(u), GetUnitY(u) ) )
            call healst( caster, u, heal )
            call UnitAddAbility( u, 'A16M' )

            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "mdnw" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "mdnw" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdnw" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "mdnw" ), u )
            call SaveUnitHandle( udg_hash, id, StringHash( "mdnwc" ), caster )
            call SaveReal( udg_hash, id, StringHash( "mdnw" ), dmg )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "mdnw" ) ), t, false, function MaidenWCast )
            
            call effst( caster, u, null, lvl, t )
            set k = k + 1
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_MaidenW takes nothing returns nothing
    set gg_trg_MaidenW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MaidenW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MaidenW, Condition( function Trig_MaidenW_Conditions ) )
    call TriggerAddAction( gg_trg_MaidenW, function Trig_MaidenW_Actions )
endfunction

