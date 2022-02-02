globals
    integer array DB_ModesFrame_Mode[4][3]//LR/UD
    integer array DB_ModesFrame_Rotation[4][3]//LR/UD
endglobals

function Trig_ModesFrameSet_Actions takes nothing returns nothing
    set udg_DB_ModesFrame_DifficultyNum = 6
    set udg_DB_ModesFrame_Difficulty[0] = 'A0EH'
    set udg_DB_ModesFrame_Difficulty[1] = 'A043'
    set udg_DB_ModesFrame_Difficulty[2] = 'A046'
    set udg_DB_ModesFrame_Difficulty[3] = 'A047'
    set udg_DB_ModesFrame_Difficulty[4] = 'A045'
    set udg_DB_ModesFrame_Difficulty[5] = 'A048'
    set udg_DB_ModesFrame_Difficulty[6] = 'A04H'

    set udg_DB_ModesFrame_AbilityNum = 5
    set udg_DB_ModesFrame_Ability[1] = 'A15C'
    set udg_DB_ModesFrame_Ability[2] = 'A0D2'
    set udg_DB_ModesFrame_Ability[3] = 'A0JO'
    set udg_DB_ModesFrame_Ability[4] = 'A09D'
    set udg_DB_ModesFrame_Ability[5] = 'A0F2'
    
    set udg_DB_ModesFrame_ModeLR = 4
    set udg_DB_ModesFrame_ModeUD = 2
    set DB_ModesFrame_Mode[1][1] = 'A03K'
    set DB_ModesFrame_Mode[2][1] = 'A0BK'
    set DB_ModesFrame_Mode[3][1] = 'A0WT'
    set DB_ModesFrame_Mode[4][1] = 'A1BM'
    set DB_ModesFrame_Mode[1][2] = 'A0HK'
    set DB_ModesFrame_Mode[2][2] = 'A0HL'
    set DB_ModesFrame_Mode[3][2] = 'A0HM'
    set DB_ModesFrame_Mode[4][2] = 'A1BX'
    
    set udg_DB_ModesFrame_RotationLR = 5
    set udg_DB_ModesFrame_RotationUD = 2
    set udg_DB_ModesFrame_RotationNum = udg_DB_ModesFrame_RotationLR*udg_DB_ModesFrame_RotationUD
    set DB_ModesFrame_Rotation[1][1] = 'A0F3'
    set DB_ModesFrame_Rotation[2][1] = 'A0OQ'
    set DB_ModesFrame_Rotation[3][1] = 'A0PZ'
    set DB_ModesFrame_Rotation[4][1] = 'A0YQ'
    set DB_ModesFrame_Rotation[5][1] = 'A0YR'
    set DB_ModesFrame_Rotation[1][2] = 'A0YS'
    set DB_ModesFrame_Rotation[2][2] = 'A0PY'
    set DB_ModesFrame_Rotation[3][2] = 'A10P'
    set DB_ModesFrame_Rotation[4][2] = 'A19C'
    set DB_ModesFrame_Rotation[5][2] = 'A1BJ'
    
    set udg_base = 0
    set udg_DB_Rotation[BaseNum()] = gg_trg_MerryCristmas
    set udg_DB_Rotation[BaseNum()] = gg_trg_MasterDisguise
    set udg_DB_Rotation[BaseNum()] = gg_trg_EldRichMoon
    set udg_DB_Rotation[BaseNum()] = gg_trg_AllRandom
    set udg_DB_Rotation[BaseNum()] = gg_trg_Purity_of_Power
    set udg_DB_Rotation[BaseNum()] = gg_trg_Freedom_of_Choice
    set udg_DB_Rotation[BaseNum()] = gg_trg_SheepIsGood
    set udg_DB_Rotation[BaseNum()] = gg_trg_CorruptedWorld
    set udg_DB_Rotation[BaseNum()] = gg_trg_Orbomination
    set udg_DB_Rotation[BaseNum()] = gg_trg_Im_Legend
endfunction

//===========================================================================
function InitTrig_ModesFrameSet takes nothing returns nothing
    set gg_trg_ModesFrameSet = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_ModesFrameSet, udg_StartTimer )
    call TriggerAddAction( gg_trg_ModesFrameSet, function Trig_ModesFrameSet_Actions )
endfunction

