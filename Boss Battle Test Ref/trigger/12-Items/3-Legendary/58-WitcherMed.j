function Trig_WitcherMed_Conditions takes nothing returns boolean
    return (inv( GetSpellAbilityUnit(), 'I093' ) > 0 or inv( GetSpellAbilityUnit(), 'I09C' ) > 0) and Uniques_Logic(GetSpellAbilityId())
endfunction

function Trig_WitcherMed_Actions takes nothing returns nothing
    local integer s
    local integer i = 0
    local integer cyclA
    local integer cyclAEnd
    
    if inv( GetSpellAbilityUnit(), 'I093' ) > 0  then
        set cyclA = 1
        set cyclAEnd = udg_Database_NumberItems[24]
        loop
            exitwhen cyclA > cyclAEnd
            if udg_DB_Hero_SpecAbAkt[cyclA] == GetSpellAbilityId() or udg_DB_Hero_SpecAbAktPlus[cyclA] == GetSpellAbilityId() then
                set i = cyclA
                set cyclA = cyclAEnd
            endif
            set cyclA = cyclA + 1
        endloop
        if i != 0 then
            set cyclA = 1
            loop
                exitwhen cyclA > 2
                set udg_RandomLogic = true
                set udg_Caster = GetSpellAbilityUnit()
                call TriggerExecute( udg_DB_Trigger_Spec[i] )
                set cyclA = cyclA + 1
            endloop
        endif
    elseif combat( GetSpellAbilityUnit(), false, 0 ) and not( udg_fightmod[3] ) then
        set i = GetPlayerId(GetOwningPlayer( GetSpellAbilityUnit() )) + 1
        set s = LoadInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( udg_QuestItemCode[10] ) ) + 1
        call SaveInteger( udg_hash, GetHandleId( GetSpellAbilityUnit() ), StringHash( udg_QuestItemCode[10] ), s )
        if s >= udg_QuestNum[10] then
            call SetWidgetLife( GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I09C'), 0. )
            set bj_lastCreatedItem = CreateItem( 'I093', GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()))
            call UnitAddItem(GetSpellAbilityUnit(), bj_lastCreatedItem)
            call textst( "|c00ffffff The beginning of the hunt done!", GetSpellAbilityUnit(), 64, GetRandomReal( 45, 135 ), 12, 1.5 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()) ) )
            set udg_QuestDone[GetPlayerId( GetOwningPlayer(GetSpellAbilityUnit()) ) + 1] = true
        else
            call QuestDiscription( GetSpellAbilityUnit(), 'I09C', s, udg_QuestNum[10] )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_WitcherMed takes nothing returns nothing
    set gg_trg_WitcherMed = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_WitcherMed, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_WitcherMed, Condition( function Trig_WitcherMed_Conditions ) )
    call TriggerAddAction( gg_trg_WitcherMed, function Trig_WitcherMed_Actions )
endfunction

