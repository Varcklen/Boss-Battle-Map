function Trig_InfernalR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1AC'
endfunction

function Trig_InfernalR_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer g
    local integer id
    local integer i
    local integer lvl
    local unit caster
    local real dur
    local integer golemLimit = 100
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A1AC'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    if lvl < 5 then
        set golemLimit = 2 + lvl
    endif
    set dur = 15+(5*lvl)
    set g = GetUnitAbilityLevel(caster, 'A1A6') - 1
    if g > golemLimit then
        set g = golemLimit
    endif
    if g > 0 then
        call platest(caster, -g )
        loop
            exitwhen cyclA > g
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'n02Y', GetUnitX( caster ) + GetRandomReal( -300, 300 ), GetUnitY( caster ) + GetRandomReal( -300, 300 ), GetUnitFacing( caster ) )
            call UnitApplyTimedLife(bj_lastCreatedUnit, 'BTLF', dur )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
            set cyclA = cyclA + 1
        endloop
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_InfernalR takes nothing returns nothing
    set gg_trg_InfernalR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_InfernalR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_InfernalR, Condition( function Trig_InfernalR_Conditions ) )
    call TriggerAddAction( gg_trg_InfernalR, function Trig_InfernalR_Actions )
endfunction

