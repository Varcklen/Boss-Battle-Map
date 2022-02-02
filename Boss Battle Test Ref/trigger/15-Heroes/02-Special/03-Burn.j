function Trig_Burn_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19Q'
endfunction

function Trig_Burn_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local real dmg
    local integer s
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A19Q'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set s = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "burn" ) )
    set dmg = 100 + s
    
    call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    if GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 and combat(caster, false, 0) and not(udg_fightmod[3]) then
        call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "burn" ), s + 15 )
        if GetLocalPlayer() == GetOwningPlayer(caster) then
            call BlzSetAbilityExtendedTooltip( 'A19Q', words( caster, BlzGetAbilityExtendedTooltip('A19Q', 0), "|cffbe81f7", "|r", I2S(s+115) ), 0 )
        endif
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Burn takes nothing returns nothing
    set gg_trg_Burn = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Burn, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Burn, Condition( function Trig_Burn_Conditions ) )
    call TriggerAddAction( gg_trg_Burn, function Trig_Burn_Actions )
endfunction

