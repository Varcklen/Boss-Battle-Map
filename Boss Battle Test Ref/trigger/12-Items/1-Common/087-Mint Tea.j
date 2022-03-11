function Trig_Mint_Tea_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0YP'
endfunction

function Trig_Mint_Tea_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer cyclAEnd 
    local real hp
    local real mp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0YP'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set hp = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.10
    set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.10
    
    call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, null, hp )
        call manast( caster, null, mp )
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Mint_Tea takes nothing returns nothing
    set gg_trg_Mint_Tea = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Mint_Tea, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Mint_Tea, Condition( function Trig_Mint_Tea_Conditions ) )
    call TriggerAddAction( gg_trg_Mint_Tea, function Trig_Mint_Tea_Actions )
endfunction

