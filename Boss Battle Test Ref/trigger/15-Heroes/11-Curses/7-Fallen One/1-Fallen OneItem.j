function Trig_Fallen_OneItem_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A02T' or GetLearnedSkill() == 'A05F' or GetLearnedSkill() == 'A05H' or GetLearnedSkill() == 'A085' and GetUnitAbilityLevel(GetLearningUnit(), GetLearnedSkill()) == 5
endfunction

function Trig_Fallen_OneItem_Actions takes nothing returns nothing
    local integer i = 0
    local integer it
    local unit u = GetLearningUnit()
    local integer k = GetPlayerId( GetOwningPlayer( u ) ) + 1
    
    if GetLearnedSkill() == 'A02T' then
        set i = 1
        set it = 'I0D9'
    elseif GetLearnedSkill() == 'A05F' then
        set i = 2
        set it = 'I0DI'
    elseif GetLearnedSkill() == 'A05H' then
        set i = 3
        set it = 'I040'
    elseif GetLearnedSkill() == 'A085' then
        set i = 4
        set it = 'I09S'
    endif

    if not(udg_FallenOneItems[i]) then
        if UnitInventoryCount(u) < 6 then
            call UnitAddItem(u, CreateItem(it, GetUnitX(u), GetUnitY(u)))
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        else
            set bj_lastCreatedItem = CreateItem(it, GetLocationX(udg_point[21+k]), GetLocationY(udg_point[21+k]))
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetItemX( bj_lastCreatedItem ), GetItemY( bj_lastCreatedItem ) ) )
            call DisplayTimedTextToPlayer( GetOwningPlayer(u), 0, 0, 10, "The artifact was teleported to the |cffffcc00preparation room|r." )
        endif
    endif
    set udg_FallenOneItems[i] = true
endfunction

//===========================================================================
function InitTrig_Fallen_OneItem takes nothing returns nothing
    set gg_trg_Fallen_OneItem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Fallen_OneItem, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_Fallen_OneItem, Condition( function Trig_Fallen_OneItem_Conditions ) )
    call TriggerAddAction( gg_trg_Fallen_OneItem, function Trig_Fallen_OneItem_Actions )
endfunction

