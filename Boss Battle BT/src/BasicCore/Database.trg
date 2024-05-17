{
  "Id": 50332123,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "function HeroWords takes string s returns string\r\n\tlocal integer cyclA = 0\r\n\tlocal integer cyclAEnd = StringLength(s)\r\n\tlocal integer i = cyclAEnd\r\n\r\n\tloop\r\n\t\texitwhen cyclA > cyclAEnd\r\n\t\tif SubString(s, cyclA, cyclA+1) == \"#\" then\r\n\t\t\tset i = cyclA\r\n\t\t\tset cyclA = cyclAEnd\r\n\t\tendif\r\n\t\tset cyclA = cyclA + 1\r\n\tendloop\r\n\r\n\treturn SubString(s, 0, i)\r\nendfunction\r\n\r\n\r\nglobals\r\n\tconstant string GAME_VERSION = \"1.7.0\"\r\n   \r\n    constant integer PLAYERS_LIMIT = 4\r\n    constant integer PLAYERS_LIMIT_ARRAYS = PLAYERS_LIMIT + 1\r\n    constant integer SETS_COUNT = 9\r\n\r\n    constant string TARGET_ALLY = \"ally\"\r\n    constant string TARGET_ENEMY = \"enemy\"\r\n    constant string TARGET_ALL = \"all\"\r\n    \r\n    constant integer ID_SHEEP = 'n03N' \r\n    \r\n    constant string DEATH_AREA = \"war3mapImported\\\\AuraOfDeath.mdx\"\r\n    \r\n    boolean DEBUG = false\r\n    unit UNIT_BUFF = null\r\n    \r\n    boolean IsSinglePlayer = false\r\n    \r\n    real array HardModAspd[9]//скорость атаки в модах\r\n    \r\n    location array ExtraArenaSpawn[PLAYERS_LIMIT_ARRAYS]\r\n    \r\n    constant integer DB_STRING_HASH = StringHash(\"is_user_slot\")\r\nendglobals\r\n\r\nfunction InitPlayersData takes nothing returns nothing\r\n\tlocal integer i = 1\r\n\tlocal integer k\r\n\tlocal player playerCheck\r\n\tlocal unit temp\r\n\r\n    loop\r\n        exitwhen i > PLAYERS_LIMIT\r\n        set playerCheck = Player(i - 1)\r\n        call SaveBoolean(udg_hash, GetHandleId(playerCheck), DB_STRING_HASH, true )\r\n        if GetPlayerController(playerCheck) == MAP_CONTROL_COMPUTER then\r\n            set udg_logic[54] = true\r\n        endif\r\n        if GetPlayerSlotState(playerCheck) == PLAYER_SLOT_STATE_PLAYING then\r\n            if udg_Host == null then\r\n                set udg_Host = playerCheck\r\n            endif\r\n            call SetPlayerName( ConvertedPlayer(i), HeroWords(GetPlayerName( playerCheck ) ) )\r\n            set udg_Heroes_Amount = udg_Heroes_Amount + 1\r\n            set udg_Player_Color_Int[i] = i\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Feerverk )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Vision1 )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Vision2 )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Vision3 )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Vision4 )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_VISIBLE, gg_rct_Vision5 )\r\n            call CreateFogModifierRectBJ( true, playerCheck, FOG_OF_WAR_MASKED, gg_rct_LoseVision )\r\n            set temp = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+i]), GetLocationY(udg_point[25+i]), bj_UNIT_FACING )\r\n            call CameraSetupApplyForPlayer( true, udg_CameraChoose[i], playerCheck, 0 )\r\n            call SetCameraTargetControllerNoZForPlayer( playerCheck, temp, 200.00, -150.00, false )\r\n            set k = 1\r\n            loop\r\n                exitwhen k > PLAYERS_LIMIT\r\n                if udg_Multiboard_Position[i] == 0 and udg_Multiboard_Position[i - 1] != k and udg_Multiboard_Position[i - 2] != k and udg_Multiboard_Position[i - 3] != k then\r\n                    set udg_Multiboard_Position[i] = k\r\n                endif\r\n                set k = k + 1\r\n            endloop\r\n        endif\r\n        set i = i + 1\r\n    endloop\r\n    \r\n    set playerCheck = null\r\n    set temp = null\r\nendfunction\r\n\r\nfunction Trig_Database_Actions takes nothing returns nothing\r\n    local integer cyclA\r\n    local integer cyclAEnd\r\n    \r\n    set udg_perc = \"%\"\r\n    set udg_Version = GAME_VERSION\r\n    set udg_UntilFirstFight = true\r\n    \r\n    if udg_hash == null then\r\n        set udg_hash = InitHashtable()\r\n    endif\r\n    set udg_rain = AddWeatherEffect(GetWorldBounds(), 'RAhr')\r\n    \r\n    set UNIT_BUFF = udg_UNIT_DUMMY_BUFF\r\n    call DataItems()\r\n    call DataBoss()\r\n    call DataAbilities()\r\n    call Skins_DataSkins()\r\n    call SetRaritySpawn( 3, 30 )\r\n    call SetAmbientDaySound( \"LordaeronSummerDay\" )\r\n    set udg_DamageTypeCriticalStrike = 1\r\n    set udg_DamageTypeBlocked = 2\r\n    set udg_real[1] = 120\r\n    set udg_BanLimit = 4\r\n    set udg_Players = GetPlayersByMapControl(MAP_CONTROL_USER)\r\n    call BlzFrameSetVisible(BlzGetFrameByName(\"ResourceBarFrame\", 0), false)\r\n    call SetUnitAnimation( udg_UNIT_DUMMY_OGRE_1, \"sleep\" )\r\n    call SetUnitAnimation( udg_UNIT_DUMMY_OGRE_2, \"sleep\" )\r\n    call resethero()\r\n    call VolumeGroupSetVolume( SOUND_VOLUMEGROUP_MUSIC, 0.7 )\r\n    // Caption\r\n    set udg_base = 0\r\n    set udg_Captions[BaseNum()] = \"xWizard\"\r\n    set udg_Captions[BaseNum()] = \"Wtii\"\r\n    set udg_Captions[BaseNum()] = \"Zolo\"\r\n    set udg_Captions[BaseNum()] = \"~Rik\"\r\n    set udg_Captions[BaseNum()] = \"2kxaoc\"\r\n    set udg_Captions[BaseNum()] = \"Azazelk0\"\r\n    set udg_Captions[BaseNum()] = \"Ratman\"\r\n    set udg_Captions[BaseNum()] = \"Sheepy\"\r\n    set udg_Captions[BaseNum()] = \"Rena\"\r\n    set udg_Captions[BaseNum()] = \"Eric\"\r\n    set udg_Captions[BaseNum()] = \"Banderling\"\r\n    set udg_Captions[BaseNum()] = \"Infoneral\"\r\n    set udg_Captions[BaseNum()] = \"Glen\"\r\n    set udg_Captions[BaseNum()] = \"Mike\"\r\n    set udg_Captions[BaseNum()] = \"Wondershovel\"\r\n    set udg_Captions[BaseNum()] = \"Leviolon\"\r\n    set udg_Captions[BaseNum()] = \"vatk0end\"\r\n    set udg_Captions[BaseNum()] = \"hooka\"\r\n    set udg_Captions[BaseNum()] = \"Pohx\"\r\n    set udg_Captions[BaseNum()] = \"mrhans\"\r\n    set udg_Captions[BaseNum()] = \"faceroll\"\r\n    set udg_Captions[BaseNum()] = \"Yoti Coyote\"\r\n    set udg_Captions[BaseNum()] = \"Lichloved\"\r\n    set udg_Captions[BaseNum()] = \"Poor Kimmo\"\r\n    set udg_Captions[BaseNum()] = \"stonebludgeon\"\r\n    set udg_Captions[BaseNum()] = \"SkifterOk\"\r\n    \r\n    set udg_DB_Hardest[0] = \"Common +0\"\r\n    set udg_DB_Hardest[1] = \"Rare +1\"\r\n    set udg_DB_Hardest[2] = \"Epic +2\"\r\n    set udg_DB_Hardest[3] = \"Legendary +3\"\r\n    set udg_DB_Hardest[4] = \"Mythical +4\"\r\n    set udg_DB_Hardest[5] = \"Horrific +5\"\r\n    /*set udg_DB_Hardest[6] = \"Monstrous +6\"\r\n    set udg_DB_Hardest[7] = \"Demonic +7\"\r\n    set udg_DB_Hardest[8] = \"Diabolic +8\"\r\n    set udg_DB_Hardest[9] = \"Infernal +9\"*/\r\n    //set udg_DB_Hardest_On[0] = 'A0EH'\r\n    set udg_DB_Hardest_On[1] = 'A043'\r\n    set udg_DB_Hardest_On[2] = 'A046'\r\n    set udg_DB_Hardest_On[3] = 'A047'\r\n    set udg_DB_Hardest_On[4] = 'A045'\r\n    set udg_DB_Hardest_On[5] = 'A048'\r\n    /*set udg_DB_Hardest_On[6] = 'A04H'\r\n    set udg_DB_Hardest_On[7] = 'AZD1'\r\n    set udg_DB_Hardest_On[8] = 'AZD2'\r\n    set udg_DB_Hardest_On[9] = 'AZD3'*/\r\n    \r\n    set udg_HardModBonus[1] = 'A0CA'\r\n    set udg_HardModBonus[2] = 'A0CG'\r\n    set udg_HardModBonus[3] = 'A05S'\r\n    set udg_HardModBonus[4] = 'A07Q'\r\n    \r\n    set HardModAspd[0]=1.0\r\n    set HardModAspd[1]=1.4\r\n    set HardModAspd[2]=1.8\r\n    set HardModAspd[3]=2.2\r\n    set HardModAspd[4]=2.6\r\n    set HardModAspd[5]=3.0\r\n    /*set HardModAspd[6]=2.2\r\n    set HardModAspd[7]=2.4\r\n    set HardModAspd[8]=2.6\r\n    set HardModAspd[9]=2.8*/\r\n            \r\n    // Set color\r\n    set udg_DB_AllSet = 9\r\n    set udg_DB_Set_Color[1] = \"|cffb18904\"\r\n    set udg_DB_Set_Color[2] = \"|cff2d9995\"\r\n    set udg_DB_Set_Color[3] = \"|cff9001fd\"\r\n    set udg_DB_Set_Color[4] = \"|cffb40431\"\r\n    set udg_DB_Set_Color[5] = \"|cff848484\"\r\n    set udg_DB_Set_Color[6] = \"|cff5858fa\"\r\n    set udg_DB_Set_Color[7] = \"|cff7cfc00\"\r\n    set udg_DB_Set_Color[8] = \"|cfffe9a2e\"\r\n    set udg_DB_Set_Color[9] = \"|cff00ccee\"\r\n    \r\n    set udg_base = 0\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffff0000\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff0000ff\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff40e0d0\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF540081\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFFFFFC01\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFFFE8A0E\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF20C000\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFFE55BB0\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF959697\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF7EBFF1\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF106246\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cFF4E2A04\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff9c0000\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff0000c3\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff00ebff\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffbd00ff\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffecce87\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cfff7a58b\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffbfff81\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffdbb8eb\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff4f5055\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffecf0ff\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cff00781e\"\r\n    set udg_DB_Player_Color[BaseNum()] = \"|cffa56f34\"\r\n    set udg_DB_AllColors = udg_base\r\n\r\n    // Feerverk\r\n    set udg_Database_Feerverk[1] = \"Fireworksblue.mdx\"\r\n    set udg_Database_Feerverk[2] = \"Fireworksred.mdx\"\r\n    set udg_Database_Feerverk[3] = \"Fireworksgreen.mdx\"\r\n    set udg_Database_Feerverk[4] = \"Fireworkspurple.mdx\"\r\n\t// Экзотические существа\r\n    set udg_Database_NumberItems[28] = 5\r\n    set udg_Eczotic[1] = 'n00T'\r\n    set udg_Eczotic[2] = 'n00D'\r\n    set udg_Eczotic[3] = 'n00V'\r\n    set udg_Eczotic[4] = 'n00O'\r\n    set udg_Eczotic[5] = 'u00Z'\r\n\r\n    // Icons\r\n    set udg_DB_Hero_Icon[1] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNBlueDragonSpawn.blp\"\r\n    set udg_DB_Hero_Icon[2] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNEarthBrewmaster.blp\"\r\n    set udg_DB_Hero_Icon[3] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNBandit.blp\"\r\n    set udg_DB_Hero_Icon[4] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeadhunter.blp\"\r\n    set udg_DB_Hero_Icon[5] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNLichVersion2.blp\"\r\n    set udg_DB_Hero_Icon[6] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroPaladin.blp\"\r\n    set udg_DB_Hero_Icon[7] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNFurbolgTracker.blp\"\r\n    set udg_DB_Hero_Icon[8] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroDreadLord.blp\"\r\n    set udg_DB_Hero_Icon[9] = \"BTNSpell_Shadow_SummonVoidWalker.blp\"\r\n    set udg_DB_Hero_Icon[10] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDruidOfTheTalon.blp\"\r\n    set udg_DB_Hero_Icon[11] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroDeathKnight.blp\"\r\n    set udg_DB_Hero_Icon[12] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroCryptLord.blp\"\r\n    set udg_DB_Hero_Icon[13] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNOwlBear.blp\"\r\n    set udg_DB_Hero_Icon[14] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNTauren.blp\"\r\n    set udg_DB_Hero_Icon[15] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDranaiMage.blp\"\r\n    set udg_DB_Hero_Icon[16] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroAvatarOfFlame.blp\"\r\n    set udg_DB_Hero_Icon[17] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNNagaSummoner.blp\"\r\n    set udg_DB_Hero_Icon[18] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNRifleman.blp\"\r\n    set udg_DB_Hero_Icon[19] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNBanditMage.blp\"\r\n    set udg_DB_Hero_Icon[20] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNForestTrollShadowPriest.blp\"\r\n    set udg_DB_Hero_Icon[21] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNGoblinSapper.blp\"\r\n    set udg_DB_Hero_Icon[22] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNBeastMaster.blp\"\r\n    set udg_DB_Hero_Icon[23] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNMurgulShadowCaster.blp\"\r\n    set udg_DB_Hero_Icon[24] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNPitLord.blp\"\r\n    set udg_DB_Hero_Icon[25] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNSkeletonWarrior.blp\"\r\n    set udg_DB_Hero_Icon[26] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNBansheeRanger.blp\"\r\n    set udg_DB_Hero_Icon[27] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNProudmoore.blp\"\r\n    set udg_DB_Hero_Icon[28] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHarpyWitch.blp\"\r\n    set udg_DB_Hero_Icon[29] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNNagaMyrmidonRoyalGuard.blp\"\r\n    set udg_DB_Hero_Icon[30] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNWispSplode.blp\"\r\n    set udg_DB_Hero_Icon[31] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNUnbroken.blp\"\r\n    set udg_DB_Hero_Icon[32] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroBlademaster.blp\"\r\n    set udg_DB_Hero_Icon[33] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNSatyrTrickster.blp\"\r\n    set udg_DB_Hero_Icon[34] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNTuskaarBlack.blp\"\r\n    set udg_DB_Hero_Icon[35] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNKelThuzad.blp\"\r\n    set udg_DB_Hero_Icon[36] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNKeeperOfTheGrove.blp\"\r\n    set udg_DB_Hero_Icon[37] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNOneHeadedOgre.blp\"\r\n    set udg_DB_Hero_Icon[38] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDryad.blp\"\r\n    set udg_DB_Hero_Icon[39] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNFootman.blp\"\r\n    set udg_DB_Hero_Icon[40] = \"war3mapImported\\\\BTNKingOfGhouls_Icon.blp\"\r\n    set udg_DB_Hero_Icon[41] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDalaranReject.blp\"\r\n    set udg_DB_Hero_Icon[42] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNVengeanceIncarnate.blp\"\r\n    set udg_DB_Hero_Icon[43] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNYouDirtyRat!.blp\"\r\n    set udg_DB_Hero_Icon[44] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroAlchemist.blp\"\r\n    set udg_DB_Hero_Icon[45] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNForgottenOne.blp\"\r\n    set udg_DB_Hero_Icon[46] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNWitchDoctor.blp\"\r\n    set udg_DB_Hero_Icon[47] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNZergling.blp\"\r\n    set udg_DB_Hero_Icon[48] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNSnapDragon.blp\"\r\n    set udg_DB_Hero_Icon[49] = \"war3mapImported\\\\BTNHolyMage.blp\"\r\n    set udg_DB_Hero_Icon[50] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNPriest.blp\"\r\n    set udg_DB_Hero_Icon[51] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNAbomination.blp\"\r\n    set udg_DB_Hero_Icon[52] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNShaman.blp\"\r\n    set udg_DB_Hero_Icon[53] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroDemonHunter.blp\"\r\n    set udg_DB_Hero_Icon[54] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNGreenDragon.blp\"\r\n    set udg_DB_Hero_Icon[55] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNArchimonde.blp\"\r\n    set udg_DB_Hero_Icon[56] = \"war3mapImported\\\\BTNSummonWaterElemental.blp\"\r\n    set udg_DB_Hero_Icon[57] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroWarden.blp\"\r\n    set udg_DB_Hero_Icon[58] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDestroyer.blp\"\r\n    set udg_DB_Hero_Icon[59] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNMeatWagon.blp\"\r\n    set udg_DB_Hero_Icon[60] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNRevenant.blp\"\r\n    set udg_DB_Hero_Icon[61] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNKeeperGhostBlue.blp\"\r\n    set udg_DB_Hero_Icon[62] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDragonHawk.blp\"\r\n    set udg_DB_Hero_Icon[63] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNTheCaptain.blp\"\r\n    set udg_DB_Hero_Icon[64] = \"war3mapImported\\\\BTNskinvaleera.blp\"\r\n    set udg_DB_Hero_Icon[65] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNScout.blp\"\r\n    set udg_DB_Hero_Icon[66] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNPriestessOfTheMoon.blp\"\r\n    set udg_DB_Hero_Icon[67] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNMedivh.blp\"\r\n    set udg_DB_Hero_Icon[68] = \"war3mapImported\\\\BTNRifleman_Kul-Tiras_HD_noTC.blp\"\r\n    set udg_DB_Hero_Icon[69] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNInfernal.blp\"\r\n    set udg_DB_Hero_Icon[70] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNHeroBloodElfPrince.blp\"\r\n    set udg_DB_Hero_Icon[71] = \"war3mapImported\\\\BTNEasterWabbit.blp\"\r\n    set udg_DB_Hero_Icon[72] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNGuldan.blp\"\r\n    set udg_DB_Hero_Icon[73] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNGarithos.blp\"\r\n    set udg_DB_Hero_Icon[74] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNCorruptedEnt.blp\"\r\n    set udg_DB_Hero_Icon[75] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDruidOfTheClaw.blp\"\r\n    set udg_DB_Hero_Icon[76] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNWindSerpent.blp\"\r\n    set udg_DB_Hero_Icon[77] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNDranai.blp\"\r\n    set udg_DB_Hero_Icon[78] = \"ReplaceableTextures\\\\CommandButtons\\\\BTNAncientOfWonders.blp\"\r\n    \r\n    \r\n    // Триггеры механизмов\r\n    set udg_Database_NumberItems[35] = 12\r\n    set udg_DB_MechUse[1] = gg_trg_Piu_Mashine\r\n    set udg_DB_MechUse[2] = gg_trg_Stim_Injector\r\n    set udg_DB_MechUse[3] = gg_trg_ManaGive\r\n    set udg_DB_MechUse[4] = gg_trg_Autonavigator\r\n    set udg_DB_MechUse[5] = gg_trg_Saronite_Bomb\r\n    set udg_DB_MechUse[6] = gg_trg_Approximatron\r\n    set udg_DB_MechUse[7] = gg_trg_Repeller\r\n    set udg_DB_MechUse[8] = gg_trg_Superbot\r\n    set udg_DB_MechUse[9] = gg_trg_BoomSub\r\n    set udg_DB_MechUse[10] = gg_trg_Jet_Boots\r\n    set udg_DB_MechUse[11] = gg_trg_Ashbringer\r\n    set udg_DB_MechUse[12] = gg_trg_OldHealer\r\n    \r\n    /*set udg_Database_Score_Unit[7] = 'n01A'\r\n    set udg_Database_Score_Unit[8] = 'n01B'\r\n    set udg_Database_Score_Unit[9] = 'n01C'\r\n    set udg_Database_Score_Unit[10] = 'n01D'\r\n    set udg_Database_Score_Unit[11] = 'n01E'\r\n    set udg_Database_Score_Unit[12] = 'n01F'*/\r\n    \r\n    set udg_Database_Score_Item[1] = 'I03A'\r\n    set udg_Database_Score_Item[2] = 'I03C'\r\n    set udg_Database_Score_Item[3] = 'I03B'\r\n    set udg_Database_Score_Item[4] = 'I039'\r\n    set udg_Database_Score_Item[5] = 'I038'\r\n    set udg_Database_Score_Item[6] = 'I037'\r\n    // Существа\r\n    set udg_base = 0\r\n    set udg_Database_RandomUnit[BaseNum()] = 'h00S'\r\n    //set udg_Database_RandomUnit[BaseNum()] = 'o00H'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n01O'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n003'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n01N'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'e007'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'h00L'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00G'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o008'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00A'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n012'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n01Y'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n006'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00B'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00C'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00D'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u017'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u018'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u019'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01C'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01D'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01E'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01F'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01A'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01B'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n022'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n023'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n024'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n025'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n026'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n027'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00H'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n04D'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u01I'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o01B'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n047'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u013'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n02F'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n00U'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'e00E'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n02V'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n02X'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00Y'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'h01E'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n035'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00O'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'h00O'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n036'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'e00I'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00P'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03F'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00V'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00W'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'ninf'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03Q'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03S'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03T'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03U'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u007'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u009'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00E'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00G'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00M'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00N'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00O'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00P'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00Q'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00R'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00S'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00V'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'u00W'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n02Z'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n037'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03H'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n03W'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n053'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o01C'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'o00R'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n020'\r\n    set udg_Database_RandomUnit[BaseNum()] = 'n02J'\r\n    set udg_Database_NumberItems[5] = udg_base\r\n    // Дриада\r\n    set udg_DryadMinion[1] = 'n02Z'\r\n    set udg_DryadMinion[2] = 'n037'\r\n    set udg_DryadMinion[3] = 'n03H'\r\n    set udg_DryadMinion[4] = 'n03W'\r\n    \r\n    set udg_DryadMinionHP[1] = 25\r\n    set udg_DryadMinionHP[2] = 50\r\n    set udg_DryadMinionHP[3] = 50\r\n    set udg_DryadMinionHP[4] = 100\r\n    \r\n    set udg_DryadMinionAT[1] = 4\r\n    set udg_DryadMinionAT[2] = 6\r\n    set udg_DryadMinionAT[3] = 4\r\n    set udg_DryadMinionAT[4] = 5\r\n    \r\n    // Бесконечная арена\r\n    set udg_Database_NumberItems[33] = 30\r\n    set udg_Database_IA_Unit[1] = 'u00B'\r\n    set udg_Database_IA_Unit[2] = 'u00C'\r\n    set udg_Database_IA_Unit[3] = 'u00D'\r\n    set udg_Database_IA_Unit[4] = 'u017'\r\n    set udg_Database_IA_Unit[5] = 'u018'\r\n    set udg_Database_IA_Unit[6] = 'u019'\r\n    \r\n    set udg_Database_IA_Unit[7] = 'n022'\r\n    set udg_Database_IA_Unit[8] = 'n023'\r\n    set udg_Database_IA_Unit[9] = 'n024'\r\n    set udg_Database_IA_Unit[10] = 'n025'\r\n    set udg_Database_IA_Unit[11] = 'n026'\r\n    set udg_Database_IA_Unit[12] = 'n027'\r\n    \r\n    set udg_Database_IA_Unit[13] = 'u01C'\r\n    set udg_Database_IA_Unit[14] = 'u01D'\r\n    set udg_Database_IA_Unit[15] = 'u01E'\r\n    set udg_Database_IA_Unit[16] = 'u01F'\r\n    set udg_Database_IA_Unit[17] = 'u01A'\r\n    set udg_Database_IA_Unit[18] = 'u01B'\r\n    \r\n    set udg_Database_IA_Unit[19] = 'u009'\r\n    set udg_Database_IA_Unit[20] = 'u00E'\r\n    set udg_Database_IA_Unit[21] = 'u00G'\r\n    set udg_Database_IA_Unit[22] = 'u00M'\r\n    set udg_Database_IA_Unit[23] = 'u00N'\r\n    set udg_Database_IA_Unit[24] = 'u00O'\r\n    \r\n    set udg_Database_IA_Unit[25] = 'u00P'\r\n    set udg_Database_IA_Unit[26] = 'u00Q'\r\n    set udg_Database_IA_Unit[27] = 'u00R'\r\n    set udg_Database_IA_Unit[28] = 'u00S'\r\n    set udg_Database_IA_Unit[29] = 'u00V'\r\n    set udg_Database_IA_Unit[30] = 'u00W'\r\n    \r\n    // Мешок Санты\r\n    set udg_SantaPoint[1] = Location(GetRectCenterX(gg_rct_Bag1), GetRectCenterY(gg_rct_Bag1))\r\n    set udg_SantaPoint[2] = Location(GetRectCenterX(gg_rct_Bag2), GetRectCenterY(gg_rct_Bag2))\r\n    set udg_SantaPoint[3] = Location(GetRectCenterX(gg_rct_Bag3), GetRectCenterY(gg_rct_Bag3))\r\n    set udg_SantaPoint[4] = Location(GetRectCenterX(gg_rct_Bag4), GetRectCenterY(gg_rct_Bag4))\r\n    set udg_SantaPoint[5] = Location(GetRectCenterX(gg_rct_Bag5), GetRectCenterY(gg_rct_Bag5))\r\n    set udg_SantaPoint[6] = Location(GetRectCenterX(gg_rct_Bag6), GetRectCenterY(gg_rct_Bag6))\r\n    set udg_SantaPoint[7] = Location(GetRectCenterX(gg_rct_Bag7), GetRectCenterY(gg_rct_Bag7))\r\n    set udg_SantaPoint[8] = Location(GetRectCenterX(gg_rct_Bag8), GetRectCenterY(gg_rct_Bag8))\r\n    set udg_SantaPoint[9] = Location(GetRectCenterX(gg_rct_Bag9), GetRectCenterY(gg_rct_Bag9))\r\n    set udg_SantaPoint[10] = Location(GetRectCenterX(gg_rct_Bag10), GetRectCenterY(gg_rct_Bag10))\r\n    set udg_SantaPoint[11] = Location(GetRectCenterX(gg_rct_Bag11), GetRectCenterY(gg_rct_Bag11))\r\n    set udg_SantaPoint[12] = Location(GetRectCenterX(gg_rct_Bag12), GetRectCenterY(gg_rct_Bag12))\r\n    // Прочее\r\n\tset udg_point[9] = Location(GetRectCenterX(gg_rct_PvPArena1), GetRectCenterY(gg_rct_PvPArena1))\r\n\tset udg_point[10] = Location(GetRectCenterX(gg_rct_PvPArena2), GetRectCenterY(gg_rct_PvPArena2))\r\n    set udg_point[14] = Location(GetRectCenterX(gg_rct_ImpSpawn1), GetRectCenterY(gg_rct_ImpSpawn1)) \r\n    set udg_point[15] = Location(GetRectCenterX(gg_rct_ImpSpawn2), GetRectCenterY(gg_rct_ImpSpawn2))\r\n    set udg_point[16] = Location(GetRectCenterX(gg_rct_ImpSpawn3), GetRectCenterY(gg_rct_ImpSpawn3))\r\n    set udg_point[17] = Location(GetRectCenterX(gg_rct_ImpSpawn4), GetRectCenterY(gg_rct_ImpSpawn4))  \r\n    set udg_point[44] = Location(GetRectCenterX(gg_rct_IA_Portal1), GetRectCenterY(gg_rct_IA_Portal1))\r\n    set udg_point[45] = Location(GetRectCenterX(gg_rct_IA_Portal2), GetRectCenterY(gg_rct_IA_Portal2))\r\n    set udg_point[46] = Location(GetRectCenterX(gg_rct_IA_Portal3), GetRectCenterY(gg_rct_IA_Portal3))\r\n    set udg_point[47] = Location(GetRectCenterX(gg_rct_IA_Portal4), GetRectCenterY(gg_rct_IA_Portal4))\r\n    set udg_string[0] = \"|cf0FFFFFF \"\r\n    set udg_Boss_Rect = gg_rct_ArenaBoss\r\n    \r\n    if GetPlayerSlotState(Player(0)) == PLAYER_SLOT_STATE_PLAYING then\r\n        call UnitAddAbility( udg_unit[32], 'A0JI' )\r\n        call UnitAddAbility( udg_unit[32], 'A0JL' )\r\n        call UnitAddAbility( udg_unit[32], 'A0JK' )\r\n        call KillDestructable(udg_DEST_GATE_RED)\r\n        call SetDestructableAnimation(udg_DEST_GATE_RED, \"death alternate\")\r\n        set udg_Color_Player_Red[1] = 80.00\r\n        set udg_Player_Color[1] = \"|cffff0000\"\r\n        set udg_unit[5] = udg_UNIT_PLAYER_STATUS_RED\r\n        set udg_unit[11] = udg_UNIT_EXTERMINATOR_RED\r\n        set udg_unit[18] = udg_UNIT_INFORMANT_RED\r\n        set udg_artifzone[1] = udg_UNIT_ARTIFACT_CIRCLE_RED\r\n        set udg_point[1] = Location(GetRectCenterX(gg_rct_Artifact1), GetRectCenterY(gg_rct_Artifact1))\r\n        set udg_point[5] = Location(GetRectCenterX(gg_rct_Tphero1), GetRectCenterY(gg_rct_Tphero1))\r\n        set udg_point[18] = Location(GetRectCenterX(gg_rct_ImpArena1), GetRectCenterY(gg_rct_ImpArena1))\r\n        set udg_point[22] = Location(GetRectCenterX(gg_rct_Preparation1), GetRectCenterY(gg_rct_Preparation1))\r\n        set udg_point[26] = Location(GetRectCenterX(gg_rct_HeroSpawn1), GetRectCenterY(gg_rct_HeroSpawn1))\r\n        set udg_point[30] = Location(GetRectCenterX(gg_rct_Tphero1Small), GetRectCenterY(gg_rct_Tphero1Small))\r\n        set udg_itemcentr[1] = Location(GetRectCenterX(gg_rct_ItemSpawn1), GetRectCenterY(gg_rct_ItemSpawn1))\r\n        set udg_itemcentr[2] = Location(GetRectCenterX(gg_rct_ItemSpawn2), GetRectCenterY(gg_rct_ItemSpawn2)) \r\n        set udg_itemcentr[3] = Location(GetRectCenterX(gg_rct_ItemSpawn3), GetRectCenterY(gg_rct_ItemSpawn3)) \r\n        set udg_Visible[1] = CreateFogModifierRectBJ( false, Player(0), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn1 )\r\n        set ExtraArenaSpawn[1] = Location(GetRectCenterX(gg_rct_ExtraArenaSpawn1), GetRectCenterY(gg_rct_ExtraArenaSpawn1))\r\n        set udg_CameraChoose[1] = gg_cam_Choose1\r\n    else\r\n        call RemoveUnit( udg_UNIT_INFORMANT_RED )\r\n        call RemoveUnit( udg_UNIT_EXTERMINATOR_RED )\r\n        call RemoveUnit( udg_UNIT_PLAYER_STATUS_RED )\r\n        call RemoveUnit( udg_UNIT_MIXOLOGIST_RED )\r\n    endif\r\n    if GetPlayerSlotState(Player(1)) == PLAYER_SLOT_STATE_PLAYING then\r\n        call KillDestructable(udg_DEST_GATE_BLUE)\r\n        call SetDestructableAnimation(udg_DEST_GATE_BLUE, \"death alternate\")\r\n        set udg_Color_Player_Blue[2] = 80.00\r\n        set udg_Player_Color[2] = \"|cff0000ff\"\r\n        set udg_unit[6] = udg_UNIT_PLAYER_STATUS_BLUE\r\n        set udg_unit[12] = udg_UNIT_EXTERMINATOR_BLUE\r\n        set udg_unit[19] = udg_UNIT_INFORMANT_BLUE\r\n        set udg_artifzone[2] = udg_UNIT_ARTIFACT_CIRCLE_BLUE\r\n        set udg_point[2] = Location(GetRectCenterX(gg_rct_Artifact2), GetRectCenterY(gg_rct_Artifact2))\r\n        set udg_point[6] = Location(GetRectCenterX(gg_rct_Tphero2), GetRectCenterY(gg_rct_Tphero2))\r\n        set udg_point[19] = Location(GetRectCenterX(gg_rct_ImpArena2), GetRectCenterY(gg_rct_ImpArena2))\r\n        set udg_point[23] = Location(GetRectCenterX(gg_rct_Preparation2), GetRectCenterY(gg_rct_Preparation2))\r\n        set udg_point[27] = Location(GetRectCenterX(gg_rct_HeroSpawn2), GetRectCenterY(gg_rct_HeroSpawn2))\r\n        set udg_point[31] = Location(GetRectCenterX(gg_rct_Tphero2Small), GetRectCenterY(gg_rct_Tphero2Small))\r\n        set udg_itemcentr[4] = Location(GetRectCenterX(gg_rct_ItemSpawn4), GetRectCenterY(gg_rct_ItemSpawn4))\r\n        set udg_itemcentr[5] = Location(GetRectCenterX(gg_rct_ItemSpawn5), GetRectCenterY(gg_rct_ItemSpawn5)) \r\n        set udg_itemcentr[6] = Location(GetRectCenterX(gg_rct_ItemSpawn6), GetRectCenterY(gg_rct_ItemSpawn6))\r\n    \tset udg_Visible[2] = CreateFogModifierRectBJ( false, Player(1), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn2 )\r\n    \tset ExtraArenaSpawn[2] = Location(GetRectCenterX(gg_rct_ExtraArenaSpawn2), GetRectCenterY(gg_rct_ExtraArenaSpawn2))\r\n    \tset udg_CameraChoose[2] = gg_cam_Choose2\r\n    else\r\n        call RemoveUnit( udg_UNIT_PLAYER_STATUS_BLUE )\r\n        call RemoveUnit( udg_UNIT_EXTERMINATOR_BLUE )\r\n        call RemoveUnit( udg_UNIT_INFORMANT_BLUE )\r\n\t\tcall RemoveUnit( udg_UNIT_MIXOLOGIST_BLUE )\r\n    endif\r\n    if GetPlayerSlotState(Player(2)) == PLAYER_SLOT_STATE_PLAYING then\r\n        call KillDestructable(udg_DEST_GATE_TEAL)\r\n        call SetDestructableAnimation(udg_DEST_GATE_TEAL, \"death alternate\")\r\n        set udg_Color_Player_Green[3] = 70.00\r\n        set udg_Color_Player_Blue[3] = 70.00\r\n        set udg_Player_Color[3] = \"|cff40e0d0\"\r\n        set udg_unit[7] = udg_UNIT_PLAYER_STATUS_TEAL\r\n        set udg_unit[13] = udg_UNIT_EXTERMINATOR_TEAL\r\n        set udg_unit[20] = udg_UNIT_INFORMANT_TEAL\r\n        set udg_artifzone[3] = udg_UNIT_ARTIFACT_CIRCLE_TEAL\r\n        set udg_point[3] = Location(GetRectCenterX(gg_rct_Artifact3), GetRectCenterY(gg_rct_Artifact3))\r\n        set udg_point[7] = Location(GetRectCenterX(gg_rct_Tphero3), GetRectCenterY(gg_rct_Tphero3))\r\n        set udg_point[20] = Location(GetRectCenterX(gg_rct_ImpArena3), GetRectCenterY(gg_rct_ImpArena3))\r\n        set udg_point[24] = Location(GetRectCenterX(gg_rct_Preparation3), GetRectCenterY(gg_rct_Preparation3))\r\n        set udg_point[28] = Location(GetRectCenterX(gg_rct_HeroSpawn3), GetRectCenterY(gg_rct_HeroSpawn3))\r\n        set udg_point[32] = Location(GetRectCenterX(gg_rct_Tphero3Small), GetRectCenterY(gg_rct_Tphero3Small))\r\n        set udg_itemcentr[7] = Location(GetRectCenterX(gg_rct_ItemSpawn7), GetRectCenterY(gg_rct_ItemSpawn7))\r\n        set udg_itemcentr[8] = Location(GetRectCenterX(gg_rct_ItemSpawn8), GetRectCenterY(gg_rct_ItemSpawn8)) \r\n        set udg_itemcentr[9] = Location(GetRectCenterX(gg_rct_ItemSpawn9), GetRectCenterY(gg_rct_ItemSpawn9))\r\n    \tset udg_Visible[3] = CreateFogModifierRectBJ( false, Player(2), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn3 )\r\n    \tset ExtraArenaSpawn[3] = Location(GetRectCenterX(gg_rct_ExtraArenaSpawn3), GetRectCenterY(gg_rct_ExtraArenaSpawn3))\r\n    \tset udg_CameraChoose[3] = gg_cam_Choose3\r\n    else\r\n        call RemoveUnit( udg_UNIT_PLAYER_STATUS_TEAL )\r\n        call RemoveUnit( udg_UNIT_EXTERMINATOR_TEAL )\r\n        call RemoveUnit( udg_UNIT_INFORMANT_TEAL )\r\n\t\tcall RemoveUnit( udg_UNIT_MIXOLOGIST_TEAL )\r\n    endif\r\n    if GetPlayerSlotState(Player(3)) == PLAYER_SLOT_STATE_PLAYING then\r\n        call KillDestructable(udg_DEST_GATE_PURPLE)\r\n        call SetDestructableAnimation(udg_DEST_GATE_PURPLE, \"death alternate\")\r\n        set udg_Color_Player_Red[4] = 50.00\r\n        set udg_Color_Player_Blue[4] = 80.00\r\n        set udg_Player_Color[4] = \"|cff652187\"\r\n        set udg_unit[8] = udg_UNIT_PLAYER_STATUS_PURPLE\r\n        set udg_unit[14] = udg_UNIT_EXTERMINATOR_PURPLE\r\n        set udg_unit[21] = udg_UNIT_INFORMANT_PURPLE\r\n        set udg_artifzone[4] = udg_UNIT_ARTIFACT_CIRCLE_PURPLE\r\n        set udg_point[4] = Location(GetRectCenterX(gg_rct_Artifact4), GetRectCenterY(gg_rct_Artifact4))\r\n        set udg_point[8] = Location(GetRectCenterX(gg_rct_Tphero4), GetRectCenterY(gg_rct_Tphero4))\r\n        set udg_point[21] = Location(GetRectCenterX(gg_rct_ImpArena4), GetRectCenterY(gg_rct_ImpArena4))\r\n        set udg_point[25] = Location(GetRectCenterX(gg_rct_Preparation4), GetRectCenterY(gg_rct_Preparation4))\r\n        set udg_point[29] = Location(GetRectCenterX(gg_rct_HeroSpawn4), GetRectCenterY(gg_rct_HeroSpawn4))\r\n        set udg_point[33] = Location(GetRectCenterX(gg_rct_Tphero4Small), GetRectCenterY(gg_rct_Tphero4Small))\r\n        set udg_itemcentr[10] = Location(GetRectCenterX(gg_rct_ItemSpawn10), GetRectCenterY(gg_rct_ItemSpawn10))\r\n        set udg_itemcentr[11] = Location(GetRectCenterX(gg_rct_ItemSpawn11), GetRectCenterY(gg_rct_ItemSpawn11)) \r\n        set udg_itemcentr[12] = Location(GetRectCenterX(gg_rct_ItemSpawn12), GetRectCenterY(gg_rct_ItemSpawn12))\r\n    \tset udg_Visible[4] = CreateFogModifierRectBJ( false, Player(3), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn4 )\r\n    \tset ExtraArenaSpawn[4] = Location(GetRectCenterX(gg_rct_ExtraArenaSpawn4), GetRectCenterY(gg_rct_ExtraArenaSpawn4))\r\n    \tset udg_CameraChoose[4] = gg_cam_Choose4\r\n    else\r\n        call RemoveUnit( udg_UNIT_PLAYER_STATUS_PURPLE )\r\n        call RemoveUnit( udg_UNIT_EXTERMINATOR_PURPLE )\r\n        call RemoveUnit( udg_UNIT_INFORMANT_PURPLE )\r\n        call RemoveUnit( udg_UNIT_MIXOLOGIST_PURPLE )\r\n    endif\r\n    set udg_Hardest = \"Normal\"\r\n    set udg_ModName = \"\"\r\n    //call ShowUnit(udg_UNIT_BANNER, false) \r\n    \r\n    call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, \"ReplaceableTextures\\\\CameraMasks\\\\DreamFilter_Mask.blp\", 100, 0.00, 0.00, 33.00, 100.00, 20.00, 30.00, 33.00 )\r\n    call DisplayCineFilter(false)\r\n    call SetMapFlag( MAP_LOCK_ALLIANCE_CHANGES, true )\r\n    call SetMapFlag( MAP_RESOURCE_TRADING_ALLIES_ONLY, true )\r\n    call SetMapFlag( MAP_ALLIANCE_CHANGES_HIDDEN, true )\r\n    call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12 )\r\n    call SetTimeOfDayScale(0)\r\n    call SetPlayerOnScoreScreen(Player(4), false)\r\n    call SetPlayerOnScoreScreen(Player(10), false)\r\n    //call SetPlayerOnScoreScreen(Player(11), false)\r\n    call SetPlayerState( Player(4), PLAYER_STATE_GIVES_BOUNTY, 0)\r\n    call SetPlayerState( Player(10), PLAYER_STATE_GIVES_BOUNTY, 0)\r\n    //call SetPlayerState( Player(11), PLAYER_STATE_GIVES_BOUNTY, 0)\r\n    call CreateFogModifierRectBJ( true, Player(4), FOG_OF_WAR_VISIBLE, GetWorldBounds() )\r\n    call CreateFogModifierRectBJ( true, Player(10), FOG_OF_WAR_VISIBLE, GetWorldBounds() )\r\n    //call CreateFogModifierRectBJ( true, Player(11), FOG_OF_WAR_VISIBLE, GetWorldBounds() )\r\n    \r\n    call InitPlayersData()\r\n    if udg_Heroes_Amount == 1 then\r\n        set udg_logic[54] = true\r\n        set IsSinglePlayer = true\r\n    endif\r\n    set udg_BossHP = udg_BossHP - ( 0.15 * ( 4 - udg_Heroes_Amount ) ) \r\n    set udg_BossAT = udg_BossAT - ( 0.1 * ( 4 - udg_Heroes_Amount ) )\r\n    call SpellPower_AddBossSpellPower( -0.1 * ( 4 - udg_Heroes_Amount ) )\r\n    \r\n    /*Base Stat increase*/\r\n    set udg_BossHP = udg_BossHP + 0.2\r\n    set udg_BossAT = udg_BossAT + 0.1\r\nendfunction\r\n\r\n//===========================================================================\r\nfunction InitTrig_Database takes nothing returns nothing\r\n    set gg_trg_Database = CreateTrigger(  )\r\n    call TriggerRegisterTimerExpireEvent( gg_trg_Database, udg_StartTimer )\r\n    call TriggerAddAction( gg_trg_Database, function Trig_Database_Actions )\r\nendfunction\r\n\r\n",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}