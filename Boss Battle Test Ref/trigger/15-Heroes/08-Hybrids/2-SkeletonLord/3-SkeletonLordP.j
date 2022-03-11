function Trig_SkeletonLordP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A0CK'
endfunction

function Trig_SkeletonLordP_Actions takes nothing returns nothing
    call SaveUnitHandle( udg_hash, 1, StringHash( "sklp" ), GetLearningUnit() ) 
endfunction

//===========================================================================
function InitTrig_SkeletonLordP takes nothing returns nothing
    set gg_trg_SkeletonLordP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SkeletonLordP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_SkeletonLordP, Condition( function Trig_SkeletonLordP_Conditions ) )
    call TriggerAddAction( gg_trg_SkeletonLordP, function Trig_SkeletonLordP_Actions )
endfunction