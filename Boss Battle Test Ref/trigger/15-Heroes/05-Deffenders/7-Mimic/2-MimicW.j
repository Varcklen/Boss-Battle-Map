function Trig_MimicW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A099'
endfunction

function Trig_MimicW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local integer cyclA = 1
    local integer cyclAEnd
    local integer i
    local integer rand
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A099'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = 40 + (40*lvl)
    
    call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", target, "origin" ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call UnitDamageTarget(bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    if not( udg_fightmod[3] ) and combat( caster, false, 0 ) and GetUnitState( target, UNIT_STATE_LIFE) <= 0.405 then
        set rand = GetRandomInt(1, 3)
        if rand == 1 then
            call statst( caster, 1, 0, 0, 220, false )
            call textst( "|c00FF2020 +1 strength", caster, 64, 90, 10, 1 )
        elseif rand == 2 then
            call statst( caster, 0, 1, 0, 224, false )
            call textst( "|c0020FF20 +1 agility", caster, 64, 90, 10, 1 )
        elseif rand == 3 then
            call statst( caster, 0, 0, 1, 228, false )
            call textst( "|c002020FF +1 intelligence", caster, 64, 90, 10, 1 )
        endif
    endif

    set i = GetPlayerId(GetOwningPlayer( caster )) + 1
    if udg_Set_Cristall_Number[i] > 0 then
	set cyclAEnd = udg_Set_Cristall_Number[i]
	loop
		exitwhen cyclA > cyclAEnd
		set u = randomtarget( caster, 300, "enemy", "", "", "", "" )
		if u == null then
			set cyclA = cyclAEnd
		else
    			call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", target, "origin" ) )
    			call UnitDamageTarget(bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    			if not( udg_fightmod[3] ) and combat( caster, false, 0 ) and GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
        			set rand = GetRandomInt(1, 3)
        			if rand == 1 then
          				call statst( caster, 1, 0, 0, 220, false )
            				call textst( "|c00FF2020 +1 strength", caster, 64, 90, 10, 1 )
        			elseif rand == 2 then
            				call statst( caster, 0, 1, 0, 224, false )
            				call textst( "|c0020FF20 +1 agility", caster, 64, 90, 10, 1 )
        			elseif rand == 3 then
            				call statst( caster, 0, 0, 1, 228, false )
            				call textst( "|c002020FF +1 intelligence", caster, 64, 90, 10, 1 )
        			endif
    			endif
		endif
		set cyclA = cyclA + 1
	endloop
    endif

    set target = null
    set caster = null
    set u = null
endfunction

//===========================================================================
function InitTrig_MimicW takes nothing returns nothing
    set gg_trg_MimicW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MimicW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MimicW, Condition( function Trig_MimicW_Conditions ) )
    call TriggerAddAction( gg_trg_MimicW, function Trig_MimicW_Actions )
endfunction

