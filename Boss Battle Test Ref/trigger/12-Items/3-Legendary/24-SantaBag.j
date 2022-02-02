function Trig_SantaBag_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0KQ'
endfunction

function Trig_SantaBag_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclB
    local integer j
    local integer i = CorrectPlayer(GetSpellAbilityUnit())-1

    if i < 0 then
        call BJDebugMsg("|cffffffffERROR|r: Santa's Bag does not work correctly. Contact the developer to fix the problem.")
        return
    endif
    loop
        exitwhen cyclA > 5
        if GetSpellTargetItem() == UnitItemInSlot( GetSpellAbilityUnit(), cyclA ) and GetItemTypeId(GetSpellTargetItem()) != 'I0D6' and GetItemType(GetSpellTargetItem()) != ITEM_TYPE_POWERUP then
            call AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", GetSpellAbilityUnit(), "origin")
            set cyclA = 5
            set cyclB = 1
            loop
            exitwhen cyclB > 3
            set j = (i*3) + cyclB 
            if udg_SantaItem[j] == null then
                set udg_SantaItem[j] = GetSpellTargetItem()
                call UnitRemoveItemSwapped( udg_SantaItem[j], GetSpellAbilityUnit() )
                call SetItemPosition( udg_SantaItem[j], GetLocationX(udg_SantaPoint[j]), GetLocationY(udg_SantaPoint[j]) )
                set cyclB = 3
            endif
            set cyclB = cyclB + 1
            endloop
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_SantaBag takes nothing returns nothing
    set gg_trg_SantaBag = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SantaBag, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SantaBag, Condition( function Trig_SantaBag_Conditions ) )
    call TriggerAddAction( gg_trg_SantaBag, function Trig_SantaBag_Actions )
endfunction

