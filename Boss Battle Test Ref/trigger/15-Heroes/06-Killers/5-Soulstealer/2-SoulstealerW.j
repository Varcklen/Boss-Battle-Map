function Trig_SoulstealerW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0E0'
endfunction

function Trig_SoulstealerW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0E0'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set i = LoadInteger( udg_hash, GetHandleId(caster), StringHash( "sslw" ) )
    
    set dmg = 150 + ( 50 * lvl )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 1000, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) and GetUnitAbilityLevel(u, 'A0DZ') > 0 then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            if udg_combatlogic[GetPlayerId( GetOwningPlayer( caster ) ) + 1] and not( udg_fightmod[3] ) then
                set i = i + 1
                if i >= 5 then
                    set i = 0
                    call RessurectionPoints( 1, false )
                    call textst( "|cFFFFFC01 Resurrection +1", caster, 64, 90, 10, 1 )
                endif
            endif
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call SaveInteger( udg_hash, GetHandleId(caster), StringHash( "sslw" ), i )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_SoulstealerW takes nothing returns nothing
    set gg_trg_SoulstealerW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulstealerW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SoulstealerW, Condition( function Trig_SoulstealerW_Conditions ) )
    call TriggerAddAction( gg_trg_SoulstealerW, function Trig_SoulstealerW_Actions )
endfunction

