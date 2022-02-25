function Trig_Jade_snake_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A023' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Jade_snake_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA = 1
    local integer x
    local integer i
    local integer k
    local integer rand 
    
    if CastLogic() then
        set caster = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A023'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    set x = eyest( caster )
    set i = GetPlayerId( GetOwningPlayer( caster ) ) + 1
    set k = GetPlayerId( GetOwningPlayer( udg_hero[i] ) ) + 1
    
    call spectimeunit( caster, "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl", "origin", 2 )
    loop
        exitwhen cyclA > 1
        set rand = GetRandomInt( 1, udg_Database_NumberItems[13] )
        if udg_DB_Hero_SpecAb[rand] != udg_Ability_Uniq[k] and udg_DB_Hero_SpecAbPlus[rand] != udg_Ability_Uniq[k] then
            call NewUniques( caster, udg_DB_Hero_SpecAb[rand] )
        else
            set cyclA = cyclA - 1
        endif
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_Jade_snake takes nothing returns nothing
    set gg_trg_Jade_snake = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Jade_snake, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Jade_snake, Condition( function Trig_Jade_snake_Conditions ) )
    call TriggerAddAction( gg_trg_Jade_snake, function Trig_Jade_snake_Actions )
endfunction