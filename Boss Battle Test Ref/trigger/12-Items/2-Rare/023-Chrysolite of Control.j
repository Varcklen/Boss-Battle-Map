function Trig_Chrysolite_of_Control_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A182'
endfunction

function ChrysoliteCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "crfp" ) )
    local integer hp = LoadInteger( udg_hash, id, StringHash( "crfphp" ) )
    local integer at = LoadInteger( udg_hash, id, StringHash( "crfpat" ) )

    if GetUnitState(u, UNIT_STATE_LIFE) > 0.405 then
        call UnitRemoveAbility( u, 'A19V' )
        call UnitRemoveAbility( u, 'B03K' )
        call BlzSetUnitMaxHP( u, BlzGetUnitMaxHP(u) - hp )
        call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - at, 0 )
    endif
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_Chrysolite_of_Control_Actions takes nothing returns nothing
    local integer x
    local unit caster
    local unit target
    local integer hp
    local real t
    local integer at
    local integer id
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = 60
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "pris", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A182'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
        set t = 60
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 60
    endif
    set t = timebonus(caster, t)

    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", target, "origin" ) )
    
    set x = eyest( caster )
    if not(IsUnitType( target, UNIT_TYPE_HERO)) and not(IsUnitType( target, UNIT_TYPE_ANCIENT)) and GetUnitTypeId(target) != 'u00X' and GetUnitAbilityLevel(target, 'B03K') == 0 then
        call UnitAddAbility( target, 'A19V' )
    
        set hp = BlzGetUnitMaxHP(target)
        set at = GetUnitDamage(target)
        call BlzSetUnitMaxHP( target, BlzGetUnitMaxHP(target) + hp )
        call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + hp)
        call BlzSetUnitBaseDamage( target, BlzGetUnitBaseDamage(target, 0) + at, 0 )
        
        set id = GetHandleId( target )
        if LoadTimerHandle( udg_hash, id, StringHash( "crfp" ) ) == null   then
            call SaveTimerHandle( udg_hash, id, StringHash( "crfp" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "crfp" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "crfp" ), target )
        call SaveInteger( udg_hash, id, StringHash( "crfphp" ), hp )
        call SaveInteger( udg_hash, id, StringHash( "crfpat" ), at )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "crfp" ) ), t, false, function ChrysoliteCast ) 
        
        call effst( caster, target, null, 1, t )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Chrysolite_of_Control takes nothing returns nothing
    set gg_trg_Chrysolite_of_Control = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Chrysolite_of_Control, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Chrysolite_of_Control, Condition( function Trig_Chrysolite_of_Control_Conditions ) )
    call TriggerAddAction( gg_trg_Chrysolite_of_Control, function Trig_Chrysolite_of_Control_Actions )
endfunction

