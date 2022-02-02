function Trig_Bursting_bullet_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0C1'
endfunction

function Trig_Bursting_bullet_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0C1'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

	set cyclAEnd = 15*eyest( caster )
    
    call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl", GetUnitX(target), GetUnitY(target)) )
    call dummyspawn( caster, 1, 0, 0, 0 )
	loop
		exitwhen cyclA > cyclAEnd
        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
            call UnitDamageTarget( bj_lastCreatedUnit, target, 20, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
		endif
        set cyclA = cyclA + 1
	endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Bursting_bullet takes nothing returns nothing
    set gg_trg_Bursting_bullet = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bursting_bullet, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Bursting_bullet, Condition( function Trig_Bursting_bullet_Conditions ) )
    call TriggerAddAction( gg_trg_Bursting_bullet, function Trig_Bursting_bullet_Actions )
endfunction

