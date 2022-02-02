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
	if udg_Endgame > 1 then
        call BlzSetUnitBaseDamage( GetEnteringUnit(), R2I(BlzGetUnitBaseDamage(GetEnteringUnit(), 0) * udg_Endgame), 0 )
        call BlzSetUnitMaxHP( GetEnteringUnit(), R2I(BlzGetUnitMaxHP(GetEnteringUnit()) * udg_Endgame) )
	endif
	call BlzSetUnitBaseDamage( GetEnteringUnit(), R2I(BlzGetUnitBaseDamage(GetEnteringUnit(), 0) * udg_BossAT), 0 )
    if udg_BossHP != 1 then
        call BlzSetUnitMaxHP( GetEnteringUnit(), R2I((BlzGetUnitMaxHP(GetEnteringUnit()) * udg_BossHP)+1) )
    endif
	if GetUnitTypeId(GetEnteringUnit()) != 'n00E' and GetUnitTypeId(GetEnteringUnit()) != 'n04P' and GetUnitTypeId(GetEnteringUnit()) != 'u008' then
        call SetUnitState(GetEnteringUnit(), UNIT_STATE_LIFE, GetUnitState(GetEnteringUnit(), UNIT_STATE_MAX_LIFE))
    endif
    if GetUnitTypeId(GetEnteringUnit()) != 'n035' then
        call RemoveGuardPosition(GetEnteringUnit())
    endif
    call spectimeunit( GetEnteringUnit(), "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl", "overhead", 0.6 )
    if not( RectContainsUnit( udg_Boss_Rect, GetEnteringUnit()) ) and GetUnitTypeId(GetEnteringUnit()) != 'h01F' then
        call SetUnitPositionLoc( GetEnteringUnit(), GetRectCenter( udg_Boss_Rect ) )
    endif
    if udg_modbad[21] then
        call UnitAddAbility( GetEnteringUnit(), 'A0SV' )
    endif
    if udg_modbad[19] and BlzGetUnitBaseDamage(GetEnteringUnit(), 0) > 5 and GetUnitDefaultMoveSpeed(GetEnteringUnit()) != 0 then
        call UnitAddAbility( GetEnteringUnit(), 'A0NC' )
    endif
    if GetUnitTypeId(GetEnteringUnit()) != 'n035' and GetOwningPlayer(GetEnteringUnit()) != Player(PLAYER_NEUTRAL_AGGRESSIVE) then
        call aggro( GetEnteringUnit() )
    endif
    if GetUnitTypeId(GetEnteringUnit()) == 'n00B' then 
        call UnitApplyTimedLife(GetEnteringUnit(), 'BTLF', 20)
    	set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( GetEnteringUnit() ), 'n00A', GetRectCenterX(udg_Boss_Rect) - 2000, GetRectCenterY(udg_Boss_Rect) + 600, 0 )
        call ShowUnitHide( bj_lastCreatedUnit )
        call SaveUnitHandle( udg_hash, GetHandleId( GetEnteringUnit() ), StringHash( "bob" ), bj_lastCreatedUnit )
        call RemoveUnit( gg_unit_h00F_0062 )
    	call ShowUnitHide( gg_unit_h00A_0034 )
        set DB_Boss_id[10][3] = 'n00A'
    elseif not(IsUnitType(GetEnteringUnit(), UNIT_TYPE_STRUCTURE)) and GetUnitAbilityLevel( GetEnteringUnit(), 'Avul') == 0 and udg_KillUnit > 0 and not(IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO)) then
        set udg_KillUnit = udg_KillUnit - 1
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIso\\AIsoTarget.mdl", GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())) )
        call KillUnit( GetEnteringUnit() )
    endif
endfunction

//===========================================================================
function InitTrig_SpawnUnit takes nothing returns nothing
    set gg_trg_SpawnUnit = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_SpawnUnit, GetWorldBounds() )
    call TriggerAddCondition( gg_trg_SpawnUnit, Condition( function Trig_SpawnUnit_Conditions ) )
    call TriggerAddAction( gg_trg_SpawnUnit, function Trig_SpawnUnit_Actions )
endfunction