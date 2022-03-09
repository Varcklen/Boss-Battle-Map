function Trig_MephistarE_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0ZK'
endfunction

function Trig_MephistarE_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(GetLearningUnit())) + 1
    local integer cyclA
    
    set udg_Mephistar = GetLearningUnit()
    
    if GetLocalPlayer() == GetOwningPlayer( GetLearningUnit() ) then
        call BlzFrameSetVisible( mephuse, true )
    endif
    
    set cyclA = 1
    loop
        exitwhen cyclA > 9
        if udg_MephistarUse[cyclA] > 0 then
            call BlzFrameSetTexture( mephicon[cyclA], BlzGetAbilityIcon( udg_DB_SoulContract_Set[cyclA]), 0, true )
        else
            call BlzFrameSetTexture( mephicon[cyclA], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true )
        endif
        set cyclA = cyclA + 1
    endloop
endfunction

//===========================================================================
function InitTrig_MephistarE takes nothing returns nothing
    set gg_trg_MephistarE = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MephistarE, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_MephistarE, Condition( function Trig_MephistarE_Conditions ) )
    call TriggerAddAction( gg_trg_MephistarE, function Trig_MephistarE_Actions )
endfunction

