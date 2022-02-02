function Trig_OgreR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0F1'
endfunction

function OgreRCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "ogrr" ) )

    call UnitRemoveAbility( u, 'A0EO' )
    call UnitRemoveAbility( u, 'B069' )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_OgreR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local integer sp
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0F1'), caster, 64, 90, 10, 1.5 )
        set t = 25
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 25
    endif
    set t = timebonus(caster, t)
    set id = GetHandleId( caster )
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", caster, "origin" ) )
    
    call UnitAddAbility( caster, 'A0EO' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "ogrr" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "ogrr" ), CreateTimer() )
    endif
	set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "ogrr" ) ) ) 
	call SaveUnitHandle( udg_hash, id, StringHash( "ogrr" ), caster )
    call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "ogrr" ), 0 )
    call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "ogrrc" ), 0.01 + ( 0.01 * lvl ) )
	call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "ogrr" ) ), t, false, function OgreRCast )
    
    if BuffLogic() then
        call effst( caster, caster, "Trig_OgreR_Actions", lvl, t )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_OgreR takes nothing returns nothing
    set gg_trg_OgreR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OgreR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OgreR, Condition( function Trig_OgreR_Conditions ) )
    call TriggerAddAction( gg_trg_OgreR, function Trig_OgreR_Actions )
endfunction