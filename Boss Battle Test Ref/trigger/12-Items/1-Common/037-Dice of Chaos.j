function Trig_Dice_of_Chaos_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A19W' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Dice_of_Chaos_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local unit caster
    local integer rand
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A19W'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd = eyest( caster )

    loop
        exitwhen cyclA > cyclAEnd
        set rand = GetRandomInt( 1,6 )
        if rand == 1 then
            set udg_RandomLogic = true
            set udg_Caster = caster
            call TriggerExecute( udg_DB_Trigger_Spec[GetRandomInt( 1, udg_Database_NumberItems[24] )] )
        elseif rand == 2 then
            set udg_RandomLogic = true
            set udg_Caster = caster
            set udg_Level = 2
            call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
        elseif rand == 3 then
            set udg_RandomLogic = true
            set udg_Caster = caster
            set udg_Level = 3
            call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
        elseif rand == 4 then
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", caster, "origin" ) )
            call dummyspawn( caster, 1, 0, 0, 0 )
            call UnitDamageTarget( bj_lastCreatedUnit, caster, 250, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            call manast( caster, null, 100 )
        elseif rand == 5 then
            set udg_RandomLogic = true
            set udg_Caster = caster
            set udg_Level = 5
            call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
        elseif rand == 6 then
            set bj_lastCreatedUnit = CreateUnit( Player(PLAYER_NEUTRAL_AGGRESSIVE), 'u000', GetUnitX(caster), GetUnitY(caster), 270 )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1 )
            call UnitAddAbility( bj_lastCreatedUnit, 'A0Q7' )
            call IssuePointOrder( bj_lastCreatedUnit, "dreadlordinferno", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) )
        endif        
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Dice_of_Chaos takes nothing returns nothing
    set gg_trg_Dice_of_Chaos = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dice_of_Chaos, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dice_of_Chaos, Condition( function Trig_Dice_of_Chaos_Conditions ) )
    call TriggerAddAction( gg_trg_Dice_of_Chaos, function Trig_Dice_of_Chaos_Actions )
endfunction

