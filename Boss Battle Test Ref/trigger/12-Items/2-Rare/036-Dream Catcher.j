globals
    constant integer DREAM_CATCHER_USE_COUNT = 3
endglobals

function Trig_Dream_Catcher_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0G5' and not( udg_fightmod[3] ) and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Dream_Catcher_Actions takes nothing returns nothing
    local integer use
    local unit caster
    local integer i
    local integer index
    local integer firstAbilityIndex
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0G5'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set index = GetPlayerId(GetOwningPlayer(caster)) + 1
    set firstAbilityIndex = udg_HeroNum[index]
    set lvl = IMaxBJ(1, GetUnitAbilityLevel(caster, udg_DB_Hero_FirstSpell[firstAbilityIndex]) )
    
    set use = eyest( caster ) * DREAM_CATCHER_USE_COUNT
    set i = 1
    loop
        exitwhen i > use
        set udg_RandomLogic = true
        set udg_Caster = caster
        set udg_Level = lvl
        call TriggerExecute( udg_DB_Trigger_One[firstAbilityIndex] )
        set i = i + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Dream_Catcher takes nothing returns nothing
    set gg_trg_Dream_Catcher = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dream_Catcher, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dream_Catcher, Condition( function Trig_Dream_Catcher_Conditions ) )
    call TriggerAddAction( gg_trg_Dream_Catcher, function Trig_Dream_Catcher_Actions )
endfunction

