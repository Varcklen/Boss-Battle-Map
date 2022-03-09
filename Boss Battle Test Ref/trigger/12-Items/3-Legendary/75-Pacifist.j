globals
    constant integer PACIFIST_REQUIRES = 4
endglobals

function Trig_Pacifist_Conditions takes nothing returns boolean
    return IsHeroHasItem(udg_FightEnd_Unit, 'I0GP') and udg_fightmod[3] == false
endfunction

function Trig_Pacifist_Actions takes nothing returns nothing
    local unit hero = udg_FightEnd_Unit
    local integer index = GetUnitUserData(hero)
    local item it = GetItemOfTypeFromUnitBJ(hero, 'I0GP')
    local integer currentState = LoadInteger( udg_hash, GetHandleId(it), StringHash(udg_QuestItemCode[19]) )
    local boolean changed = false
    local integer i 
    local real min = 0
    local integer minWho = 0
    
    set i = 1
    loop
        exitwhen i > 4
        if GetPlayerSlotState(Player( i - 1) ) == PLAYER_SLOT_STATE_PLAYING and (udg_DamageFight[i] < min or min == 0) then
            set minWho = i
            set min = udg_DamageFight[i]
        endif
        set i = i + 1
    endloop
    
    if index == minWho then
        set currentState = currentState + 1
        set changed = true
    endif
    
    if currentState >= PACIFIST_REQUIRES then
        call RemoveItem( it )
        call UnitAddItem(hero, CreateItem( 'I0GQ', GetUnitX(hero), GetUnitY(hero)))
        call textst( "|c00ffffff Pacifist done!", hero, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(hero), GetUnitY(hero) ) )
        set udg_QuestDone[index] = true
    elseif changed then
        call SaveInteger( udg_hash, GetHandleId(it), StringHash( udg_QuestItemCode[19]), currentState )
        call QuestDiscription( hero, 'I0GP', currentState, PACIFIST_REQUIRES )
    endif
    
    set it = null
    set hero = null
endfunction

//===========================================================================
function InitTrig_Pacifist takes nothing returns nothing
    call CreateEventTrigger( "udg_FightEnd_Real", function Trig_Pacifist_Actions, function Trig_Pacifist_Conditions )
endfunction

