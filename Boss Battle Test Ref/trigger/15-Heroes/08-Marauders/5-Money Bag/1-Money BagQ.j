function Trig_Money_BagQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17T' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

globals
    constant integer MONEY_BAG_Q_X_DEVIATION = -150
    constant integer MONEY_BAG_Q_Y_DEVIATION = 150
    
    constant integer MONEY_BAG_Q_DAMAGE_PER_LEVEL = 50
    constant integer MONEY_BAG_Q_DAMAGE_FIRST_LEVEL_BONUS = 100
    
    constant real MONEY_BAG_Q_AOE = 400
endglobals

function MoneyBagQMove_Condition takes unit caster, unit target, integer id returns boolean
    local boolean isWork = true
    local integer pattern = LoadInteger(udg_hash, id, StringHash( "mbgqp" ) )
    local unit correctTarget = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ) )
    
    if IsUnitEnemy( target, GetOwningPlayer( caster ) ) then
        set isWork = false
    elseif pattern != udg_Pattern then
        set isWork = false
    elseif caster == target then
        set isWork = false
    elseif correctTarget != target then
        set isWork = false
    elseif IsUnitDead(caster) then
        set isWork = false
    elseif IsUnitDead(target) then
        set isWork = false
    elseif GetUnitAbilityLevel(caster, 'Avul') > 0 then//Invul
        set isWork = false
    elseif GetUnitAbilityLevel(target, 'A17U') == 0 then// Invul from ability
        set isWork = false
    elseif GetUnitAbilityLevel(target, 'A16J') > 0 then//MaidenQ
        set isWork = false
    endif
    
    set caster = null
    set target = null
    set correctTarget = null
    return isWork
endfunction

function MoneyBagQMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mbgq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mbgqt" ) )
	local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "mbgql" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "mbgq" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mbgqdmg" ) )
    local real x
    local real y

    if MoneyBagQMove_Condition(caster, target, id) then
        set x = GetUnitX( caster ) + MONEY_BAG_Q_X_DEVIATION
        set y = GetUnitY( caster ) + MONEY_BAG_Q_Y_DEVIATION
        call SetUnitX(target,x)
        call SetUnitY(target,y)
        call MoveLightningUnits( l, caster, target )
    else
        call GroupAoE(caster, null, GetUnitX( caster ), GetUnitY( caster ), dmg, MONEY_BAG_Q_AOE, TARGET_ENEMY, null, "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl")
        call SetUnitPathing( target, true )
        call UnitRemoveAbility( target, 'A17U' )
    	call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ), caster )
    	call DestroyLightning( l )
    	if not( RectContainsUnit( udg_Boss_Rect, target) ) and udg_combatlogic[GetPlayerId(GetOwningPlayer( target )) + 1] then
        	call SetUnitPositionLoc( target, GetRectCenter( udg_Boss_Rect ) )
    	endif
		call FlushChildHashtable( udg_hash, id )
		call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
    set l = null
endfunction

function MoneyBagQStart takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mbgq1" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mbgq1t" ) )
    local lightning l
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "mbgq1" ) )
    local real dmg = LoadInteger( udg_hash, id, StringHash( "mbgq1dmg" ) )
    local integer id1

	call SetUnitPathing( target, false )
	call UnitAddAbility( target, 'A17U' )

	set l = AddLightningEx("SPLK", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) , GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target))

	set id1 = GetHandleId( target )
	if LoadTimerHandle( udg_hash, id1, StringHash( "mbgq" ) ) == null  then
		call SaveTimerHandle( udg_hash, id1, StringHash( "mbgq" ), CreateTimer() )
	endif
	set id1 = GetHandleId( LoadTimerHandle( udg_hash, id1, StringHash( "mbgq" ) ) ) 
	call SaveInteger( udg_hash, id1, StringHash( "mbgq" ), lvl )
	call SaveUnitHandle( udg_hash, id1, StringHash( "mbgq" ), caster )
	call SaveUnitHandle( udg_hash, id1, StringHash( "mbgqt" ), target )
	call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ), target )
	call SaveLightningHandle( udg_hash, id1, StringHash( "mbgql" ), l )
    call SaveReal( udg_hash, id1, StringHash( "mbgqdmg" ), dmg )
    call SaveInteger(udg_hash, id1, StringHash( "mbgqp" ), udg_Pattern)
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mbgq" ) ), 0.02, true, function MoneyBagQMove )

	call DestroyTimer( GetExpiredTimer() )

	set caster = null
	set target = null
    set l = null
endfunction

function Trig_Money_BagQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local unit currentBindedUnit
    local lightning l
    local boolean isTargetNotOldTarget = true
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "notcaster", "vulnerable", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A17T'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

	set currentBindedUnit = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ) )
	if currentBindedUnit == target then
		set isTargetNotOldTarget = false
	endif
	call UnitRemoveAbility( currentBindedUnit, 'A17U' )
    call dummyspawn( caster, 1, 0, 0, 0 )
	call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ), bj_lastCreatedUnit )
    if currentBindedUnit != null then
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( currentBindedUnit ), StringHash( "mbgq" ) ), 0.01, false, function MoneyBagQMove )
    endif
    
    set dmg = MONEY_BAG_Q_DAMAGE_FIRST_LEVEL_BONUS + (MONEY_BAG_Q_DAMAGE_PER_LEVEL * lvl)
    call GroupAoE(caster, null, GetUnitX( caster ), GetUnitY( caster ), dmg, MONEY_BAG_Q_AOE, TARGET_ENEMY, null, "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl")

	if isTargetNotOldTarget and caster != target and IsUnitAlly( target, GetOwningPlayer( caster ) ) and target != null and IsUnitType( target, UNIT_TYPE_HERO) then
        set id = GetHandleId( target )
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", target, "chest") )
        if LoadTimerHandle( udg_hash, id, StringHash( "mbgq1" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "mbgq1" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mbgq1" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mbgq1" ), caster )
        call SaveUnitHandle( udg_hash, id, StringHash( "mbgq1t" ), target )
        call SaveInteger( udg_hash, id, StringHash( "mbgq1" ), lvl )
        call SaveReal( udg_hash, id, StringHash( "mbgq1dmg" ), dmg )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mbgq1" ) ), 0.01, false, function MoneyBagQStart )
	endif  

    set caster = null
    set target = null
    set currentBindedUnit = null
    set l = null
endfunction

//===========================================================================
function InitTrig_Money_BagQ takes nothing returns nothing
    set gg_trg_Money_BagQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Money_BagQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Money_BagQ, Condition( function Trig_Money_BagQ_Conditions ) )
    call TriggerAddAction( gg_trg_Money_BagQ, function Trig_Money_BagQ_Actions )
endfunction