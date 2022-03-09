globals
    string array DestroyerTool[4][6]//Способность/уровни
    integer array DestroyerMana[4][6]//Способность/уровни
endglobals

function Trig_AltarUp_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A122' or GetLearnedSkill() == 'A129' or GetLearnedSkill() == 'A12B'
endfunction

function Trig_AltarUp_Actions takes nothing returns nothing
    local unit u = GetLearningUnit()
    local integer lv

    call IssueImmediateOrderBJ( u, "unimmolation" )

    if GetUnitAbilityLevel( u, 'B08A') > 0 then
        if GetUnitAbilityLevel( u, 'A122') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A122' )
            call UnitAddAbility( u, 'A123' )
            set DestroyerTool[1][lv] = BlzGetAbilityExtendedTooltip('A122', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A122', BlzGetAbilityExtendedTooltip('A123', lv-1), lv-1 )
            set DestroyerMana[1][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A123'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A123' )
        endif
        
        if GetUnitAbilityLevel( u, 'A129') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A129' )
            call UnitAddAbility( u, 'A12A' )
            set DestroyerTool[2][lv] = BlzGetAbilityExtendedTooltip('A129', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A129', BlzGetAbilityExtendedTooltip('A12A', lv-1), lv-1 )
            set DestroyerMana[2][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12A'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A12A' )
        endif
        
        if GetUnitAbilityLevel( u, 'A12B') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A12B' )
            call UnitAddAbility( u, 'A12F' )
            set DestroyerTool[3][lv] = BlzGetAbilityExtendedTooltip('A12B', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A12B', BlzGetAbilityExtendedTooltip('A12F', lv-1), lv-1 )
            set DestroyerMana[3][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12B'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A12B'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12F'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A12F' )
        endif
    else
        if GetUnitAbilityLevel( u, 'A122') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A122' )
            set DestroyerTool[1][lv] = BlzGetAbilityExtendedTooltip('A122', lv-1)
            set DestroyerMana[1][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1)
        endif
        
        if GetUnitAbilityLevel( u, 'A129') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A129' )
            set DestroyerTool[2][lv] = BlzGetAbilityExtendedTooltip('A129', lv-1)
            set DestroyerMana[2][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1)
        endif
        
        if GetUnitAbilityLevel( u, 'A12B') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A12B' )
            set DestroyerTool[3][lv] = BlzGetAbilityExtendedTooltip('A12B', lv-1)
            set DestroyerMana[3][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12B'), ABILITY_ILF_MANA_COST, lv-1)
        endif
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_AltarUp takes nothing returns nothing
    set gg_trg_AltarUp = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarUp, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_AltarUp, Condition( function Trig_AltarUp_Conditions ) )
    call TriggerAddAction( gg_trg_AltarUp, function Trig_AltarUp_Actions )
endfunction

