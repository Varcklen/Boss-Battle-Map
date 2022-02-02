function Trig_FirePot_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04E'
endfunction

function Trig_FirePot_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( "|cf0FF2020 Fire", udg_Caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set dmg = 250 * udg_SpellDamagePotion[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
    
    if inv( caster, 'I05S' ) > 0 then
        call dummyspawn( caster, 1, 0, 0, 0 ) 
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 400, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( u ), GetUnitY( u ) ) )
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg+(GetUnitState( u, UNIT_STATE_MAX_LIFE)*0.03), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    else
        call dummyspawn( caster, 1, 0, 0, 0 ) 
        call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX( target ), GetUnitY( target ) ) )
    endif
    call potionst( caster )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set target = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_FirePot takes nothing returns nothing
    set gg_trg_FirePot = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_FirePot, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_FirePot, Condition( function Trig_FirePot_Conditions ) )
    call TriggerAddAction( gg_trg_FirePot, function Trig_FirePot_Actions )
endfunction

