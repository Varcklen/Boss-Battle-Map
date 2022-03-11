function Trig_MimicQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A08M'
endfunction

function MimicQMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "mmcq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "mmcqt" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "mmcq" ) ) + 1
    local integer ce = LoadInteger( udg_hash, id, StringHash( "mmcqc" ) ) + 1
    local integer t = LoadInteger( udg_hash, id, StringHash( "mmcqt" ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "mmcq" ) )
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "mmcql" ) )

    if ce <= t and DistanceBetweenUnits(caster, target) < 900 and caster != target and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call MoveLightningUnits( l, caster, target )
        if c >= 50 then
            call SetUnitState( target, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( target, UNIT_STATE_LIFE) - dmg ))
            call SetUnitState( caster, UNIT_STATE_LIFE, RMaxBJ(0,GetUnitState( caster, UNIT_STATE_LIFE) + dmg ))
            call SaveInteger( udg_hash, id, StringHash( "mmcq" ), 0 )
            call SaveInteger( udg_hash, id, StringHash( "mmcqc" ), ce )
        else
            call SaveInteger( udg_hash, id, StringHash( "mmcq" ), c )
        endif
    else
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_MimicQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local lightning l
    local real t
    local boolean k = false
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notcaster", "", "", "" )
        set lvl = udg_Level
	set t = 10
        call textst( udg_string[0] + GetObjectName('A08M'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
	set t = 10
    endif
    set t = timebonus(caster, t)

	set dmg = GetUnitState(target, UNIT_STATE_MAX_LIFE) * (0.01+(0.01*lvl))
	if IsUnitType( target, UNIT_TYPE_ANCIENT) then
		set dmg = dmg*0.1
	endif

    call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Orc\\OrcSmallDeathExplode\\OrcSmallDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )
    set id = GetHandleId( target )
    if LoadTimerHandle( udg_hash, id, StringHash( "mmcq" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "mmcq" ), CreateTimer() )
        set k = true
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mmcq" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "mmcq" ), caster )
    call SaveUnitHandle( udg_hash, id, StringHash( "mmcqt" ), target )
    if k then
        set l = AddLightningEx("PISU", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) , GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target))
        call SaveLightningHandle( udg_hash, id, StringHash( "mmcql" ), l )
    endif
    call SaveInteger( udg_hash, id, StringHash( "mmcqt" ), R2I(t) )
    call SaveReal( udg_hash, id, StringHash( "mmcq" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mmcq" ) ), 0.02, true, function MimicQMove ) 

	call taunt( caster, target, t )

    set caster = null
    set target = null
    set l = null
endfunction

//===========================================================================
function InitTrig_MimicQ takes nothing returns nothing
    set gg_trg_MimicQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MimicQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MimicQ, Condition( function Trig_MimicQ_Conditions ) )
    call TriggerAddAction( gg_trg_MimicQ, function Trig_MimicQ_Actions )
endfunction