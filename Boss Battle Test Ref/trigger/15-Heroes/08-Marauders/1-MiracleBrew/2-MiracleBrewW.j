function Trig_MiracleBrewW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0R4'
endfunction

function MiracleBrewWEnd takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrbw" ) ), LoadInteger( udg_hash, id, StringHash( "mrbw" ) ) )
    call UnitRemoveAbility( LoadUnitHandle( udg_hash, id, StringHash( "mrbw" ) ), 'B00F' )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_MiracleBrewW_Actions takes nothing returns nothing
    local integer id 
    local integer i
    local integer d
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        set t = 12
        call textst( udg_string[0] + GetObjectName('A0R4'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 12
    endif
    set t = timebonus(caster, t)
    
    set id = GetHandleId( target )
    
    if udg_Database_Hero[20] == 'O00N' then
        call DestroyEffect( AddSpecialEffectTarget( "Acid Ex.mdx", target, "origin" ) ) 
        set i = 'A0MY'
    else
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", target, "chest" ) )
        set i = 'A0RP'
    endif
    
    if not(IsUnitType( target, UNIT_TYPE_ANCIENT)) and not(IsUnitType( target, UNIT_TYPE_HERO)) then
        set d = lvl + 5
    else
        set d = lvl
    endif
    call UnitAddAbility( target, i )
    call SetUnitAbilityLevel( target, 'A0A1', d )
    
   if LoadTimerHandle( udg_hash, id, StringHash( "mrbw" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "mrbw" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mrbw" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "mrbw" ), target )
    call SaveInteger( udg_hash, id, StringHash( "mrbw" ), i )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "mrbw" ) ), t, false, function MiracleBrewWEnd )
    
    if BuffLogic() then
        call debuffst( caster, target, null, lvl, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_MiracleBrewW takes nothing returns nothing
    set gg_trg_MiracleBrewW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MiracleBrewW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MiracleBrewW, Condition( function Trig_MiracleBrewW_Conditions ) )
    call TriggerAddAction( gg_trg_MiracleBrewW, function Trig_MiracleBrewW_Actions )
endfunction

