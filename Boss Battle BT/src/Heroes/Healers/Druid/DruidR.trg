{
  "Id": 50333293,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "globals\r\n    constant integer DRUID_R_BOAR_LIFE_TIME = 30\r\n    constant integer DRUID_R_BOAR_ID = 'n003'\r\n    constant integer DRUID_R_CHANCE = 15\r\n    constant integer DRUID_R_RANGE_OF_SUMMON = 200\r\n    constant integer DRUID_R_BONUS_BOARS = 2\r\n    constant integer DRUID_R_BOARS_FIRST_LEVEL = 1\r\n    \r\n    constant integer DRUID_R_BOAR_ID_ALTERNATIVE = 'n018'\r\n    constant real DRUID_R_BOAR_SIZE_COUNTER = 0.4\r\n    constant real DRUID_R_BOAR_SIZE_LIMIT_BIG = 3\r\n    constant real DRUID_R_BOAR_SIZE_LIMIT_SMALL = 1.6\r\n    \r\n    constant string DRUID_R_SPAWN_ANIMATION = \"Abilities\\\\Spells\\\\Other\\\\Silence\\\\SilenceAreaBirth.mdl\"\r\nendglobals\r\n\r\nfunction Trig_DruidR_Conditions takes nothing returns boolean\r\n    return GetSpellAbilityId() == 'A0AL'\r\nendfunction\r\n\r\nfunction DruidR_Alternative takes unit caster, integer boarsSummoned, real x, real y returns nothing\r\n    local unit dummyPig = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID, x, y, 0 )\r\n    local integer pigDamage = boarsSummoned * GetUnitDamage(dummyPig)\r\n    local integer pigHealth = boarsSummoned * BlzGetUnitMaxHP(dummyPig)\r\n    local real pigSize = RMinBJ( DRUID_R_BOAR_SIZE_LIMIT_BIG, RMaxBJ( DRUID_R_BOAR_SIZE_LIMIT_SMALL, boarsSummoned * DRUID_R_BOAR_SIZE_COUNTER) )\r\n\r\n    call RemoveUnit(dummyPig)\r\n    \r\n    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID_ALTERNATIVE, x, y, GetUnitFacing( caster ) )\r\n    call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', DRUID_R_BOAR_LIFE_TIME )\r\n    call spectimeunit( bj_lastCreatedUnit, DRUID_R_SPAWN_ANIMATION, \"overhead\", 0.6 )\r\n    \r\n    call BlzSetUnitMaxHP( bj_lastCreatedUnit, pigHealth )\r\n    call BlzSetUnitBaseDamage( bj_lastCreatedUnit, pigDamage - GetUnitAvgDiceDamage(bj_lastCreatedUnit), 0 )\r\n    call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )\r\n    \r\n    call SetUnitScale( bj_lastCreatedUnit, pigSize, pigSize, pigSize )\r\n    \r\n    set dummyPig = null\r\n    set caster = null\r\nendfunction\r\n\r\nfunction DruidR takes unit caster, integer boarsSummoned, real x, real y returns nothing\r\n    local integer i = 1\r\n\r\n    loop\r\n        exitwhen i > boarsSummoned\r\n        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), DRUID_R_BOAR_ID, x, y, GetUnitFacing( caster ) )\r\n        call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', DRUID_R_BOAR_LIFE_TIME )\r\n        call spectimeunit( bj_lastCreatedUnit, DRUID_R_SPAWN_ANIMATION, \"overhead\", 0.6 )\r\n        set i = i + 1\r\n    endloop\r\n\r\n    set caster = null\r\nendfunction\r\n\r\nfunction Trig_DruidR_Actions takes nothing returns nothing\r\n    local integer lvl\r\n    local unit caster\r\n    local real x\r\n    local real y\r\n    local integer boarsSummoned\r\n    \r\n    if CastLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n    elseif RandomLogic() then\r\n        set caster = udg_Caster\r\n        set lvl = udg_Level\r\n        call textst( udg_string[0] + GetObjectName('A0AL'), caster, 64, 90, 10, 1.5 )\r\n    else\r\n        set caster = GetSpellAbilityUnit()\r\n        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())\r\n    endif\r\n    \r\n    set x = GetUnitX( caster ) + DRUID_R_RANGE_OF_SUMMON * Cos( 0.017 * GetUnitFacing( caster ) )\r\n    set y = GetUnitY( caster ) + DRUID_R_RANGE_OF_SUMMON * Sin( 0.017 * GetUnitFacing( caster ) )\r\n    \r\n    set boarsSummoned = DRUID_R_BOARS_FIRST_LEVEL + lvl\r\n    \r\n    if luckylogic( caster, DRUID_R_CHANCE, 1, 100 ) then\r\n        set boarsSummoned = DRUID_R_BONUS_BOARS * boarsSummoned\r\n    endif\r\n    \r\n    if Aspects_IsHeroAspectActive(caster, ASPECT_03 ) then\r\n        call DruidR_Alternative(caster, boarsSummoned, x, y )\r\n    else\r\n        call DruidR(caster, boarsSummoned, x, y )\r\n    endif\r\n    \r\n    set caster = null\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_DruidR takes nothing returns nothing\r\n    set gg_trg_DruidR = CreateTrigger(  )\r\n    call TriggerRegisterAnyUnitEventBJ( gg_trg_DruidR, EVENT_PLAYER_UNIT_SPELL_EFFECT )\r\n    call TriggerAddCondition( gg_trg_DruidR, Condition( function Trig_DruidR_Conditions ) )\r\n    call TriggerAddAction( gg_trg_DruidR, function Trig_DruidR_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}