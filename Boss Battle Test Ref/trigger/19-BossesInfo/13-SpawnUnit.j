function SpawnUnit_NoMinions takes unit u returns boolean
    local boolean l = true
    if GetUnitTypeId(u) == 'h01V' then
        set l = false
    endif
    if GetUnitTypeId(u) == 'h009' then
        set l = false
    endif
    if GetUnitTypeId(u) == 'h01F' then
        set l = false
    endif
    if GetUnitTypeId(u) == 'ninf' then
        set l = false
    endif
    set u = null
    return l
endfunction

function Trig_SpawnUnit_Conditions takes nothing returns boolean
    return not( IsUnitType(GetEnteringUnit(), UNIT_TYPE_ANCIENT ) ) and udg_fightmod[0] and GetUnitName(GetEnteringUnit()) != "dummy" and ( GetOwningPlayer(GetEnteringUnit()) == Player(10) or GetOwningPlayer(GetEnteringUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE) ) and SpawnUnit_NoMinions(GetEnteringUnit())
endfunction

function Trig_SpawnUnit_Actions takes nothing returns nothing
    local unit u = GetEnteringUnit()
    if udg_Boss_LvL > 1 or udg_Endgame > 1 then
        call BlzSetUnitAttackCooldown(u,BlzGetUnitAttackCooldown(u,0) / HardModAspd[udg_HardNum],0)
    endif
    if udg_Endgame > 1 then
        call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_Endgame - GetUnitAvgDiceDamage(u)), 0)
        call BlzSetUnitMaxHP( u, R2I(BlzGetUnitMaxHP(u) * udg_Endgame) )
	endif
    call BlzSetUnitBaseDamage( u, R2I(GetUnitDamage(u) * udg_BossAT - GetUnitAvgDiceDamage(u)), 0 )
    if udg_BossHP != 1 then
        call BlzSetUnitMaxHP( u, R2I((BlzGetUnitMaxHP(u) * udg_BossHP)+1) )
    endif
	if GetUnitTypeId(u) != 'n00E' and GetUnitTypeId(u) != 'n04P' and GetUnitTypeId(u) != 'u008' then
        call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
    endif
    if GetUnitTypeId(u) != 'n035' then
        call RemoveGuardPosition(u)
    endif
    call spectimeunit( u, "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl", "overhead", 0.6 )
    if not( RectContainsUnit( udg_Boss_Rect, u) ) and GetUnitTypeId(u) != 'h01F' then
        call SetUnitPositionLoc( u, GetRectCenter( udg_Boss_Rect ) )
    endif
    if udg_modbad[21] then
        call UnitAddAbility( u, 'A0SV' )
    endif
    if udg_modbad[19] and BlzGetUnitBaseDamage(u, 0) > 5 and GetUnitDefaultMoveSpeed(u) != 0 then
        call UnitAddAbility( u, 'A0NC' )
    endif
    if GetUnitTypeId(u) != 'n035' and GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) then
        call aggro( u )
    endif
    if GetUnitTypeId(u) == 'n00B' then 
        call UnitApplyTimedLife(u, 'BTLF', 20)
    	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( u ), 'n00A', GetRectCenterX(udg_Boss_Rect) - 2000, GetRectCenterY(udg_Boss_Rect) + 600, 0 )
        call ShowUnitHide( bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( "bob" ), bj_lastCreatedUnit )
        call RemoveUnit( gg_unit_h00F_0062 )
    	call ShowUnitHide( gg_unit_h00A_0034 )
        set DB_Boss_id[10][3] = 'n00A'
    elseif not(IsUnitType(u, UNIT_TYPE_STRUCTURE)) and GetUnitAbilityLevel( u, 'Avul') == 0 and udg_KillUnit > 0 and not(IsUnitType(u, UNIT_TYPE_HERO)) then
        set udg_KillUnit = udg_KillUnit - 1
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIso\\AIsoTarget.mdl", GetUnitX(u), GetUnitY(u)) )
        call KillUnit( u )
    endif
    set u = null
endfunction

//===========================================================================
function InitTrig_SpawnUnit takes nothing returns nothing
    set gg_trg_SpawnUnit = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_SpawnUnit, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_SpawnUnit, Condition( function Trig_SpawnUnit_Conditions ) )
    call TriggerAddAction( gg_trg_SpawnUnit, function Trig_SpawnUnit_Actions )
endfunction