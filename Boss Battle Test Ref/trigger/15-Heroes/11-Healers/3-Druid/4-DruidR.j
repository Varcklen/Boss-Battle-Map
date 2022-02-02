globals
    constant integer DRUID_R_BOAR_LIFE_TIME = 30
    constant integer DRUID_R_BOAR_ID = 'n003'
    constant integer DRUID_R_CHANCE = 15
    constant integer DRUID_R_RANGE_OF_SUMMON = 200
    constant integer DRUID_R_BONUS_BOARS = 2
    constant integer DRUID_R_BOARS_FIRST_LEVEL = 1
    
    constant integer DRUID_R_BOAR_ID_ALTERNATIVE = 'n018'
    constant real DRUID_R_BOAR_SIZE_COUNTER = 0.4
    constant real DRUID_R_BOAR_SIZE_LIMIT_BIG = 3
    constant real DRUID_R_BOAR_SIZE_LIMIT_SMALL = 1.6
    
    constant string DRUID_R_SPAWN_ANIMATION = "Abilities\\Spells\\Other\\Silence\\SilenceAreaBirth.mdl"
endglobals

function Trig_DruidR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0AL'
endfunction

function DruidR_Alternative takes unit caster, integer boarsSummoned, real x, real y returns nothing
    local unit dummyPig = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID, x, y, 0 )
    local integer pigDamage = boarsSummoned * BlzGetUnitBaseDamage(dummyPig, 0)
    local integer pigHealth = boarsSummoned * BlzGetUnitMaxHP(dummyPig)
    local real pigSize = RMinBJ( DRUID_R_BOAR_SIZE_LIMIT_BIG, RMaxBJ( DRUID_R_BOAR_SIZE_LIMIT_SMALL, boarsSummoned * DRUID_R_BOAR_SIZE_COUNTER) )

    call RemoveUnit(dummyPig)
    
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID_ALTERNATIVE, x, y, GetUnitFacing( caster ) )
    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', DRUID_R_BOAR_LIFE_TIME )
    call spectimeunit( bj_lastCreatedUnit, DRUID_R_SPAWN_ANIMATION, "overhead", 0.6 )
    
    call BlzSetUnitMaxHP( bj_lastCreatedUnit, pigHealth )
    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, pigDamage, 0 )
    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
    
    call SetUnitScale( bj_lastCreatedUnit, pigSize, pigSize, pigSize )
    
    set dummyPig = null
    set caster = null
endfunction

function DruidR takes unit caster, integer boarsSummoned, real x, real y returns nothing
    local integer i = 1

    loop
        exitwhen i > boarsSummoned
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID, x, y, GetUnitFacing( caster ) )
        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', DRUID_R_BOAR_LIFE_TIME )
        call spectimeunit( bj_lastCreatedUnit, DRUID_R_SPAWN_ANIMATION, "overhead", 0.6 )
        set i = i + 1
    endloop

    set caster = null
endfunction

function Trig_DruidR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real x
    local real y
    local integer boarsSummoned
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0AL'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set x = GetUnitX( caster ) + DRUID_R_RANGE_OF_SUMMON * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + DRUID_R_RANGE_OF_SUMMON * Sin( 0.017 * GetUnitFacing( caster ) )
    
    set boarsSummoned = DRUID_R_BOARS_FIRST_LEVEL + lvl
    
    if luckylogic( caster, DRUID_R_CHANCE, 1, 100 ) then
        set boarsSummoned = DRUID_R_BONUS_BOARS * boarsSummoned
    endif
    
    if Aspects_IsHeroAspectActive(caster, ASPECT_03 ) then
        call DruidR_Alternative(caster, boarsSummoned, x, y )
    else
        call DruidR(caster, boarsSummoned, x, y )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_DruidR takes nothing returns nothing
    set gg_trg_DruidR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DruidR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DruidR, Condition( function Trig_DruidR_Conditions ) )
    call TriggerAddAction( gg_trg_DruidR, function Trig_DruidR_Actions )
endfunction

