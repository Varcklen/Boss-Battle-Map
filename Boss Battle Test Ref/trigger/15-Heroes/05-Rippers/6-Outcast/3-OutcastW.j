function Trig_OutcastW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A07Y'
endfunction

function Trig_OutcastW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local real dmge
    local group g = CreateGroup()
    local unit u
    local group h = CreateGroup()
    local unit n

    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A07Y'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set dmg = 40 + ( 40 * lvl )
    set dmge = 10 + ( 20 * lvl )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\Singularity I Red.mdx", GetUnitX(caster), GetUnitY(caster) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            	call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
		if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
    			call DestroyEffect( AddSpecialEffect( "war3mapImported\\Singularity I Red.mdx", GetUnitX(u), GetUnitY(u) ) )
    			call GroupEnumUnitsInRange( h, GetUnitX( u ), GetUnitY( u ), 300, null )
   			loop
        			set n = FirstOfGroup(h)
        			exitwhen n == null
        			if unitst( n, caster, "enemy" ) then
            				call UnitDamageTarget( bj_lastCreatedUnit, n, dmge, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
       				endif
        			call GroupRemoveUnit(h,n)
        			set n = FirstOfGroup(h)
    			endloop
		endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop

    if GetUnitAbilityLevel(caster, 'A082') > 0 then
	if udg_outcast[2] then
		set udg_outcast[2] = false
		if not(udg_fightmod[3]) and combat( caster, false, 0 ) then
            call statst( caster, 0, 2, 0, 236, true )
            call textst( "|c0020FF20 +2 agility", caster, 64, 90, 10, 1 )
		endif
		if GetLocalPlayer() == GetOwningPlayer(caster) then
            call BlzFrameSetVisible( outballframe[2], false )
		endif
	endif
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "outew" ) ), 55 - (5*GetUnitAbilityLevel(caster, 'A082')), true, function OutcastEWEnd )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( h )
    call DestroyGroup( h )
    set h = null
    set n = null
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_OutcastW takes nothing returns nothing
    set gg_trg_OutcastW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OutcastW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OutcastW, Condition( function Trig_OutcastW_Conditions ) )
    call TriggerAddAction( gg_trg_OutcastW, function Trig_OutcastW_Actions )
endfunction

