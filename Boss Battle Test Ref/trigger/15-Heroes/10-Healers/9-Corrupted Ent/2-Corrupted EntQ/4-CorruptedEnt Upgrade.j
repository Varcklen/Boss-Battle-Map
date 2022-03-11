function Trig_CorruptedEnt_Upgrade_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0OE'
endfunction

function Trig_CorruptedEnt_Upgrade_Actions takes nothing returns nothing
    if GetUnitAbilityLevel( GetLearningUnit(), 'A0OE') == 1 then
        call SaveInteger( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "entqch" ), CorruptedEntQ_CHARGE_LIMIT )
	endif
    if GetLocalPlayer() == GetOwningPlayer( GetLearningUnit() ) then
        call BlzFrameSetVisible( entQBackdrop, true )
        call BlzFrameSetText( entQText, I2S(LoadInteger( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "entqch" ) )) )
    endif
endfunction

//===========================================================================
function InitTrig_CorruptedEnt_Upgrade takes nothing returns nothing
    set gg_trg_CorruptedEnt_Upgrade = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_CorruptedEnt_Upgrade, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_CorruptedEnt_Upgrade, Condition( function Trig_CorruptedEnt_Upgrade_Conditions ) )
    call TriggerAddAction( gg_trg_CorruptedEnt_Upgrade, function Trig_CorruptedEnt_Upgrade_Actions )
endfunction

scope CorruptedEntUpgrade initializer Triggs
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_Event_NullingAbility_Unit, 'A0OE') > 0
    endfunction

    private function Use takes nothing returns nothing
        if GetLocalPlayer() == GetOwningPlayer( udg_Event_NullingAbility_Unit ) then
            call BlzFrameSetVisible( entQBackdrop, false )
        endif
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_Event_NullingAbility_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function Conditions ) )
        call TriggerAddAction( trig, function Use)
        
        set trig = null
    endfunction
endscope

