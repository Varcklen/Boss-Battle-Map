function Trig_Echosis_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A09P'
endfunction

function Trig_Echosis_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local real dmg
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "notcaster", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A09P'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif
    
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl", target, "origin" ) )
    set cyclAEnd = eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        set i = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "reson" ) ) 
        call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
        call shield( caster, caster, 50+i, 60 )
        call effst( caster, caster, null, 1, 60 )
        if not(udg_fightmod[3]) and combat( caster, true, GetSpellAbilityId() ) then
            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "reson" ), i + 25 )
        endif
        call ChangeToolItem( caster, 'I016', "|cffbe81f6", "|r", I2S(i + 75) )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Echosis takes nothing returns nothing
    set gg_trg_Echosis = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Echosis, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Echosis, Condition( function Trig_Echosis_Conditions ) )
    call TriggerAddAction( gg_trg_Echosis, function Trig_Echosis_Actions )
endfunction

