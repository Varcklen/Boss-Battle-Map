function Trig_World_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A13F'
endfunction

function Trig_World_Actions takes nothing returns nothing
    local integer cyclA 
    
    if not(udg_logic[80]) then
    	call IconFrame( "World", udg_DB_BonusFrame_Icon[2], udg_DB_BonusFrame_Name[2], udg_DB_BonusFrame_Tooltip[2] )
        
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if udg_hero[cyclA] != null then 
                call skillst( GetPlayerId(GetOwningPlayer(udg_hero[cyclA])) + 1, 1 )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    set udg_logic[80] = true
    call StartSound(gg_snd_QuestLog)
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetSpellAbilityUnit(), "origin") )
    call statst( GetSpellAbilityUnit(), 1, 1, 1, 0, true )

    call stazisst( GetSpellAbilityUnit(), GetItemOfTypeFromUnitBJ( GetSpellAbilityUnit(), 'I0B7') )
endfunction

//===========================================================================
function InitTrig_World takes nothing returns nothing
    set gg_trg_World = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_World, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_World, Condition( function Trig_World_Conditions ) )
    call TriggerAddAction( gg_trg_World, function Trig_World_Actions )
endfunction

