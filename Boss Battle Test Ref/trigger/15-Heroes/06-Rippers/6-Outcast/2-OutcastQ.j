function Trig_OutcastQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07J' 
endfunction

function Trig_OutcastQ_Actions takes nothing returns nothing
    local lightning l
    local integer id 
    local integer lvl
    local integer cyclA = 1
    local real dmg 
    local group g
    local group h
    local group j
    local unit target
    local unit caster
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 300, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07J'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 100 + ( 50 * lvl )  
    set g = CreateGroup()
    set h = CreateGroup()
    set j = CreateGroup()
    
    call dummyspawn( caster, 3, 0, 0 , 0 )
    
    loop
        exitwhen cyclA > 1
	if not( IsUnitInGroup(target, j ) ) then
		call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
		call DestroyEffect( AddSpecialEffect( "BarbarianSkinW.mdx", GetUnitX( target ), GetUnitY( target ) ) )
	        call GroupAddUnit(j, target)
	endif
        call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 300, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and not( IsUnitInGroup(u, j ) ) then
                call GroupAddUnit(h, u)
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        if not( IsUnitGroupEmptyBJ(h) ) then
	    if GetUnitState( target, UNIT_STATE_LIFE)/GetUnitState( target, UNIT_STATE_MAX_LIFE) <= 0.35 then
            	set cyclA = cyclA - 2
	    endif
            set target = GroupPickRandomUnit(h)
            call GroupRemoveUnit(h, target)
        endif
        set cyclA = cyclA + 1
    endloop

    if GetUnitAbilityLevel(caster, 'A082') > 0 then
	if udg_outcast[1] then
		set udg_outcast[1] = false
		if not(udg_fightmod[3]) and combat( caster, false, 0 ) then
            call statst( caster, 2, 0, 0, 232, true )
            call textst( "|c00FF2020 +2 strength", caster, 64, 90, 10, 1 )
		endif
		if GetLocalPlayer() == GetOwningPlayer(caster) then
            call BlzFrameSetVisible( outballframe[1], false )
		endif
	endif
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "outeq" ) ), 55 - (5*GetUnitAbilityLevel(caster, 'A082')), true, function OutcastEQEnd )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( h )
    call DestroyGroup( h )
    call GroupClear( j )
    call DestroyGroup( j )
    set j = null
    set g = null
    set h = null
    set l = null
    set u = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OutcastQ takes nothing returns nothing
    set gg_trg_OutcastQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OutcastQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OutcastQ, Condition( function Trig_OutcastQ_Conditions ) )
    call TriggerAddAction( gg_trg_OutcastQ, function Trig_OutcastQ_Actions )
endfunction

