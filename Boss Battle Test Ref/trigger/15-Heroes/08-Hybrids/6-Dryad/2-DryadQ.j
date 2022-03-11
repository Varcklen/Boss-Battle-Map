function Trig_DryadQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0HW'
endfunction

function Trig_DryadQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real size
    local integer rand
    local integer array k
    local integer i = 0
    local integer cyclA
  
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0HW'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set k[cyclA] = 0
        if CountLivingPlayerUnitsOfTypeId(udg_DryadMinion[cyclA], GetOwningPlayer(caster)) == 0 then
            set i = i + 1
            set k[i] = udg_DryadMinion[cyclA]
        endif
        set cyclA = cyclA + 1
    endloop
    
    if i > 0 then
        set rand = GetRandomInt( 1, i )
        
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), k[rand], GetUnitX( caster ) + GetRandomReal( -128, 128 ), GetUnitY( caster ) + GetRandomReal( -128, 128 ), GetRandomReal( 0, 360 ) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )

        set size = BlzGetUnitRealField(bj_lastCreatedUnit, UNIT_RF_SCALING_VALUE)+(0.05*lvl)
        call BlzSetUnitMaxHP( bj_lastCreatedUnit, R2I(BlzGetUnitMaxHP(bj_lastCreatedUnit)+((lvl-1)*udg_DryadMinionHP[rand])) )
        call BlzSetUnitBaseDamage( bj_lastCreatedUnit, R2I(BlzGetUnitBaseDamage(bj_lastCreatedUnit, 0)+((lvl-1)*udg_DryadMinionAT[rand])), 0 )
        call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
        call BlzSetUnitArmor( bj_lastCreatedUnit, lvl )
        call SetUnitScale( bj_lastCreatedUnit, size, size, size )
    else
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", caster, "origin" ) )
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_DryadQ takes nothing returns nothing
    set gg_trg_DryadQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DryadQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DryadQ, Condition( function Trig_DryadQ_Conditions ) )
    call TriggerAddAction( gg_trg_DryadQ, function Trig_DryadQ_Actions )
endfunction