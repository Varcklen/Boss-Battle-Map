library LibDataAbilities requires LibDataItems

// Cброс данных о героях
function resethero takes nothing returns nothing
    local integer cyclA = 1

    set udg_Database_InfoNumberHeroes = 76
    set udg_Database_Hero[1] = 'O00C'
    set udg_Database_Hero[2] = 'O00E'
    set udg_Database_Hero[3] = 'O00B'
    set udg_Database_Hero[4] = 'O00I'
    set udg_Database_Hero[5] = 'U00T'
    set udg_Database_Hero[6] = 'N01M'
    set udg_Database_Hero[7] = 'N000'
    set udg_Database_Hero[8] = 'N028'
    set udg_Database_Hero[9] = 'O00D'
    set udg_Database_Hero[10] = 'N002'
    set udg_Database_Hero[11] = 'N00N'
    set udg_Database_Hero[12] = 'N01P'
    set udg_Database_Hero[13] = 'N001'
    set udg_Database_Hero[14] = 'N01Q'
    set udg_Database_Hero[15] = 'N02Q'
    set udg_Database_Hero[16] = 'N02P'
    set udg_Database_Hero[17] = 'N004'
    set udg_Database_Hero[18] = 'N02E'
    set udg_Database_Hero[19] = 'N00Y'
    set udg_Database_Hero[20] = 'O00J'
    set udg_Database_Hero[21] = 'O00K'
    set udg_Database_Hero[22] = 'N02R'
    set udg_Database_Hero[23] = 'N02S'
    set udg_Database_Hero[24] = 'O00L'
    set udg_Database_Hero[25] = 'H01A'
    set udg_Database_Hero[26] = 'N032'
    set udg_Database_Hero[27] = 'O00Q'
    set udg_Database_Hero[28] = 'N038'
    set udg_Database_Hero[29] = 'O00S'
    set udg_Database_Hero[30] = 'N039'
    set udg_Database_Hero[31] = 'O00T'
    set udg_Database_Hero[32] = 'N019'
    set udg_Database_Hero[33] = 'O00X'
    set udg_Database_Hero[34] = 'O010'
    set udg_Database_Hero[35] = 'N01R'
    set udg_Database_Hero[36] = 'O01A'
    set udg_Database_Hero[37] = 'N00X'
    set udg_Database_Hero[38] = 'O00Z'
    set udg_Database_Hero[39] = 'N046'
    set udg_Database_Hero[40] = 'O014'
    set udg_Database_Hero[41] = 'H01U'
    set udg_Database_Hero[42] = 'N049'
    set udg_Database_Hero[43] = 'N04A'
    set udg_Database_Hero[44] = 'O015'
    set udg_Database_Hero[45] = 'O016'
    set udg_Database_Hero[46] = 'O017'
    set udg_Database_Hero[47] = 'N04B'
    set udg_Database_Hero[48] = 'N04C'
    set udg_Database_Hero[49] = 'N04E'
    set udg_Database_Hero[50] = 'O018'
    set udg_Database_Hero[51] = 'O019'
    set udg_Database_Hero[52] = 'N04H'
    set udg_Database_Hero[53] = 'N04I'
    set udg_Database_Hero[54] = 'N04J'
    set udg_Database_Hero[55] = 'N04K'
    set udg_Database_Hero[56] = 'O00N'
    set udg_Database_Hero[57] = 'N04M'
    set udg_Database_Hero[58] = 'N04W'
    set udg_Database_Hero[59] = 'O01I'
    set udg_Database_Hero[60] = 'O01J'
    set udg_Database_Hero[61] = 'O01L'
    set udg_Database_Hero[62] = 'N054'
    set udg_Database_Hero[63] = 'N055'
    set udg_Database_Hero[64] = 'N057'
    set udg_Database_Hero[65] = 'N05A'
    set udg_Database_Hero[66] = 'N02G'
    set udg_Database_Hero[67] = 'N02H'
    set udg_Database_Hero[68] = 'N02K'
    set udg_Database_Hero[69] = 'N02O'
    set udg_Database_Hero[70] = 'O01N'
    set udg_Database_Hero[71] = 'O01O'
    set udg_Database_Hero[72] = 'N02T'
    set udg_Database_Hero[73] = 'N014'
    set udg_Database_Hero[74] = 'N017'
    set udg_Database_Hero[75] = 'N03P'
    set udg_Database_Hero[76] = 'O01Y'
endfunction

function DataAbilities takes nothing returns nothing
    //Special способность
    set udg_base = 0
    set udg_DB_Ability_Special[BaseNum()] = 'A19N'
    set udg_DB_Ability_Special[BaseNum()] = 'A19P'
    set udg_DB_Ability_Special[BaseNum()] = 'A19Q'
    set udg_DB_Ability_Special[BaseNum()] = 'A19R'
    set udg_DB_Ability_Special[BaseNum()] = 'A19S'
    set udg_DB_Ability_Special[BaseNum()] = 'A19U'
    set udg_DB_Ability_Special[BaseNum()] = 'A1AD'
    set udg_DB_Ability_Special[BaseNum()] = 'A1AE'
    set udg_DB_Ability_Special[BaseNum()] = 'A1AF'
    set udg_DB_Ability_Special[BaseNum()] = 'A1B2'
    set udg_DB_Ability_Special[BaseNum()] = 'A1B3'
    set udg_DB_Ability_Special[BaseNum()] = 'A1B4'
    set udg_DB_Ability_Special[BaseNum()] = 'A1BK'
    set udg_DB_Ability_Special[BaseNum()] = 'A1BL'
    set udg_DB_Ability_Special[BaseNum()] = 'A1BV'
    set udg_DB_Ability_Special[BaseNum()] = 'A1BY'
    set udg_DB_Ability_Special[BaseNum()] = 'A13S'
    set udg_DB_Ability_Special[BaseNum()] = 'A06Y'
    set udg_DB_Ability_Special[BaseNum()] = 'A07H'
    set udg_DB_Ability_Special[BaseNum()] = 'A0BM'
    set udg_DB_Ability_Special[BaseNum()] = 'A0EG'
    set udg_DB_Ability_Special[BaseNum()] = 'A0G7'
    set udg_DB_Ability_Special[BaseNum()] = 'A0GR'
    set udg_DB_Ability_Special[BaseNum()] = 'A0GT'
    set udg_DB_Ability_Special[BaseNum()] = 'A12G'
    set udg_DB_Ability_Special[BaseNum()] = 'A12Y'
    set udg_DB_Ability_Special[BaseNum()] = 'AZ00'
    set udg_DB_Ability_Special[BaseNum()] = 'AZ01'
    set udg_DB_Ability_Special[BaseNum()] = 'AZ03'
    set udg_DB_Ability_Special[BaseNum()] = 'AZ04'
    set udg_Database_NumberItems[37] = udg_base
    
    // Умение
    set udg_Database_NumberItems[13] = 24
    set udg_DB_Hero_SpecAb[1] = 'A0GD'
    set udg_DB_Hero_SpecAb[2] = 'A088'
    set udg_DB_Hero_SpecAb[3] = 'A05L'
    set udg_DB_Hero_SpecAb[4] = 'A0MW'
    set udg_DB_Hero_SpecAb[5] = 'A0GA'
    set udg_DB_Hero_SpecAb[6] = 'A0GB'
    set udg_DB_Hero_SpecAb[7] = 'A0GC'
    set udg_DB_Hero_SpecAb[8] = 'A0AG'
    set udg_DB_Hero_SpecAb[9] = 'A0GF'
    set udg_DB_Hero_SpecAb[10] = 'A00N'
    set udg_DB_Hero_SpecAb[11] = 'A0IJ'
    set udg_DB_Hero_SpecAb[12] = 'A0IL'
    set udg_DB_Hero_SpecAb[13] = 'A0IK'
    set udg_DB_Hero_SpecAb[14] = 'A0IP'
    set udg_DB_Hero_SpecAb[15] = 'A0IS'
    set udg_DB_Hero_SpecAb[16] = 'A13I'
    set udg_DB_Hero_SpecAb[17] = 'A15W'
    set udg_DB_Hero_SpecAb[18] = 'A0JJ'
    set udg_DB_Hero_SpecAb[19] = 'A0MG'
    set udg_DB_Hero_SpecAb[20] = 'A13G'
    set udg_DB_Hero_SpecAb[21] = 'A0FS'
    set udg_DB_Hero_SpecAb[22] = 'A0XI'
    set udg_DB_Hero_SpecAb[23] = 'A0CR'
    set udg_DB_Hero_SpecAb[24] = 'A1BD'
    set udg_DB_Hero_SpecAbPlus[1] = 'A05Z'
    set udg_DB_Hero_SpecAbPlus[2] = 'A036'
    set udg_DB_Hero_SpecAbPlus[3] = 'A037'
    set udg_DB_Hero_SpecAbPlus[4] = 'A084'
    set udg_DB_Hero_SpecAbPlus[5] = 'A00K'
    set udg_DB_Hero_SpecAbPlus[6] = 'A03B'
    set udg_DB_Hero_SpecAbPlus[7] = 'A02V'
    set udg_DB_Hero_SpecAbPlus[8] = 'A02W'
    set udg_DB_Hero_SpecAbPlus[9] = 'A035'
    set udg_DB_Hero_SpecAbPlus[10] = 'A01U' 
    set udg_DB_Hero_SpecAbPlus[11] = 'A0IN'
    set udg_DB_Hero_SpecAbPlus[12] = 'A0IO'
    set udg_DB_Hero_SpecAbPlus[13] = 'A0IM'
    set udg_DB_Hero_SpecAbPlus[14] = 'A0IQ'
    set udg_DB_Hero_SpecAbPlus[15] = 'A0IV'
    set udg_DB_Hero_SpecAbPlus[16] = 'A13J'
    set udg_DB_Hero_SpecAbPlus[17] = 'A15X'
    set udg_DB_Hero_SpecAbPlus[18] = 'A0JK'
    set udg_DB_Hero_SpecAbPlus[19] = 'A0MH'
    set udg_DB_Hero_SpecAbPlus[20] = 'A14S'
    set udg_DB_Hero_SpecAbPlus[21] = 'A0J5'
    set udg_DB_Hero_SpecAbPlus[22] = 'A0XK'
    set udg_DB_Hero_SpecAbPlus[23] = 'A1AK'
    set udg_DB_Hero_SpecAbPlus[24] = 'A1BE'
    // Активные умения
    set udg_Database_NumberItems[24] = 14
    set udg_DB_Hero_SpecAbAkt[1] = 'A0AG'
    set udg_DB_Hero_SpecAbAktPlus[1] = 'A02W'
    set udg_DB_Hero_SpecAbAkt[2] = 'A088'
    set udg_DB_Hero_SpecAbAktPlus[2] = 'A036'
    set udg_DB_Hero_SpecAbAkt[3] = 'A0GC'
    set udg_DB_Hero_SpecAbAktPlus[3] = 'A02V'
    set udg_DB_Hero_SpecAbAkt[4] = 'A00N'
    set udg_DB_Hero_SpecAbAktPlus[4] = 'A01U'
    set udg_DB_Hero_SpecAbAkt[5] = 'A0GD'
    set udg_DB_Hero_SpecAbAktPlus[5] = 'A05Z'
    set udg_DB_Hero_SpecAbAkt[6] = 'A0GF'
    set udg_DB_Hero_SpecAbAktPlus[6] = 'A035'
    set udg_DB_Hero_SpecAbAkt[7] = 'A0IS'
    set udg_DB_Hero_SpecAbAktPlus[7] = 'A0IV'
    set udg_DB_Hero_SpecAbAkt[8] = 'A0MW'
    set udg_DB_Hero_SpecAbAktPlus[8] = 'A084'
    set udg_DB_Hero_SpecAbAkt[9] = 'A0IP'
    set udg_DB_Hero_SpecAbAktPlus[9] = 'A0IQ'
    set udg_DB_Hero_SpecAbAkt[10] = 'A13I'
    set udg_DB_Hero_SpecAbAktPlus[10] = 'A13J'
    set udg_DB_Hero_SpecAbAkt[11] = 'A0MG'
    set udg_DB_Hero_SpecAbAktPlus[11] = 'A0MH'
    set udg_DB_Hero_SpecAbAkt[12] = 'A13G'
    set udg_DB_Hero_SpecAbAktPlus[12] = 'A14S'
    set udg_DB_Hero_SpecAbAkt[13] = 'A0CR'
    set udg_DB_Hero_SpecAbAktPlus[13] = 'A1AK'
    set udg_DB_Hero_SpecAbAkt[14] = 'A1BD'
    set udg_DB_Hero_SpecAbAktPlus[14] = 'A1BE'
    
    set udg_DB_Trigger_Spec[1] = gg_trg_SmallHeal
    set udg_DB_Trigger_Spec[2] = gg_trg_Provoke
    set udg_DB_Trigger_Spec[3] = gg_trg_Manaball
    set udg_DB_Trigger_Spec[4] = gg_trg_KillEye
    set udg_DB_Trigger_Spec[5] = gg_trg_Buff
    set udg_DB_Trigger_Spec[6] = gg_trg_Debuff
    set udg_DB_Trigger_Spec[7] = gg_trg_Chaos
    set udg_DB_Trigger_Spec[8] = gg_trg_PetD
    set udg_DB_Trigger_Spec[9] = gg_trg_SkLordSpec
    set udg_DB_Trigger_Spec[10] = gg_trg_Mixology
    set udg_DB_Trigger_Spec[11] = gg_trg_SummonSheep
    set udg_DB_Trigger_Spec[12] = gg_trg_Orbs
    set udg_DB_Trigger_Spec[13] = gg_trg_Play_Note
    set udg_DB_Trigger_Spec[14] = gg_trg_Brother_Rant
    
    // Триггеры способности №1
    set udg_Database_NumberItems[14] = 76
    set udg_DB_Trigger_One[1] = gg_trg_DragonQ
    set udg_DB_Trigger_One[2] = gg_trg_MonkQ 
    set udg_DB_Trigger_One[3] = gg_trg_PirateQ 
    set udg_DB_Trigger_One[4] = gg_trg_BuggerQ 
    set udg_DB_Trigger_One[5] = gg_trg_SkeletonLordQ 
    set udg_DB_Trigger_One[6] = gg_trg_AngelQ
    set udg_DB_Trigger_One[7] = gg_trg_BeornQ 
    set udg_DB_Trigger_One[8] = gg_trg_VampQ 
    set udg_DB_Trigger_One[9] = gg_trg_KnightQ  
    set udg_DB_Trigger_One[10] = gg_trg_DruidQ 
    set udg_DB_Trigger_One[11] = gg_trg_GhostQ 
    set udg_DB_Trigger_One[12] = gg_trg_NerubQ
    set udg_DB_Trigger_One[13] = gg_trg_OwlQ 
    set udg_DB_Trigger_One[14] = gg_trg_MinQ
    set udg_DB_Trigger_One[15] = gg_trg_MentorQ 
    set udg_DB_Trigger_One[16] = gg_trg_PyrolordQ
    set udg_DB_Trigger_One[17] = gg_trg_SirenaQ
    set udg_DB_Trigger_One[18] = gg_trg_SniperQ
    set udg_DB_Trigger_One[19] = gg_trg_HronoQ 
    set udg_DB_Trigger_One[20] = gg_trg_MiracleBrewQ
    set udg_DB_Trigger_One[21] = gg_trg_CircusQ
    set udg_DB_Trigger_One[22] = gg_trg_BarbarianQ
    set udg_DB_Trigger_One[23] = gg_trg_MorlocQ
    set udg_DB_Trigger_One[24] = gg_trg_MagnataurQ
    set udg_DB_Trigger_One[25] = gg_trg_BlackKnightQ
    set udg_DB_Trigger_One[26] = gg_trg_ShadowArcherQ
    set udg_DB_Trigger_One[27] = gg_trg_AdmiralQ
    set udg_DB_Trigger_One[28] = gg_trg_HarpyQ
    set udg_DB_Trigger_One[29] = gg_trg_ComandQ
    set udg_DB_Trigger_One[30] = gg_trg_EnergyballQ
    set udg_DB_Trigger_One[31] = gg_trg_ChaosLordQ
    set udg_DB_Trigger_One[32] = gg_trg_SamuraiQ
    set udg_DB_Trigger_One[33] = gg_trg_DevourerQ
    set udg_DB_Trigger_One[34] = gg_trg_AdventurerQ
    set udg_DB_Trigger_One[35] = gg_trg_DoctorQ
    set udg_DB_Trigger_One[36] = gg_trg_DealerQ 
    set udg_DB_Trigger_One[37] = gg_trg_OgreQ
    set udg_DB_Trigger_One[38] = gg_trg_DryadQ
    set udg_DB_Trigger_One[39] = gg_trg_Metal_MageQ
    set udg_DB_Trigger_One[40] = gg_trg_KingQ
    set udg_DB_Trigger_One[41] = gg_trg_SludgeQ
    set udg_DB_Trigger_One[42] = gg_trg_IncarnationQ
    set udg_DB_Trigger_One[43] = gg_trg_ShamanQ
    set udg_DB_Trigger_One[44] = gg_trg_GamblerQ
    set udg_DB_Trigger_One[45] = gg_trg_WandererQ
    set udg_DB_Trigger_One[46] = gg_trg_TrollMageQ
    set udg_DB_Trigger_One[47] = gg_trg_DogQ
    set udg_DB_Trigger_One[48] = gg_trg_PredatorQ
    set udg_DB_Trigger_One[49] = gg_trg_MaidenW
    set udg_DB_Trigger_One[50] = gg_trg_WicerdQ
    set udg_DB_Trigger_One[51] = gg_trg_Money_BagW
    set udg_DB_Trigger_One[52] = gg_trg_NomadQ
    set udg_DB_Trigger_One[53] = gg_trg_OutcastQ 
    set udg_DB_Trigger_One[54] = gg_trg_MimicQ 
    set udg_DB_Trigger_One[55] = gg_trg_SoulstealerQ 
    set udg_DB_Trigger_One[56] = gg_trg_ElementalQ
    set udg_DB_Trigger_One[57] = gg_trg_NinjaQ
    set udg_DB_Trigger_One[58] = gg_trg_AltarQ
    set udg_DB_Trigger_One[59] = gg_trg_WagonQ
    set udg_DB_Trigger_One[60] = gg_trg_FallenOneQ
    set udg_DB_Trigger_One[61] = gg_trg_MephistarQ
    set udg_DB_Trigger_One[62] = gg_trg_SunKingQ
    set udg_DB_Trigger_One[63] = gg_trg_ArmsQ
    set udg_DB_Trigger_One[64] = gg_trg_JesterQ
    set udg_DB_Trigger_One[65] = gg_trg_KeeperQ
    set udg_DB_Trigger_One[66] = gg_trg_PriestessQ
    set udg_DB_Trigger_One[67] = gg_trg_WandererQ
    set udg_DB_Trigger_One[68] = gg_trg_GunMasterQ
    set udg_DB_Trigger_One[69] = gg_trg_InfernalQ
    set udg_DB_Trigger_One[70] = gg_trg_BardQ
    set udg_DB_Trigger_One[71] = gg_trg_RealBroQ
    set udg_DB_Trigger_One[72] = gg_trg_PeacelockQ
    set udg_DB_Trigger_One[73] = gg_trg_MarshalQ
    set udg_DB_Trigger_One[74] = gg_trg_Corrupted_EntQ
    set udg_DB_Trigger_One[75] = gg_trg_LycanthropeQ
    set udg_DB_Trigger_One[76] = gg_trg_The_PlagueQ
    
    // Триггеры способности №2
    set udg_Database_NumberItems[15] = 67
    set udg_DB_Trigger_Two[1] = gg_trg_BeornW
    set udg_DB_Trigger_Two[2] = gg_trg_HarpyW
    set udg_DB_Trigger_Two[3] = gg_trg_DruidW
    set udg_DB_Trigger_Two[4] = gg_trg_SirenaW
    set udg_DB_Trigger_Two[5] = gg_trg_KnightW
    set udg_DB_Trigger_Two[6] = gg_trg_PirateW
    set udg_DB_Trigger_Two[7] = gg_trg_DragonW
    set udg_DB_Trigger_Two[8] = gg_trg_GhostW
    set udg_DB_Trigger_Two[9] = gg_trg_MonkW
    set udg_DB_Trigger_Two[10] = gg_trg_HronoW
    set udg_DB_Trigger_Two[11] = gg_trg_AngelW
    set udg_DB_Trigger_Two[12] = gg_trg_SkeletonLordW
    set udg_DB_Trigger_Two[13] = gg_trg_NerubW
    set udg_DB_Trigger_Two[14] = gg_trg_MinW
    set udg_DB_Trigger_Two[15] = gg_trg_VampW
    set udg_DB_Trigger_Two[16] = gg_trg_SniperW
    set udg_DB_Trigger_Two[17] = gg_trg_BuggerW
    set udg_DB_Trigger_Two[18] = gg_trg_PyrolordW
    set udg_DB_Trigger_Two[19] = gg_trg_MentorW
    set udg_DB_Trigger_Two[20] = gg_trg_MiracleBrewW
    set udg_DB_Trigger_Two[21] = gg_trg_CircusW
    set udg_DB_Trigger_Two[22] = gg_trg_ComandW
    set udg_DB_Trigger_Two[23] = gg_trg_MorlocW
    set udg_DB_Trigger_Two[24] = gg_trg_MagnataurW
    set udg_DB_Trigger_Two[25] = gg_trg_BlackKnightW
    set udg_DB_Trigger_Two[26] = gg_trg_ShadowArcherW
    set udg_DB_Trigger_Two[27] = gg_trg_EnergyballW
    set udg_DB_Trigger_Two[28] = gg_trg_RealBroW
    set udg_DB_Trigger_Two[29] = gg_trg_SamuraiW
    set udg_DB_Trigger_Two[30] = gg_trg_DevourerW
    set udg_DB_Trigger_Two[31] = gg_trg_AdventurerW
    set udg_DB_Trigger_Two[32] = gg_trg_NinjaW
    set udg_DB_Trigger_Two[33] = gg_trg_AdmiralW
    set udg_DB_Trigger_Two[34] = gg_trg_OwlW
    set udg_DB_Trigger_Two[35] = gg_trg_DoctorW
    set udg_DB_Trigger_Two[36] = gg_trg_OutcastW
    set udg_DB_Trigger_Two[37] = gg_trg_OgreW
    set udg_DB_Trigger_Two[38] = gg_trg_DryadW
    set udg_DB_Trigger_Two[39] = gg_trg_Metal_MageW
    set udg_DB_Trigger_Two[40] = gg_trg_KingW
    set udg_DB_Trigger_Two[41] = gg_trg_SludgeW
    set udg_DB_Trigger_Two[42] = gg_trg_IncarnationW
    set udg_DB_Trigger_Two[43] = gg_trg_ShamanW
    set udg_DB_Trigger_Two[44] = gg_trg_GamblerW
    set udg_DB_Trigger_Two[45] = gg_trg_WandererW
    set udg_DB_Trigger_Two[46] = gg_trg_Troll_MageW
    set udg_DB_Trigger_Two[47] = gg_trg_DogW
    set udg_DB_Trigger_Two[48] = gg_trg_PredatorW
    set udg_DB_Trigger_Two[49] = gg_trg_ElementalW
    set udg_DB_Trigger_Two[50] = gg_trg_WicerdW
    set udg_DB_Trigger_Two[51] = gg_trg_Money_BagW
    set udg_DB_Trigger_Two[52] = gg_trg_DealerW
    set udg_DB_Trigger_Two[53] = gg_trg_MimicW
    set udg_DB_Trigger_Two[54] = gg_trg_SoulstealerW
    set udg_DB_Trigger_Two[55] = gg_trg_WagonW
    set udg_DB_Trigger_Two[56] = gg_trg_FallenOneW
    set udg_DB_Trigger_Two[57] = gg_trg_MephistarW
    set udg_DB_Trigger_Two[58] = gg_trg_SunKingWxxx
    set udg_DB_Trigger_Two[59] = gg_trg_ArmsW
    set udg_DB_Trigger_Two[60] = gg_trg_JesterW
    set udg_DB_Trigger_Two[61] = gg_trg_KeeperW
    set udg_DB_Trigger_Two[62] = gg_trg_PriestessW
    set udg_DB_Trigger_Two[63] = gg_trg_BardW
    set udg_DB_Trigger_Two[64] = gg_trg_PeacelockW
    set udg_DB_Trigger_Two[65] = gg_trg_MarshalQ
    set udg_DB_Trigger_Two[66] = gg_trg_Corrupted_EntW
    set udg_DB_Trigger_Two[67] = gg_trg_The_PlagueW
    
    // Триггеры способности №3
    set udg_Database_NumberItems[16] = 73
    set udg_DB_Trigger_Three[1] = gg_trg_BeornR
    set udg_DB_Trigger_Three[2] = gg_trg_OwlR
    set udg_DB_Trigger_Three[3] = gg_trg_DruidR
    set udg_DB_Trigger_Three[4] = gg_trg_SirenaR
    set udg_DB_Trigger_Three[5] = gg_trg_AdventurerR
    set udg_DB_Trigger_Three[6] = gg_trg_PirateR
    set udg_DB_Trigger_Three[7] = gg_trg_DragonR
    set udg_DB_Trigger_Three[8] = gg_trg_GhostR
    set udg_DB_Trigger_Three[9] = gg_trg_MonkR
    set udg_DB_Trigger_Three[10] = gg_trg_HronoR
    set udg_DB_Trigger_Three[11] = gg_trg_AngelR
    set udg_DB_Trigger_Three[12] = gg_trg_SkeletonLordR
    set udg_DB_Trigger_Three[13] = gg_trg_NerubR
    set udg_DB_Trigger_Three[14] = gg_trg_MinR
    set udg_DB_Trigger_Three[15] = gg_trg_VampR
    set udg_DB_Trigger_Three[16] = gg_trg_SniperR
    set udg_DB_Trigger_Three[17] = gg_trg_BuggerR
    set udg_DB_Trigger_Three[18] = gg_trg_PyrolordR
    set udg_DB_Trigger_Three[19] = gg_trg_MentorR
    set udg_DB_Trigger_Three[20] = gg_trg_MiracleBrewR
    set udg_DB_Trigger_Three[21] = gg_trg_CircusR
    set udg_DB_Trigger_Three[22] = gg_trg_PirateP
    set udg_DB_Trigger_Three[23] = gg_trg_MorlocR
    set udg_DB_Trigger_Three[24] = gg_trg_MagnataurR
    set udg_DB_Trigger_Three[25] = gg_trg_BlackKnightR
    set udg_DB_Trigger_Three[26] = gg_trg_ShadowArcherR
    set udg_DB_Trigger_Three[27] = gg_trg_Metal_MageR
    set udg_DB_Trigger_Three[28] = gg_trg_ComandR
    set udg_DB_Trigger_Three[29] = gg_trg_EnergyballR
    set udg_DB_Trigger_Three[30] = gg_trg_RealBroR
    set udg_DB_Trigger_Three[31] = gg_trg_DevourerR
    set udg_DB_Trigger_Three[32] = gg_trg_BarbarianR
    set udg_DB_Trigger_Three[33] = gg_trg_SirenaP
    set udg_DB_Trigger_Three[34] = gg_trg_DoctorR
    set udg_DB_Trigger_Three[35] = gg_trg_OutcastR
    set udg_DB_Trigger_Three[36] = gg_trg_DealerR
    set udg_DB_Trigger_Three[37] = gg_trg_OgreR
    set udg_DB_Trigger_Three[38] = gg_trg_DryadR
    set udg_DB_Trigger_Three[39] = gg_trg_KingE
    set udg_DB_Trigger_Three[40] = gg_trg_KingR
    set udg_DB_Trigger_Three[41] = gg_trg_IncarnationR
    set udg_DB_Trigger_Three[42] = gg_trg_ShamanE
    set udg_DB_Trigger_Three[43] = gg_trg_ShamanR
    set udg_DB_Trigger_Three[44] = gg_trg_GamblerE
    set udg_DB_Trigger_Three[45] = gg_trg_GamblerR
    set udg_DB_Trigger_Three[46] = gg_trg_ShoggothR
    set udg_DB_Trigger_Three[47] = gg_trg_Troll_MageE
    set udg_DB_Trigger_Three[48] = gg_trg_TrollMageR
    set udg_DB_Trigger_Three[49] = gg_trg_DogR
    set udg_DB_Trigger_Three[50] = gg_trg_PredatorR
    set udg_DB_Trigger_Three[51] = gg_trg_MaidenR
    set udg_DB_Trigger_Three[52] = gg_trg_WicerdR
    set udg_DB_Trigger_Three[53] = gg_trg_WandererR
    set udg_DB_Trigger_Three[54] = gg_trg_NinjaR
    set udg_DB_Trigger_Three[55] = gg_trg_SoulstealerR
    set udg_DB_Trigger_Three[56] = gg_trg_ElementalR
    set udg_DB_Trigger_Three[57] = gg_trg_AltarE
    set udg_DB_Trigger_Three[58] = gg_trg_AltarR
    set udg_DB_Trigger_Three[59] = gg_trg_WagonR
    set udg_DB_Trigger_Three[60] = gg_trg_FallenOneE
    set udg_DB_Trigger_Three[61] = gg_trg_FallenOneR
    set udg_DB_Trigger_Three[62] = gg_trg_RealBroE
    set udg_DB_Trigger_Three[63] = gg_trg_SunKingR
    set udg_DB_Trigger_Three[64] = gg_trg_JesterR
    set udg_DB_Trigger_Three[65] = gg_trg_KeeperR
    set udg_DB_Trigger_Three[66] = gg_trg_PriestessR
    set udg_DB_Trigger_Three[67] = gg_trg_GunMasterR
    set udg_DB_Trigger_Three[68] = gg_trg_InfernalR
    set udg_DB_Trigger_Three[69] = gg_trg_MorlocE
    set udg_DB_Trigger_Three[70] = gg_trg_BardR
    set udg_DB_Trigger_Three[71] = gg_trg_CorruptedEntR
    set udg_DB_Trigger_Three[72] = gg_trg_LycanthropeR
    set udg_DB_Trigger_Three[73] = gg_trg_The_PlagueR
    
    // First spell
    set udg_DB_Hero_FirstSpell[1] = 'A0OC'
    set udg_DB_Hero_FirstSpell[2] = 'A0U3'
    set udg_DB_Hero_FirstSpell[3] = 'A07A'
    set udg_DB_Hero_FirstSpell[4] = 'A105'
    set udg_DB_Hero_FirstSpell[5] = 'A0CL'
    set udg_DB_Hero_FirstSpell[6] = 'A0BU'
    set udg_DB_Hero_FirstSpell[7] = 'A00C'
    set udg_DB_Hero_FirstSpell[8] = 'A065'
    set udg_DB_Hero_FirstSpell[9] = 'A0MD'
    set udg_DB_Hero_FirstSpell[10] = 'A0M3'
    set udg_DB_Hero_FirstSpell[11] = 'A05N'
    set udg_DB_Hero_FirstSpell[12] = 'A07I'
    set udg_DB_Hero_FirstSpell[13] = 'A011'
    set udg_DB_Hero_FirstSpell[14] = 'A0DU'
    set udg_DB_Hero_FirstSpell[15] = 'A07W'
    set udg_DB_Hero_FirstSpell[16] = 'A0NH'
    set udg_DB_Hero_FirstSpell[17] = 'A08R'
    set udg_DB_Hero_FirstSpell[18] = 'A07K'
    set udg_DB_Hero_FirstSpell[19] = 'A09L'
    set udg_DB_Hero_FirstSpell[20] = 'A0R1'
    set udg_DB_Hero_FirstSpell[21] = 'A0SH'
    set udg_DB_Hero_FirstSpell[22] = 'A010'
    set udg_DB_Hero_FirstSpell[23] = 'A0TH'
    set udg_DB_Hero_FirstSpell[24] = 'A0UF'
    set udg_DB_Hero_FirstSpell[25] = 'A0Z2'
    set udg_DB_Hero_FirstSpell[26] = 'A0H4'
    set udg_DB_Hero_FirstSpell[27] = 'A0RV'
    set udg_DB_Hero_FirstSpell[28] = 'A0LX'
    set udg_DB_Hero_FirstSpell[29] = 'A0UK'
    set udg_DB_Hero_FirstSpell[30] = 'A01D'
    set udg_DB_Hero_FirstSpell[31] = 'A0F9'
    set udg_DB_Hero_FirstSpell[32] = 'A0QH'
    set udg_DB_Hero_FirstSpell[33] = 'A10E'
    set udg_DB_Hero_FirstSpell[34] = 'A12J'
    set udg_DB_Hero_FirstSpell[35] = 'A032'
    set udg_DB_Hero_FirstSpell[36] = 'A183'
    set udg_DB_Hero_FirstSpell[37] = 'A0ET'
    set udg_DB_Hero_FirstSpell[38] = 'A0HW'
    set udg_DB_Hero_FirstSpell[39] = 'A0KM'
    set udg_DB_Hero_FirstSpell[40] = 'A0PR'
    set udg_DB_Hero_FirstSpell[41] = 'A0R5'
    set udg_DB_Hero_FirstSpell[42] = 'A0U7'
    set udg_DB_Hero_FirstSpell[43] = 'A0VZ'
    set udg_DB_Hero_FirstSpell[44] = 'A11U'
    set udg_DB_Hero_FirstSpell[45] = 'A194'
    set udg_DB_Hero_FirstSpell[46] = 'A14U'
    set udg_DB_Hero_FirstSpell[47] = 'A154'
    set udg_DB_Hero_FirstSpell[48] = 'A15M'
    set udg_DB_Hero_FirstSpell[49] = 'A16G'
    set udg_DB_Hero_FirstSpell[50] = 'A17J'
    set udg_DB_Hero_FirstSpell[51] = 'A17T'
    set udg_DB_Hero_FirstSpell[52] = 'A04Q'
    set udg_DB_Hero_FirstSpell[53] = 'A07J'
    set udg_DB_Hero_FirstSpell[54] = 'A08M'
    set udg_DB_Hero_FirstSpell[55] = 'A0DL'
    set udg_DB_Hero_FirstSpell[56] = 'A0J6'
    set udg_DB_Hero_FirstSpell[57] = 'A0KC'
    set udg_DB_Hero_FirstSpell[58] = 'A122'
    set udg_DB_Hero_FirstSpell[59] = 'A01G'
    set udg_DB_Hero_FirstSpell[60] = 'A02T'
    set udg_DB_Hero_FirstSpell[61] = 'A14P'
    set udg_DB_Hero_FirstSpell[62] = 'A1DG'
    set udg_DB_Hero_FirstSpell[63] = 'A05Q'
    set udg_DB_Hero_FirstSpell[64] = 'A0IC'
    set udg_DB_Hero_FirstSpell[65] = 'A09U'
    set udg_DB_Hero_FirstSpell[66] = 'A03Q'
    set udg_DB_Hero_FirstSpell[67] = 'A0JF'
    set udg_DB_Hero_FirstSpell[68] = 'A19H'
    set udg_DB_Hero_FirstSpell[69] = 'A1A8'
    set udg_DB_Hero_FirstSpell[70] = 'A1AL'
    set udg_DB_Hero_FirstSpell[71] = 'A1B7'
    set udg_DB_Hero_FirstSpell[72] = 'A01W'
    set udg_DB_Hero_FirstSpell[73] = 'A0EJ'
    set udg_DB_Hero_FirstSpell[74] = 'A0OE'
    set udg_DB_Hero_FirstSpell[75] = 'A1CJ'
    set udg_DB_Hero_FirstSpell[76] = 'A1CS'
    // Second spell
    set udg_Database_EarringSpell[1] = 'A08L'
    set udg_Database_EarringSpell[2] = 'A093'
    set udg_Database_EarringSpell[3] = 'A03E'
    set udg_Database_EarringSpell[4] = 'A0MX'
    set udg_Database_EarringSpell[5] = 'A0CM'
    set udg_Database_EarringSpell[6] = 'A07F'
    set udg_Database_EarringSpell[7] = 'A0B4'
    set udg_Database_EarringSpell[8] = 'A0AB'
    set udg_Database_EarringSpell[9] = 'A05R'
    set udg_Database_EarringSpell[10] = 'A0JC'
    set udg_Database_EarringSpell[11] = 'A05T'
    set udg_Database_EarringSpell[12] = 'A0CW'
    set udg_Database_EarringSpell[13] = 'A0E2'
    set udg_Database_EarringSpell[14] = 'A0DW'
    set udg_Database_EarringSpell[15] = 'A0NQ'
    set udg_Database_EarringSpell[16] = 'A0NK'
    set udg_Database_EarringSpell[17] = 'A02J'
    set udg_Database_EarringSpell[18] = 'A0L1'
    set udg_Database_EarringSpell[19] = 'A0MS'
    set udg_Database_EarringSpell[20] = 'A0R4'
    set udg_Database_EarringSpell[21] = 'A0SI'
    set udg_Database_EarringSpell[22] = 'A0R0'
    set udg_Database_EarringSpell[23] = 'A0TI'
    set udg_Database_EarringSpell[24] = 'A0VG'
    set udg_Database_EarringSpell[25] = 'A04G'
    set udg_Database_EarringSpell[26] = 'A0I6'
    set udg_Database_EarringSpell[27] = 'A0RZ'
    set udg_Database_EarringSpell[28] = 'A0TO'
    set udg_Database_EarringSpell[29] = 'A0UL'
    set udg_Database_EarringSpell[30] = 'A0V1'
    set udg_Database_EarringSpell[31] = 'A0FB'
    set udg_Database_EarringSpell[32] = 'A0QJ'
    set udg_Database_EarringSpell[33] = 'A10H'
    set udg_Database_EarringSpell[34] = 'A12L'
    set udg_Database_EarringSpell[35] = 'A049'
    set udg_Database_EarringSpell[36] = 'A187'
    set udg_Database_EarringSpell[37] = 'A0EU'
    set udg_Database_EarringSpell[38] = 'A0I0'
    set udg_Database_EarringSpell[39] = 'A0KS'
    set udg_Database_EarringSpell[40] = 'A0Q0'
    set udg_Database_EarringSpell[41] = 'A0R7'
    set udg_Database_EarringSpell[42] = 'A0UH'
    set udg_Database_EarringSpell[43] = 'A0W5'
    set udg_Database_EarringSpell[44] = 'A0YW'
    set udg_Database_EarringSpell[45] = 'A195'
    set udg_Database_EarringSpell[46] = 'A14X'
    set udg_Database_EarringSpell[47] = 'A155'
    set udg_Database_EarringSpell[48] = 'A15N'
    set udg_Database_EarringSpell[49] = 'A16K'
    set udg_Database_EarringSpell[50] = 'A17M'
    set udg_Database_EarringSpell[51] = 'A17V'
    set udg_Database_EarringSpell[52] = 'A04R'
    set udg_Database_EarringSpell[53] = 'A07Y'
    set udg_Database_EarringSpell[54] = 'A099'
    set udg_Database_EarringSpell[55] = 'A0E0'
    set udg_Database_EarringSpell[56] = 'A0LQ'
    set udg_Database_EarringSpell[57] = 'A0LS'
    set udg_Database_EarringSpell[58] = 'A121'
    set udg_Database_EarringSpell[59] = 'A05G'
    set udg_Database_EarringSpell[60] = 'A05F'
    set udg_Database_EarringSpell[61] = 'A149'
    set udg_Database_EarringSpell[62] = 'A02U'
    set udg_Database_EarringSpell[63] = 'A07R'
    set udg_Database_EarringSpell[64] = 'A0JN'
    set udg_Database_EarringSpell[65] = 'A09Y'
    set udg_Database_EarringSpell[66] = 'A03V'
    set udg_Database_EarringSpell[67] = 'A0JG'
    set udg_Database_EarringSpell[68] = 'A19F'
    set udg_Database_EarringSpell[69] = 'A1A9'
    set udg_Database_EarringSpell[70] = 'A1AV'
    set udg_Database_EarringSpell[71] = 'A1BF'
    set udg_Database_EarringSpell[72] = 'A03J'
    set udg_Database_EarringSpell[73] = 'A0EL'
    set udg_Database_EarringSpell[74] = 'A0OF'
    set udg_Database_EarringSpell[75] = 'A1CI'
    set udg_Database_EarringSpell[76] = 'A1CU'
    // Third spell
    set udg_DB_Hero_Passive[1] = 'A08E'
    set udg_DB_Hero_Passive[2] = 'A08W'
    set udg_DB_Hero_Passive[3] = 'A01F'
    set udg_DB_Hero_Passive[4] = 'A0FD'
    set udg_DB_Hero_Passive[5] = 'A0CK'
    set udg_DB_Hero_Passive[6] = 'A016'
    set udg_DB_Hero_Passive[7] = 'A00B'
    set udg_DB_Hero_Passive[8] = 'A0FC'
    set udg_DB_Hero_Passive[9] = 'A08U'
    set udg_DB_Hero_Passive[10] = 'A00F'
    set udg_DB_Hero_Passive[11] = 'A05M'
    set udg_DB_Hero_Passive[12] = 'A0D6'
    set udg_DB_Hero_Passive[13] = 'A07T'
    set udg_DB_Hero_Passive[14] = 'A083'
    set udg_DB_Hero_Passive[15] = 'A0NS'
    set udg_DB_Hero_Passive[16] = 'A0FQ'
    set udg_DB_Hero_Passive[17] = 'A022'
    set udg_DB_Hero_Passive[18] = 'A0LA'
    set udg_DB_Hero_Passive[19] = 'A00P'
    set udg_DB_Hero_Passive[20] = 'A0DC'
    set udg_DB_Hero_Passive[21] = 'A0S7'
    set udg_DB_Hero_Passive[22] = 'A08F'
    set udg_DB_Hero_Passive[23] = 'A1AI'
    set udg_DB_Hero_Passive[24] = 'A098'
    set udg_DB_Hero_Passive[25] = 'A0ZN'
    set udg_DB_Hero_Passive[26] = 'A0ID'
    set udg_DB_Hero_Passive[27] = 'A0RY'
    set udg_DB_Hero_Passive[28] = 'A0TP'
    set udg_DB_Hero_Passive[29] = 'A0UQ'
    set udg_DB_Hero_Passive[30] = 'A0V4'
    set udg_DB_Hero_Passive[31] = 'A0LK'
    set udg_DB_Hero_Passive[32] = 'A0VW'
    set udg_DB_Hero_Passive[33] = 'A0TJ'
    set udg_DB_Hero_Passive[34] = 'A12S'
    set udg_DB_Hero_Passive[35] = 'A04L'
    set udg_DB_Hero_Passive[36] = 'A188'
    set udg_DB_Hero_Passive[37] = 'A0EW'
    set udg_DB_Hero_Passive[38] = 'A0I9'
    set udg_DB_Hero_Passive[39] = 'A0NG'
    set udg_DB_Hero_Passive[40] = 'A0Q2'
    set udg_DB_Hero_Passive[41] = 'A0RA'
    set udg_DB_Hero_Passive[42] = 'A0UJ'
    set udg_DB_Hero_Passive[43] = 'A0WR'
    set udg_DB_Hero_Passive[44] = 'A10M'
    set udg_DB_Hero_Passive[45] = 'A198'
    set udg_DB_Hero_Passive[46] = 'A150'
    set udg_DB_Hero_Passive[47] = 'A158'
    set udg_DB_Hero_Passive[48] = 'A15Q'
    set udg_DB_Hero_Passive[49] = 'A16N'
    set udg_DB_Hero_Passive[50] = 'A17L'
    set udg_DB_Hero_Passive[51] = 'A17W'
    set udg_DB_Hero_Passive[52] = 'A04T'
    set udg_DB_Hero_Passive[53] = 'A082'
    set udg_DB_Hero_Passive[54] = 'A09A'
    set udg_DB_Hero_Passive[55] = 'A0EY'
    set udg_DB_Hero_Passive[56] = 'A0LP'
    set udg_DB_Hero_Passive[57] = 'A0JV'
    set udg_DB_Hero_Passive[58] = 'A129'
    set udg_DB_Hero_Passive[59] = 'A0DN'
    set udg_DB_Hero_Passive[60] = 'A05H'
    set udg_DB_Hero_Passive[61] = 'A0ZK'
    set udg_DB_Hero_Passive[62] = 'A0GQ'
    set udg_DB_Hero_Passive[63] = 'A09I'
    set udg_DB_Hero_Passive[64] = 'A0KB'
    set udg_DB_Hero_Passive[65] = 'A0A9'
    set udg_DB_Hero_Passive[66] = 'A03X'
    set udg_DB_Hero_Passive[67] = 'A0LD'
    set udg_DB_Hero_Passive[68] = 'A19J'
    set udg_DB_Hero_Passive[69] = 'A1A5'
    set udg_DB_Hero_Passive[70] = 'A1AT'
    set udg_DB_Hero_Passive[71] = 'A1BG'
    set udg_DB_Hero_Passive[72] = 'A04X'
    set udg_DB_Hero_Passive[73] = 'A0F7'
    set udg_DB_Hero_Passive[74] = 'A0OI'
    set udg_DB_Hero_Passive[75] = 'A1CR'
    set udg_DB_Hero_Passive[76] = 'A1CW'
	//Fourth spell
	set udg_DB_Hero_Fourth[1] = 'A00M'
	set udg_DB_Hero_Fourth[2] = 'A0NR'
	set udg_DB_Hero_Fourth[3] = 'A07X'
	set udg_DB_Hero_Fourth[4] = 'A0MU'
	set udg_DB_Hero_Fourth[5] = 'A0CN'
	set udg_DB_Hero_Fourth[6] = 'A0BW'
	set udg_DB_Hero_Fourth[7] = 'A0B9'
	set udg_DB_Hero_Fourth[8] = 'A0K4'
	set udg_DB_Hero_Fourth[9] = 'A08V'
	set udg_DB_Hero_Fourth[10] = 'A0AL'
	set udg_DB_Hero_Fourth[11] = 'A131'
	set udg_DB_Hero_Fourth[12] = 'A0B8'
	set udg_DB_Hero_Fourth[13] = 'A024'
	set udg_DB_Hero_Fourth[14] = 'A0DY'
	set udg_DB_Hero_Fourth[15] = 'A0NT'
	set udg_DB_Hero_Fourth[16] = 'A0NM'
	set udg_DB_Hero_Fourth[17] = 'A05B'
	set udg_DB_Hero_Fourth[18] = 'A0LN'
	set udg_DB_Hero_Fourth[19] = 'A09S'
	set udg_DB_Hero_Fourth[20] = 'A0RT'
	set udg_DB_Hero_Fourth[21] = 'A0SJ'
	set udg_DB_Hero_Fourth[22] = 'A0TC'
	set udg_DB_Hero_Fourth[23] = 'A0U4'
	set udg_DB_Hero_Fourth[24] = 'A0WJ'
	set udg_DB_Hero_Fourth[25] = 'A100'
	set udg_DB_Hero_Fourth[26] = 'A0J1'
	set udg_DB_Hero_Fourth[27] = 'A0B7'
	set udg_DB_Hero_Fourth[28] = 'A0UD'
	set udg_DB_Hero_Fourth[29] = 'A0UV'
	set udg_DB_Hero_Fourth[30] = 'A0V5'
	set udg_DB_Hero_Fourth[31] = 'A0IZ'
	set udg_DB_Hero_Fourth[32] = 'A0VT'
	set udg_DB_Hero_Fourth[33] = 'A10J'
	set udg_DB_Hero_Fourth[34] = 'A12T'
	set udg_DB_Hero_Fourth[35] = 'A04K'
    set udg_DB_Hero_Fourth[36] = 'A189'
    set udg_DB_Hero_Fourth[37] = 'A0F1'
    set udg_DB_Hero_Fourth[38] = 'A0HP'
    set udg_DB_Hero_Fourth[39] = 'A0LY'
    set udg_DB_Hero_Fourth[40] = 'A0Q5'
    set udg_DB_Hero_Fourth[41] = 'A0T8'
    set udg_DB_Hero_Fourth[42] = 'A0V0'
    set udg_DB_Hero_Fourth[43] = 'A0XH'
    set udg_DB_Hero_Fourth[44] = 'A11J'
    set udg_DB_Hero_Fourth[45] = 'A199'
    set udg_DB_Hero_Fourth[46] = 'A0BX'
    set udg_DB_Hero_Fourth[47] = 'A15B'
    set udg_DB_Hero_Fourth[48] = 'A15T'
    set udg_DB_Hero_Fourth[49] = 'A16Q'
    set udg_DB_Hero_Fourth[50] = 'A17O'
    set udg_DB_Hero_Fourth[51] = 'A17Y'
    set udg_DB_Hero_Fourth[52] = 'A04U'
    set udg_DB_Hero_Fourth[53] = 'A07Z'
    set udg_DB_Hero_Fourth[54] = 'A09B'
    set udg_DB_Hero_Fourth[55] = 'A0FN'
    set udg_DB_Hero_Fourth[56] = 'A0KG'
    set udg_DB_Hero_Fourth[57] = 'A0MB'
    set udg_DB_Hero_Fourth[58] = 'A12B'
    set udg_DB_Hero_Fourth[59] = 'A0OY'
    set udg_DB_Hero_Fourth[60] = 'A085'
    set udg_DB_Hero_Fourth[61] = 'A161'
    set udg_DB_Hero_Fourth[62] = 'A03H'
    set udg_DB_Hero_Fourth[63] = 'A09R'
    set udg_DB_Hero_Fourth[64] = 'A0ON'
    set udg_DB_Hero_Fourth[65] = 'A0EF'
    set udg_DB_Hero_Fourth[66] = 'A056'
    set udg_DB_Hero_Fourth[67] = 'A0LF'
    set udg_DB_Hero_Fourth[68] = 'A19K'
    set udg_DB_Hero_Fourth[69] = 'A1AC'
    set udg_DB_Hero_Fourth[70] = 'A1B0'
    set udg_DB_Hero_Fourth[71] = 'A1BH'
    set udg_DB_Hero_Fourth[72] = 'A05Y'
    set udg_DB_Hero_Fourth[73] = 'A0FF'
    set udg_DB_Hero_Fourth[74] = 'A0OJ'
    set udg_DB_Hero_Fourth[75] = 'A1CN'
    set udg_DB_Hero_Fourth[76] = 'A1CX'
endfunction

endlibrary