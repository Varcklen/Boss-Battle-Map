function Trig_OrbUse_Conditions takes nothing returns boolean
    if udg_logic[36] then
        return false
    endif
    if not( Orb_Logic(GetManipulatedItem()) ) then
        return false
    endif
    return true
endfunction

function Trig_OrbUse_Actions takes nothing returns nothing
    local unit n = GetManipulatingUnit()
    local integer add = 0
    
    if inv(n,'I08Y') > 1 then//arcane
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        set add = 'I0DK'
    elseif inv(n,'I08Z') > 1 then//fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I091'
    elseif inv(n,'I090') > 1 then//frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0DF'
    elseif inv(n,'I0EP') > 1 then//earth
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        set add = 'I0EQ'
    elseif inv(n,'I0F0') > 1 then//nature
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        set add = 'I0F1'
    elseif inv(n,'I0FJ') > 1 then//light
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        set add = 'I0FK'
    elseif inv(n,'I0FU') > 1 then//light
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        set add = 'I0FV'
    elseif inv(n,'I08Y') > 0 and inv(n,'I08Z') > 0 then//arcane+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I0AN'
    elseif inv(n,'I08Y') > 0 and inv(n,'I090') > 0 then//arcane+frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0DJ'
    elseif inv(n,'I090') > 0 and inv(n,'I08Z') > 0 then//frost+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0AH'
    elseif inv(n,'I0EP') > 0 and inv(n,'I08Z') > 0 then//earth+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I0ER'
    elseif inv(n,'I0EP') > 0 and inv(n,'I090') > 0 then//earth+frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0ES'
    elseif inv(n,'I0EP') > 0 and inv(n,'I08Y') > 0 then//earth+arcane
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        set add = 'I0ET'
    elseif inv(n,'I0F0') > 0 and inv(n,'I08Z') > 0 then//nature+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I0F4'
    elseif inv(n,'I0F0') > 0 and inv(n,'I0EP') > 0 then//earth+nature
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        set add = 'I0F2'
    elseif inv(n,'I0F0') > 0 and inv(n,'I090') > 0 then//nature+frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0F5'
    elseif inv(n,'I0F0') > 0 and inv(n,'I08Y') > 0 then//nature+arcane
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        set add = 'I0F3'
    elseif inv(n,'I0FJ') > 0 and inv(n,'I090') > 0 then//light+frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0FO'
    elseif inv(n,'I0FJ') > 0 and inv(n,'I08Y') > 0 then//light+arcane
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        set add = 'I0FM'
    elseif inv(n,'I0FJ') > 0 and inv(n,'I08Z') > 0 then//light+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I0FN'
    elseif inv(n,'I0FJ') > 0 and inv(n,'I0EP') > 0 then//earth+light
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        set add = 'I0FL'
    elseif inv(n,'I0F0') > 0 and inv(n,'I0FJ') > 0 then//nature+light
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        set add = 'I0FP'
    elseif inv(n,'I0F0') > 0 and inv(n,'I0FU') > 0 then//nature+dark
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0F0'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        set add = 'I0FZ'
    elseif inv(n,'I0FU') > 0 and inv(n,'I090') > 0 then//dark+frost
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I090'))
        set add = 'I0FY'
    elseif inv(n,'I0FU') > 0 and inv(n,'I08Y') > 0 then//dark+arcane
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Y'))
        set add = 'I0FX'
    elseif inv(n,'I0FU') > 0 and inv(n,'I08Z') > 0 then//dark+fire
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I08Z'))
        set add = 'I0FW'
    elseif inv(n,'I0FU') > 0 and inv(n,'I0EP') > 0 then//earth+dark
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0EP'))
        set add = 'I0G1'
    elseif inv(n,'I0FU') > 0 and inv(n,'I0FJ') > 0 then//dark+light
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FU'))
        call RemoveItem(GetItemOfTypeFromUnitBJ(n, 'I0FJ'))
        set add = 'I0G0'
    endif
    if add != 0 then
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetUnitX( n ), GetUnitY( n ) ) )
        call UnitAddItem(n, CreateItem( add, GetUnitX( n ), GetUnitY(n)) )
    endif
    
    set n = null
endfunction

//===========================================================================
function InitTrig_OrbUse takes nothing returns nothing
    set gg_trg_OrbUse = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbUse, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( gg_trg_OrbUse, Condition( function Trig_OrbUse_Conditions ) )
    call TriggerAddAction( gg_trg_OrbUse, function Trig_OrbUse_Actions )
endfunction

