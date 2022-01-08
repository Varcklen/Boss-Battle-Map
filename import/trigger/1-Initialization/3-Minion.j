    set udg_Boss_Minion[0] = GetSpellAbilityUnit()
    set udg_Boss_Minion[0] = GetSpellTargetUnit()
    set udg_Boss_Minion[0] = GetManipulatingUnit()
    
    GetUnitUserData(u)
    
    eyest( GetSpellAbilityUnit() )

    set hp = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.05
    set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.05

    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "111" )
    
    GroupAoE takes unit caster, unit dummy, real x, real y, real dmg, real area, string who, string strall, string str
    
    GetUnitAbilityLevel(udg_hero[i], 'B088') > 0
    
    call bufst( caster, target, 'A0S2', 'B06N', "slge2", t )
    
    words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", "Active!" )
    
    udg_FightEnd_Unit
    call TriggerRegisterVariableEvent( trig, "udg_FightEnd_Real", EQUAL, 1.00 )
    
    local integer cyclA = 1
    local integer cyclAEnd = eyest( GetSpellAbilityUnit() )

    loop
        exitwhen cyclA > cyclAEnd

        set cyclA = cyclA + 1
    endloop
    
    |cffbe81f7 |r
    
    GetRandomInt( 1, udg_Database_NumberItems[10] )
    
    struct
    
    endstruct