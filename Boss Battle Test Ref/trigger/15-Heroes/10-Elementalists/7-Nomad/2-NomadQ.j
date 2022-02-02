function Trig_NomadQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A04Q' 
endfunction

function NomadRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "nmdr" ) )

    if GetUnitAbilityLevel(u, 'A04U') == 0 then
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    elseif GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
        call BallEnergy( u, 1 )
    endif

    set u = null
endfunction

function Trig_NomadQ_Actions takes nothing returns nothing
    local lightning l
    local integer id 
    local integer lvl
    local integer cyclA = 1
    local real dmg 
    local real dmgb
    local real dist
    local group g = CreateGroup()
    local group h = CreateGroup()
    local group n = CreateGroup()
    local unit target
    local unit caster
    local unit lastunit
    local unit u
    local unit nu
    local integer i = 0
    local integer lim
    local boolean f
    local real mana = 0
    local integer lvW
    local integer lvR
    local real lvE
    local real lvEb
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A04Q'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set lvE = 1.15 + (GetUnitAbilityLevel(caster, 'A04T')*0.15)
    set lvEb = 0.05*GetUnitAbilityLevel(caster, 'A04T')
    set lvW = GetUnitAbilityLevel(caster, 'A04R')
    set lvR = GetUnitAbilityLevel(caster, 'A04U')
    set nu = target
    set dmg = 60 + ( 40 * lvl )
    set dmgb = dmg
    set dist = 200 + (30*lvW)

	if lvR > 0 then
		set dmg = dmg + (dmg*(0.1+(0.1*lvR))*udg_lightball[GetPlayerId(GetOwningPlayer( caster )) + 1])
		call BallEnergy( caster, -3 )
	endif

    set lim = 4+lvW
    set lastunit = caster
    set g = CreateGroup()
    set h = CreateGroup()
    set n = CreateGroup()
    
    call dummyspawn( caster, 3, 0, 0 , 0 )
    loop
        exitwhen cyclA > 1
		set i = i + 1
		if i <= lim then
			set f = false
			call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), dist, null )
			loop
				set u = FirstOfGroup(g)
				exitwhen u == null
				if unitst( u, caster, "enemy" ) and u != target and not( IsUnitInGroup( u, n ) ) then
					call GroupAddUnit(h, u)
				endif
				call GroupRemoveUnit(g,u)
				set u = FirstOfGroup(g)
			endloop
			if not( IsUnitGroupEmptyBJ(h) ) then
				set cyclA = cyclA - 1
				set lastunit = target
				set target = GroupPickRandomUnit(h)
				call GroupClear( h )
				set f = true
			endif
			if i == 1 then
				set target = nu
				set lastunit = caster
			endif
			if not( IsUnitInGroup( target, n ) ) then
				if lvE > 1.1 then
					if i == 1 and not(f) then
						set dmg = dmg*lvE
					elseif i == 1 then
						set dmg = dmg*0.7
					else
						set dmg = dmg+(dmgb*lvEb)
					endif
				endif 

				set l = AddLightningEx("CLPB", true, GetUnitX(lastunit), GetUnitY(lastunit), GetUnitFlyHeight(lastunit) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
				set id = GetHandleId( l )

				call SaveTimerHandle( udg_hash, id, StringHash( "enba" ), CreateTimer() )
				set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "enba" ) ) ) 
				call SaveLightningHandle( udg_hash, id, StringHash( "enba" ), l )
				call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "enba" ) ), 0.5, false, function EnergyballACast )
				call UnitDamageTarget( bj_lastCreatedUnit, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
				call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( target ), GetUnitY( target ) ) )

				if lvW > 0 then
					set mana = mana+2+lvW
    				endif
			endif
			if f then
				call GroupAddUnit(n, target)
			endif
		endif
        set cyclA = cyclA + 1
    endloop

    if mana > 0 then
		call manast( caster, null, mana )
    endif

    if lvR > 0 then
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "nmdr" ) ), 3.5, true, function NomadRCast )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    call GroupClear( h )
    call DestroyGroup( h )
    call GroupClear( n )
    call DestroyGroup( n )
    set n = null
    set g = null
    set h = null
    set l = null
    set u = null
    set n = null
    set caster = null
    set target = null
    set lastunit = null
endfunction

//===========================================================================
function InitTrig_NomadQ takes nothing returns nothing
    set gg_trg_NomadQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NomadQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NomadQ, Condition( function Trig_NomadQ_Conditions ) )
    call TriggerAddAction( gg_trg_NomadQ, function Trig_NomadQ_Actions )
endfunction

