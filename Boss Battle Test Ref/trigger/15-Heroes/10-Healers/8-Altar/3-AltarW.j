function Trig_AltarW_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel(GetOrderedUnit(), 'A121') > 0
endfunction

function Trig_AltarW_Actions takes nothing returns nothing
    local unit u = GetOrderedUnit()
    local integer lvl = GetUnitAbilityLevel( u, 'A121' )
    local integer lv

    if GetIssuedOrderId() == OrderId("immolation") then
        call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Undead\\UDeathSmall\\UDeathSmall.mdl", GetUnitX(u), GetUnitY(u)) )
        call UnitAddAbility( u, 'A12W')
        call SetUnitAbilityLevel( u, 'A12W', lvl )
        call UnitAddAbility( u, 'Amrf')
        call SetUnitFlyHeight( u, 70, 0 )
        call UnitRemoveAbility( u, 'Amrf')
        call SetUnitSkin( u, 'N04X' )
        call AddUnitAnimationProperties(u, "alternate", true)
        
        if GetUnitAbilityLevel( u, 'A122') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A122' )
            call UnitAddAbility( u, 'A123' )
            call BlzSetAbilityIcon( 'A122', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A123'), ABILITY_SF_ICON_RESEARCH) )
            set DestroyerTool[1][lv] = BlzGetAbilityExtendedTooltip('A122', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A122', BlzGetAbilityExtendedTooltip('A123', lv-1), lv-1 )
            set DestroyerMana[1][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A123'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A123' )
        endif
        
        if GetUnitAbilityLevel( u, 'A129') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A129' )
            call UnitAddAbility( u, 'A12A' )
            call BlzSetAbilityIcon( 'A129', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A12A'), ABILITY_SF_ICON_RESEARCH) )
            set DestroyerTool[2][lv] = BlzGetAbilityExtendedTooltip('A129', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A129', BlzGetAbilityExtendedTooltip('A12A', lv-1), lv-1 )
            set DestroyerMana[2][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12A'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A12A' )
        endif
        
        if GetUnitAbilityLevel( u, 'A12B') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A12B' )
            call UnitAddAbility( u, 'A12F' )
            call BlzSetAbilityIcon( 'A12B', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A12F'), ABILITY_SF_ICON_RESEARCH) )
            set DestroyerTool[3][lv] = BlzGetAbilityExtendedTooltip('A12B', lv-1)
            call BlzSetAbilityExtendedTooltip( 'A12B', BlzGetAbilityExtendedTooltip('A12F', lv-1), lv-1 )
            set DestroyerMana[3][lv] = BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1)
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A12B'), ABILITY_ILF_MANA_COST, lv-1, BlzGetAbilityIntegerLevelField(BlzGetUnitAbility(u, 'A12F'), ABILITY_ILF_MANA_COST, lv-1) )
            call UnitRemoveAbility( u, 'A12F' )
        endif
    elseif GetIssuedOrderId() == OrderId("unimmolation") then
        call DestroyEffect( AddSpecialEffect( "Objects\\Spawnmodels\\Undead\\UDeathSmall\\UDeathSmall.mdl", GetUnitX(u), GetUnitY(u)) )
        call UnitRemoveAbility( u, 'A12W')
        call UnitAddAbility( u, 'Amrf')
        call SetUnitFlyHeight( u, 0, 0 )
        call UnitRemoveAbility( u, 'Amrf')
        call SetUnitSkin( u, 'N04W' )
        call AddUnitAnimationProperties(u, "alternate", false)
        
        if GetUnitAbilityLevel( u, 'A122') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A122' )
            call BlzSetAbilityIcon( 'A122', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A122'), ABILITY_SF_ICON_RESEARCH) )
            call BlzSetAbilityExtendedTooltip( 'A122', DestroyerTool[1][lv], lv-1 )
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A122'), ABILITY_ILF_MANA_COST, lv-1, DestroyerMana[1][lv] )
        endif
        
        if GetUnitAbilityLevel( u, 'A129') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A129' )
            call BlzSetAbilityIcon( 'A129', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A129'), ABILITY_SF_ICON_RESEARCH) )
            call BlzSetAbilityExtendedTooltip( 'A129', DestroyerTool[2][lv], lv-1 )
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A129'), ABILITY_ILF_MANA_COST, lv-1, DestroyerMana[2][lv] )
        endif
        
        if GetUnitAbilityLevel( u, 'A12B') > 0 then
            set lv = GetUnitAbilityLevel( u, 'A12B' )
            call BlzSetAbilityIcon( 'A12B', BlzGetAbilityStringField(BlzGetUnitAbility(u, 'A12B'), ABILITY_SF_ICON_RESEARCH) )
            call BlzSetAbilityExtendedTooltip( 'A12B', DestroyerTool[3][lv], lv-1 )
            call BlzSetAbilityIntegerLevelFieldBJ( BlzGetUnitAbility(u, 'A12B'), ABILITY_ILF_MANA_COST, lv-1, DestroyerMana[3][lv] )
        endif
    endif

    set u = null
endfunction

//===========================================================================
function InitTrig_AltarW takes nothing returns nothing
    set gg_trg_AltarW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AltarW, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    call TriggerAddCondition( gg_trg_AltarW, Condition( function Trig_AltarW_Conditions ) )
    call TriggerAddAction( gg_trg_AltarW, function Trig_AltarW_Actions )
endfunction