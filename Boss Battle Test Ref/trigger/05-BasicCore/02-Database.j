function HeroWords takes string s returns string
	local integer cyclA = 0
	local integer cyclAEnd = StringLength(s)
	local integer i = cyclAEnd

	loop
		exitwhen cyclA > cyclAEnd
		if SubString(s, cyclA, cyclA+1) == "#" then
			set i = cyclA
			set cyclA = cyclAEnd
		endif
		set cyclA = cyclA + 1
	endloop

	return SubString(s, 0, i)
endfunction

globals
    integer array skinmodel[80][6]//модель/номер
    integer array skinlvl[80][6]//уровень/номер
    string array skiniconBTN[10][6]//позиция/номер
    string array skiniconDIS[10][6]//позиция/номер
    
    constant integer PLAYERS_LIMIT = 4
    constant integer PLAYERS_LIMIT_ARRAYS = PLAYERS_LIMIT + 1
    constant integer SETS_COUNT = 9
    
    constant string TARGET_ALLY = "ally"
    constant string TARGET_ENEMY = "enemy"
    constant string TARGET_ALL = "all"
    
    constant integer ID_SHEEP = 'n03N' 
    
    constant string DEATH_AREA = "war3mapImported\\AuraOfDeath.mdx"
    
    boolean DEBUG = false
    unit UNIT_BUFF = null
    
    real array HardModAspd[7]//скорость атаки в модах
endglobals

function Trig_Database_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclAEnd
    
    set udg_perc = "%"
    set udg_Version = "1.4.5n"
    set udg_UntilFirstFight = true
    
    set udg_hash = InitHashtable( )
    set udg_rain = AddWeatherEffect(GetWorldBounds(), 'RAhr')
    
    set UNIT_BUFF = gg_unit_u00F_0006
    call DataItems()
    call DataBoss()
    call DataAbilities()
    call Skins_DataSkins()
    call SetRaritySpawn( 3, 30 )
    call SetAmbientDaySound( "LordaeronSummerDay" )
    set udg_DamageTypeCriticalStrike = 1
    set udg_DamageTypeBlocked = 2
    set udg_real[1] = 180
    set udg_BanLimit = 4
    set udg_Players = GetPlayersByMapControl(MAP_CONTROL_USER)
    call BlzFrameSetVisible(BlzGetFrameByName("ResourceBarFrame", 0), false)
    call SetUnitAnimation( gg_unit_h009_0032, "sleep" )
    call SetUnitAnimation( gg_unit_h009_0033, "sleep" )
    call resethero()
    call VolumeGroupSetVolume( SOUND_VOLUMEGROUP_MUSIC, 0.7 )
    // Caption
    set udg_base = 0
    set udg_Captions[BaseNum()] = "xWizard"
    set udg_Captions[BaseNum()] = "Wtii"
    set udg_Captions[BaseNum()] = "Zolo"
    set udg_Captions[BaseNum()] = "~Rik"
    set udg_Captions[BaseNum()] = "2kxaoc"
    set udg_Captions[BaseNum()] = "Azazelk0"
    set udg_Captions[BaseNum()] = "ZiHeLL"
    set udg_Captions[BaseNum()] = "Ratman"
    set udg_Captions[BaseNum()] = "Sheepy"
    set udg_Captions[BaseNum()] = "Rena"
    set udg_Captions[BaseNum()] = "Eric"
    set udg_Captions[BaseNum()] = "Banderling"
    set udg_Captions[BaseNum()] = "Infoneral"
    set udg_Captions[BaseNum()] = "Glen"
    set udg_Captions[BaseNum()] = "Mike"
    set udg_Captions[BaseNum()] = "Wondershovel"
    set udg_Captions[BaseNum()] = "Leviolon"
    set udg_Captions[BaseNum()] = "vatk0end"
    set udg_Captions[BaseNum()] = "hooka"
    set udg_Captions[BaseNum()] = "Pohx"
    set udg_Captions[BaseNum()] = "mrhans"
    set udg_Captions[BaseNum()] = "faceroll"
    set udg_Captions[BaseNum()] = "Yoti Coyote"
    set udg_Captions[BaseNum()] = "Lichloved"
    set udg_Captions[BaseNum()] = "Poor Kimmo"
    set udg_Captions[BaseNum()] = "stonebludgeon"
    set udg_Captions[BaseNum()] = "SkifterOk"
    
    set udg_DB_Hardest[0] = "Common +0"
    set udg_DB_Hardest[1] = "Rare +1"
    set udg_DB_Hardest[2] = "Epic +2"
    set udg_DB_Hardest[3] = "Legendary +3"
    set udg_DB_Hardest[4] = "Mythical +4"
    set udg_DB_Hardest[5] = "Horrific +5"
    set udg_DB_Hardest[6] = "Monstrous +6"
    set udg_DB_Hardest_On[1] = 'A043'
    set udg_DB_Hardest_On[2] = 'A046'
    set udg_DB_Hardest_On[3] = 'A047'
    set udg_DB_Hardest_On[4] = 'A045'
    set udg_DB_Hardest_On[5] = 'A048'
    set udg_DB_Hardest_On[6] = 'A04H'
    
    set udg_HardModBonus[1] = 'A0CA'
    set udg_HardModBonus[2] = 'A0CG'
    set udg_HardModBonus[3] = 'A05S'
    set udg_HardModBonus[4] = 'A07Q'
    
    set HardModAspd[0]=1.0
    set HardModAspd[1]=1.2
    set HardModAspd[2]=1.4
    set HardModAspd[3]=1.6
    set HardModAspd[4]=1.8
    set HardModAspd[5]=2.
    set HardModAspd[6]=2.2
            
    // Set color
    set udg_DB_AllSet = 9
    set udg_DB_Set_Color[1] = "|cffb18904"
    set udg_DB_Set_Color[2] = "|cff2d9995"
    set udg_DB_Set_Color[3] = "|cff9001fd"
    set udg_DB_Set_Color[4] = "|cffb40431"
    set udg_DB_Set_Color[5] = "|cff848484"
    set udg_DB_Set_Color[6] = "|cff5858fa"
    set udg_DB_Set_Color[7] = "|cff7cfc00"
    set udg_DB_Set_Color[8] = "|cfffe9a2e"
    set udg_DB_Set_Color[9] = "|cff00ccee"
    
    set udg_base = 0
    set udg_DB_Player_Color[BaseNum()] = "|cffff0000"
    set udg_DB_Player_Color[BaseNum()] = "|cff0000ff"
    set udg_DB_Player_Color[BaseNum()] = "|cff40e0d0"
    set udg_DB_Player_Color[BaseNum()] = "|cFF540081"
    set udg_DB_Player_Color[BaseNum()] = "|cFFFFFC01"
    set udg_DB_Player_Color[BaseNum()] = "|cFFFE8A0E"
    set udg_DB_Player_Color[BaseNum()] = "|cFF20C000"
    set udg_DB_Player_Color[BaseNum()] = "|cFFE55BB0"
    set udg_DB_Player_Color[BaseNum()] = "|cFF959697"
    set udg_DB_Player_Color[BaseNum()] = "|cFF7EBFF1"
    set udg_DB_Player_Color[BaseNum()] = "|cFF106246"
    set udg_DB_Player_Color[BaseNum()] = "|cFF4E2A04"
    set udg_DB_Player_Color[BaseNum()] = "|cff9c0000"
    set udg_DB_Player_Color[BaseNum()] = "|cff0000c3"
    set udg_DB_Player_Color[BaseNum()] = "|cff00ebff"
    set udg_DB_Player_Color[BaseNum()] = "|cffbd00ff"
    set udg_DB_Player_Color[BaseNum()] = "|cffecce87"
    set udg_DB_Player_Color[BaseNum()] = "|cfff7a58b"
    set udg_DB_Player_Color[BaseNum()] = "|cffbfff81"
    set udg_DB_Player_Color[BaseNum()] = "|cffdbb8eb"
    set udg_DB_Player_Color[BaseNum()] = "|cff4f5055"
    set udg_DB_Player_Color[BaseNum()] = "|cffecf0ff"
    set udg_DB_Player_Color[BaseNum()] = "|cff00781e"
    set udg_DB_Player_Color[BaseNum()] = "|cffa56f34"
    set udg_DB_AllColors = udg_base

    // Feerverk
    set udg_Database_Feerverk[1] = "Fireworksblue.mdx"
    set udg_Database_Feerverk[2] = "Fireworksred.mdx"
    set udg_Database_Feerverk[3] = "Fireworksgreen.mdx"
    set udg_Database_Feerverk[4] = "Fireworkspurple.mdx"
	// Экзотические существа
    set udg_Database_NumberItems[28] = 5
    set udg_Eczotic[1] = 'n00T'
    set udg_Eczotic[2] = 'n00D'
    set udg_Eczotic[3] = 'n00V'
    set udg_Eczotic[4] = 'n00O'
    set udg_Eczotic[5] = 'u00Z'
    
	// Случайный бонус
    set udg_Database_NumberItems[25] = 20
    set udg_RandomBonus[1] = 'A0NU'
    set udg_RandomBonus[2] = 'A0NO'
    set udg_RandomBonus[3] = 'A0NV'
    set udg_RandomBonus[4] = 'A00O'
    set udg_RandomBonus[5] = 'A00Z'
    set udg_RandomBonus[6] = 'A01B'
    set udg_RandomBonus[7] = 'A01K'
    set udg_RandomBonus[8] = 'A02A'
    set udg_RandomBonus[9] = 'A030'
    set udg_RandomBonus[10] = 'A06X'
    set udg_RandomBonus[11] = 'A070'
    set udg_RandomBonus[12] = 'A074'
    set udg_RandomBonus[13] = 'A095'
    set udg_RandomBonus[14] = 'A0A7'
    set udg_RandomBonus[15] = 'A0B2'
    set udg_RandomBonus[16] = 'A0Y4'
    set udg_RandomBonus[17] = 'A106'
    set udg_RandomBonus[18] = 'A108'
    set udg_RandomBonus[19] = 'A0G2'
    set udg_RandomBonus[20] = 'A0G3'

    set udg_RandomString[1] = "Armor +3"
    set udg_RandomString[2] = "Attack power +12"
    set udg_RandomString[3] = "Stats +2"
    set udg_RandomString[4] = "Health +200"
    set udg_RandomString[5] = "Agility +6"
    set udg_RandomString[6] = "Strength +6"
    set udg_RandomString[7] = "Intelligence +6"
    set udg_RandomString[8] = "Agility and Strength +3"
    set udg_RandomString[9] = "Strength and Intelligence +3"
    set udg_RandomString[10] = "Intelligence and Agility +3"
    set udg_RandomString[11] = "Mana +75"
    set udg_RandomString[12] = "Health regeneration +2"
    set udg_RandomString[13] = "Mana regeneration +75%"
    set udg_RandomString[14] = "Attack speed +12%"
    set udg_RandomString[15] = "Movement speed +40"
    set udg_RandomString[16] = "Spell power +8%"
    set udg_RandomString[17] = "Luck +8"
    set udg_RandomString[18] = "Damage received -4%"
    set udg_RandomString[19] = "Splits free"
    set udg_RandomString[20] = "Buff duration +20%"

    // Icons
    set udg_DB_Hero_Icon[1] = "ReplaceableTextures\\CommandButtons\\BTNBlueDragonSpawn.blp"
    set udg_DB_Hero_Icon[2] = "ReplaceableTextures\\CommandButtons\\BTNEarthBrewmaster.blp"
    set udg_DB_Hero_Icon[3] = "ReplaceableTextures\\CommandButtons\\BTNBandit.blp"
    set udg_DB_Hero_Icon[4] = "ReplaceableTextures\\CommandButtons\\BTNHeadhunter.blp"
    set udg_DB_Hero_Icon[5] = "ReplaceableTextures\\CommandButtons\\BTNLichVersion2.blp"
    set udg_DB_Hero_Icon[6] = "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp"
    set udg_DB_Hero_Icon[7] = "ReplaceableTextures\\CommandButtons\\BTNFurbolgTracker.blp"
    set udg_DB_Hero_Icon[8] = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp"
    set udg_DB_Hero_Icon[9] = "BTNSpell_Shadow_SummonVoidWalker.blp"
    set udg_DB_Hero_Icon[10] = "ReplaceableTextures\\CommandButtons\\BTNDruidOfTheTalon.blp"
    set udg_DB_Hero_Icon[11] = "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp"
    set udg_DB_Hero_Icon[12] = "ReplaceableTextures\\CommandButtons\\BTNHeroCryptLord.blp"
    set udg_DB_Hero_Icon[13] = "ReplaceableTextures\\CommandButtons\\BTNOwlBear.blp"
    set udg_DB_Hero_Icon[14] = "ReplaceableTextures\\CommandButtons\\BTNTauren.blp"
    set udg_DB_Hero_Icon[15] = "ReplaceableTextures\\CommandButtons\\BTNDranaiMage.blp"
    set udg_DB_Hero_Icon[16] = "ReplaceableTextures\\CommandButtons\\BTNHeroAvatarOfFlame.blp"
    set udg_DB_Hero_Icon[17] = "ReplaceableTextures\\CommandButtons\\BTNNagaSummoner.blp"
    set udg_DB_Hero_Icon[18] = "ReplaceableTextures\\CommandButtons\\BTNRifleman.blp"
    set udg_DB_Hero_Icon[19] = "ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp"
    set udg_DB_Hero_Icon[20] = "ReplaceableTextures\\CommandButtons\\BTNForestTrollShadowPriest.blp"
    set udg_DB_Hero_Icon[21] = "ReplaceableTextures\\CommandButtons\\BTNGoblinSapper.blp"
    set udg_DB_Hero_Icon[22] = "ReplaceableTextures\\CommandButtons\\BTNBeastMaster.blp"
    set udg_DB_Hero_Icon[23] = "ReplaceableTextures\\CommandButtons\\BTNMurgulShadowCaster.blp"
    set udg_DB_Hero_Icon[24] = "ReplaceableTextures\\CommandButtons\\BTNPitLord.blp"
    set udg_DB_Hero_Icon[25] = "ReplaceableTextures\\CommandButtons\\BTNSkeletonWarrior.blp"
    set udg_DB_Hero_Icon[26] = "ReplaceableTextures\\CommandButtons\\BTNBansheeRanger.blp"
    set udg_DB_Hero_Icon[27] = "ReplaceableTextures\\CommandButtons\\BTNProudmoore.blp"
    set udg_DB_Hero_Icon[28] = "ReplaceableTextures\\CommandButtons\\BTNHarpyWitch.blp"
    set udg_DB_Hero_Icon[29] = "ReplaceableTextures\\CommandButtons\\BTNNagaMyrmidonRoyalGuard.blp"
    set udg_DB_Hero_Icon[30] = "ReplaceableTextures\\CommandButtons\\BTNWispSplode.blp"
    set udg_DB_Hero_Icon[31] = "ReplaceableTextures\\CommandButtons\\BTNUnbroken.blp"
    set udg_DB_Hero_Icon[32] = "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp"
    set udg_DB_Hero_Icon[33] = "ReplaceableTextures\\CommandButtons\\BTNSatyrTrickster.blp"
    set udg_DB_Hero_Icon[34] = "ReplaceableTextures\\CommandButtons\\BTNTuskaarBlack.blp"
    set udg_DB_Hero_Icon[35] = "ReplaceableTextures\\CommandButtons\\BTNKelThuzad.blp"
    set udg_DB_Hero_Icon[36] = "ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp"
    set udg_DB_Hero_Icon[37] = "ReplaceableTextures\\CommandButtons\\BTNOneHeadedOgre.blp"
    set udg_DB_Hero_Icon[38] = "ReplaceableTextures\\CommandButtons\\BTNDryad.blp"
    set udg_DB_Hero_Icon[39] = "ReplaceableTextures\\CommandButtons\\BTNFootman.blp"
    set udg_DB_Hero_Icon[40] = "war3mapImported\\BTNKingOfGhouls_Icon.blp"
    set udg_DB_Hero_Icon[41] = "ReplaceableTextures\\CommandButtons\\BTNDalaranReject.blp"
    set udg_DB_Hero_Icon[42] = "ReplaceableTextures\\CommandButtons\\BTNVengeanceIncarnate.blp"
    set udg_DB_Hero_Icon[43] = "ReplaceableTextures\\CommandButtons\\BTNYouDirtyRat!.blp"
    set udg_DB_Hero_Icon[44] = "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp"
    set udg_DB_Hero_Icon[45] = "ReplaceableTextures\\CommandButtons\\BTNForgottenOne.blp"
    set udg_DB_Hero_Icon[46] = "ReplaceableTextures\\CommandButtons\\BTNWitchDoctor.blp"
    set udg_DB_Hero_Icon[47] = "ReplaceableTextures\\CommandButtons\\BTNZergling.blp"
    set udg_DB_Hero_Icon[48] = "ReplaceableTextures\\CommandButtons\\BTNSnapDragon.blp"
    set udg_DB_Hero_Icon[49] = "war3mapImported\\BTNHolyMage.blp"
    set udg_DB_Hero_Icon[50] = "ReplaceableTextures\\CommandButtons\\BTNPriest.blp"
    set udg_DB_Hero_Icon[51] = "ReplaceableTextures\\CommandButtons\\BTNAbomination.blp"
    set udg_DB_Hero_Icon[52] = "ReplaceableTextures\\CommandButtons\\BTNShaman.blp"
    set udg_DB_Hero_Icon[53] = "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp"
    set udg_DB_Hero_Icon[54] = "ReplaceableTextures\\CommandButtons\\BTNGreenDragon.blp"
    set udg_DB_Hero_Icon[55] = "ReplaceableTextures\\CommandButtons\\BTNArchimonde.blp"
    set udg_DB_Hero_Icon[56] = "war3mapImported\\BTNSummonWaterElemental.blp"
    set udg_DB_Hero_Icon[57] = "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp"
    set udg_DB_Hero_Icon[58] = "ReplaceableTextures\\CommandButtons\\BTNDestroyer.blp"
    set udg_DB_Hero_Icon[59] = "ReplaceableTextures\\CommandButtons\\BTNMeatWagon.blp"
    set udg_DB_Hero_Icon[60] = "ReplaceableTextures\\CommandButtons\\BTNRevenant.blp"
    set udg_DB_Hero_Icon[61] = "ReplaceableTextures\\CommandButtons\\BTNKeeperGhostBlue.blp"
    set udg_DB_Hero_Icon[62] = "ReplaceableTextures\\CommandButtons\\BTNDragonHawk.blp"
    set udg_DB_Hero_Icon[63] = "ReplaceableTextures\\CommandButtons\\BTNTheCaptain.blp"
    set udg_DB_Hero_Icon[64] = "war3mapImported\\BTNskinvaleera.blp"
    set udg_DB_Hero_Icon[65] = "ReplaceableTextures\\CommandButtons\\BTNScout.blp"
    set udg_DB_Hero_Icon[66] = "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp"
    set udg_DB_Hero_Icon[67] = "ReplaceableTextures\\CommandButtons\\BTNMedivh.blp"
    set udg_DB_Hero_Icon[68] = "war3mapImported\\BTNRifleman_Kul-Tiras_HD_noTC.blp"
    set udg_DB_Hero_Icon[69] = "ReplaceableTextures\\CommandButtons\\BTNInfernal.blp"
    set udg_DB_Hero_Icon[70] = "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp"
    set udg_DB_Hero_Icon[71] = "war3mapImported\\BTNEasterWabbit.blp"
    set udg_DB_Hero_Icon[72] = "ReplaceableTextures\\CommandButtons\\BTNGuldan.blp"
    set udg_DB_Hero_Icon[73] = "ReplaceableTextures\\CommandButtons\\BTNGarithos.blp"
    set udg_DB_Hero_Icon[74] = "ReplaceableTextures\\CommandButtons\\BTNCorruptedEnt.blp"
    set udg_DB_Hero_Icon[75] = "ReplaceableTextures\\CommandButtons\\BTNDruidOfTheClaw.blp"
    set udg_DB_Hero_Icon[76] = "ReplaceableTextures\\CommandButtons\\BTNWindSerpent.blp"
    
    // Триггеры механизмов
    set udg_Database_NumberItems[35] = 12
    set udg_DB_MechUse[1] = gg_trg_Piu_Mashine
    set udg_DB_MechUse[2] = gg_trg_Stim_Injector
    set udg_DB_MechUse[3] = gg_trg_ManaGive
    set udg_DB_MechUse[4] = gg_trg_Autonavigator
    set udg_DB_MechUse[5] = gg_trg_Saronite_Bomb
    set udg_DB_MechUse[6] = gg_trg_Approximatron
    set udg_DB_MechUse[7] = gg_trg_Repeller
    set udg_DB_MechUse[8] = gg_trg_Superbot
    set udg_DB_MechUse[9] = gg_trg_BoomSub
    set udg_DB_MechUse[10] = gg_trg_Jet_Boots
    set udg_DB_MechUse[11] = gg_trg_Ashbringer
    set udg_DB_MechUse[12] = gg_trg_OldHealer
    
    /*set udg_Database_Score_Unit[7] = 'n01A'
    set udg_Database_Score_Unit[8] = 'n01B'
    set udg_Database_Score_Unit[9] = 'n01C'
    set udg_Database_Score_Unit[10] = 'n01D'
    set udg_Database_Score_Unit[11] = 'n01E'
    set udg_Database_Score_Unit[12] = 'n01F'*/
    
    set udg_Database_Score_Item[1] = 'I03A'
    set udg_Database_Score_Item[2] = 'I03C'
    set udg_Database_Score_Item[3] = 'I03B'
    set udg_Database_Score_Item[4] = 'I039'
    set udg_Database_Score_Item[5] = 'I038'
    set udg_Database_Score_Item[6] = 'I037'
    // Существа
    set udg_base = 0
    set udg_Database_RandomUnit[BaseNum()] = 'h00S'
    set udg_Database_RandomUnit[BaseNum()] = 'o00H'
    set udg_Database_RandomUnit[BaseNum()] = 'n01O'
    set udg_Database_RandomUnit[BaseNum()] = 'n003'
    set udg_Database_RandomUnit[BaseNum()] = 'n01N'
    set udg_Database_RandomUnit[BaseNum()] = 'e007'
    set udg_Database_RandomUnit[BaseNum()] = 'h00L'
    set udg_Database_RandomUnit[BaseNum()] = 'o00G'
    set udg_Database_RandomUnit[BaseNum()] = 'o008'
    set udg_Database_RandomUnit[BaseNum()] = 'u00A'
    set udg_Database_RandomUnit[BaseNum()] = 'n012'
    set udg_Database_RandomUnit[BaseNum()] = 'n01Y'
    set udg_Database_RandomUnit[BaseNum()] = 'n006'
    set udg_Database_RandomUnit[BaseNum()] = 'u00B'
    set udg_Database_RandomUnit[BaseNum()] = 'u00C'
    set udg_Database_RandomUnit[BaseNum()] = 'u00D'
    set udg_Database_RandomUnit[BaseNum()] = 'u017'
    set udg_Database_RandomUnit[BaseNum()] = 'u018'
    set udg_Database_RandomUnit[BaseNum()] = 'u019'
    set udg_Database_RandomUnit[BaseNum()] = 'u01C'
    set udg_Database_RandomUnit[BaseNum()] = 'u01D'
    set udg_Database_RandomUnit[BaseNum()] = 'u01E'
    set udg_Database_RandomUnit[BaseNum()] = 'u01F'
    set udg_Database_RandomUnit[BaseNum()] = 'u01A'
    set udg_Database_RandomUnit[BaseNum()] = 'u01B'
    set udg_Database_RandomUnit[BaseNum()] = 'n022'
    set udg_Database_RandomUnit[BaseNum()] = 'n023'
    set udg_Database_RandomUnit[BaseNum()] = 'n024'
    set udg_Database_RandomUnit[BaseNum()] = 'n025'
    set udg_Database_RandomUnit[BaseNum()] = 'n026'
    set udg_Database_RandomUnit[BaseNum()] = 'n027'
    set udg_Database_RandomUnit[BaseNum()] = 'u00H'
    set udg_Database_RandomUnit[BaseNum()] = 'n04D'
    set udg_Database_RandomUnit[BaseNum()] = 'u01I'
    set udg_Database_RandomUnit[BaseNum()] = 'o01B'
    set udg_Database_RandomUnit[BaseNum()] = 'n047'
    set udg_Database_RandomUnit[BaseNum()] = 'u013'
    set udg_Database_RandomUnit[BaseNum()] = 'n02F'
    set udg_Database_RandomUnit[BaseNum()] = 'n00U'
    set udg_Database_RandomUnit[BaseNum()] = 'e00E'
    set udg_Database_RandomUnit[BaseNum()] = 'n02V'
    set udg_Database_RandomUnit[BaseNum()] = 'n02X'
    set udg_Database_RandomUnit[BaseNum()] = 'o00Y'
    set udg_Database_RandomUnit[BaseNum()] = 'h01E'
    set udg_Database_RandomUnit[BaseNum()] = 'n035'
    set udg_Database_RandomUnit[BaseNum()] = 'o00O'
    set udg_Database_RandomUnit[BaseNum()] = 'h00O'
    set udg_Database_RandomUnit[BaseNum()] = 'n036'
    set udg_Database_RandomUnit[BaseNum()] = 'e00I'
    set udg_Database_RandomUnit[BaseNum()] = 'o00P'
    set udg_Database_RandomUnit[BaseNum()] = 'n03F'
    set udg_Database_RandomUnit[BaseNum()] = 'o00V'
    set udg_Database_RandomUnit[BaseNum()] = 'o00W'
    set udg_Database_RandomUnit[BaseNum()] = 'ninf'
    set udg_Database_RandomUnit[BaseNum()] = 'n03Q'
    set udg_Database_RandomUnit[BaseNum()] = 'n03S'
    set udg_Database_RandomUnit[BaseNum()] = 'n03T'
    set udg_Database_RandomUnit[BaseNum()] = 'n03U'
    set udg_Database_RandomUnit[BaseNum()] = 'u007'
    set udg_Database_RandomUnit[BaseNum()] = 'u009'
    set udg_Database_RandomUnit[BaseNum()] = 'u00E'
    set udg_Database_RandomUnit[BaseNum()] = 'u00G'
    set udg_Database_RandomUnit[BaseNum()] = 'u00M'
    set udg_Database_RandomUnit[BaseNum()] = 'u00N'
    set udg_Database_RandomUnit[BaseNum()] = 'u00O'
    set udg_Database_RandomUnit[BaseNum()] = 'u00P'
    set udg_Database_RandomUnit[BaseNum()] = 'u00Q'
    set udg_Database_RandomUnit[BaseNum()] = 'u00R'
    set udg_Database_RandomUnit[BaseNum()] = 'u00S'
    set udg_Database_RandomUnit[BaseNum()] = 'u00V'
    set udg_Database_RandomUnit[BaseNum()] = 'u00W'
    set udg_Database_RandomUnit[BaseNum()] = 'n02Z'
    set udg_Database_RandomUnit[BaseNum()] = 'n037'
    set udg_Database_RandomUnit[BaseNum()] = 'n03H'
    set udg_Database_RandomUnit[BaseNum()] = 'n03W'
    set udg_Database_RandomUnit[BaseNum()] = 'n053'
    set udg_Database_RandomUnit[BaseNum()] = 'o01C'
    set udg_Database_RandomUnit[BaseNum()] = 'o00R'
    set udg_Database_RandomUnit[BaseNum()] = 'n020'
    set udg_Database_RandomUnit[BaseNum()] = 'n02J'
    set udg_Database_NumberItems[5] = udg_base
    // Дриада
    set udg_DryadMinion[1] = 'n02Z'
    set udg_DryadMinion[2] = 'n037'
    set udg_DryadMinion[3] = 'n03H'
    set udg_DryadMinion[4] = 'n03W'
    
    set udg_DryadMinionHP[1] = 25
    set udg_DryadMinionHP[2] = 50
    set udg_DryadMinionHP[3] = 50
    set udg_DryadMinionHP[4] = 100
    
    set udg_DryadMinionAT[1] = 4
    set udg_DryadMinionAT[2] = 6
    set udg_DryadMinionAT[3] = 4
    set udg_DryadMinionAT[4] = 5
    
    // Бесконечная арена
    set udg_Database_NumberItems[33] = 30
    set udg_Database_IA_Unit[1] = 'u00B'
    set udg_Database_IA_Unit[2] = 'u00C'
    set udg_Database_IA_Unit[3] = 'u00D'
    set udg_Database_IA_Unit[4] = 'u017'
    set udg_Database_IA_Unit[5] = 'u018'
    set udg_Database_IA_Unit[6] = 'u019'
    
    set udg_Database_IA_Unit[7] = 'n022'
    set udg_Database_IA_Unit[8] = 'n023'
    set udg_Database_IA_Unit[9] = 'n024'
    set udg_Database_IA_Unit[10] = 'n025'
    set udg_Database_IA_Unit[11] = 'n026'
    set udg_Database_IA_Unit[12] = 'n027'
    
    set udg_Database_IA_Unit[13] = 'u01C'
    set udg_Database_IA_Unit[14] = 'u01D'
    set udg_Database_IA_Unit[15] = 'u01E'
    set udg_Database_IA_Unit[16] = 'u01F'
    set udg_Database_IA_Unit[17] = 'u01A'
    set udg_Database_IA_Unit[18] = 'u01B'
    
    set udg_Database_IA_Unit[19] = 'u009'
    set udg_Database_IA_Unit[20] = 'u00E'
    set udg_Database_IA_Unit[21] = 'u00G'
    set udg_Database_IA_Unit[22] = 'u00M'
    set udg_Database_IA_Unit[23] = 'u00N'
    set udg_Database_IA_Unit[24] = 'u00O'
    
    set udg_Database_IA_Unit[25] = 'u00P'
    set udg_Database_IA_Unit[26] = 'u00Q'
    set udg_Database_IA_Unit[27] = 'u00R'
    set udg_Database_IA_Unit[28] = 'u00S'
    set udg_Database_IA_Unit[29] = 'u00V'
    set udg_Database_IA_Unit[30] = 'u00W'
    
    // Мешок Санты
    set udg_SantaPoint[1] = Location(GetRectCenterX(gg_rct_Bag1), GetRectCenterY(gg_rct_Bag1))
    set udg_SantaPoint[2] = Location(GetRectCenterX(gg_rct_Bag2), GetRectCenterY(gg_rct_Bag2))
    set udg_SantaPoint[3] = Location(GetRectCenterX(gg_rct_Bag3), GetRectCenterY(gg_rct_Bag3))
    set udg_SantaPoint[4] = Location(GetRectCenterX(gg_rct_Bag4), GetRectCenterY(gg_rct_Bag4))
    set udg_SantaPoint[5] = Location(GetRectCenterX(gg_rct_Bag5), GetRectCenterY(gg_rct_Bag5))
    set udg_SantaPoint[6] = Location(GetRectCenterX(gg_rct_Bag6), GetRectCenterY(gg_rct_Bag6))
    set udg_SantaPoint[7] = Location(GetRectCenterX(gg_rct_Bag7), GetRectCenterY(gg_rct_Bag7))
    set udg_SantaPoint[8] = Location(GetRectCenterX(gg_rct_Bag8), GetRectCenterY(gg_rct_Bag8))
    set udg_SantaPoint[9] = Location(GetRectCenterX(gg_rct_Bag9), GetRectCenterY(gg_rct_Bag9))
    set udg_SantaPoint[10] = Location(GetRectCenterX(gg_rct_Bag10), GetRectCenterY(gg_rct_Bag10))
    set udg_SantaPoint[11] = Location(GetRectCenterX(gg_rct_Bag11), GetRectCenterY(gg_rct_Bag11))
    set udg_SantaPoint[12] = Location(GetRectCenterX(gg_rct_Bag12), GetRectCenterY(gg_rct_Bag12))
    // Прочее
	set udg_point[9] = Location(GetRectCenterX(gg_rct_PvPArena1), GetRectCenterY(gg_rct_PvPArena1))
	set udg_point[10] = Location(GetRectCenterX(gg_rct_PvPArena2), GetRectCenterY(gg_rct_PvPArena2))
    set udg_point[14] = Location(GetRectCenterX(gg_rct_ImpSpawn1), GetRectCenterY(gg_rct_ImpSpawn1)) 
    set udg_point[15] = Location(GetRectCenterX(gg_rct_ImpSpawn2), GetRectCenterY(gg_rct_ImpSpawn2))
    set udg_point[16] = Location(GetRectCenterX(gg_rct_ImpSpawn3), GetRectCenterY(gg_rct_ImpSpawn3))
    set udg_point[17] = Location(GetRectCenterX(gg_rct_ImpSpawn4), GetRectCenterY(gg_rct_ImpSpawn4))  
    set udg_point[44] = Location(GetRectCenterX(gg_rct_IA_Portal1), GetRectCenterY(gg_rct_IA_Portal1))
    set udg_point[45] = Location(GetRectCenterX(gg_rct_IA_Portal2), GetRectCenterY(gg_rct_IA_Portal2))
    set udg_point[46] = Location(GetRectCenterX(gg_rct_IA_Portal3), GetRectCenterY(gg_rct_IA_Portal3))
    set udg_point[47] = Location(GetRectCenterX(gg_rct_IA_Portal4), GetRectCenterY(gg_rct_IA_Portal4))
    set udg_string[0] = "|cf0FFFFFF "
    set udg_Boss_Rect = gg_rct_ArenaBoss
    if GetPlayerSlotState(Player(0)) == PLAYER_SLOT_STATE_PLAYING then
        call UnitAddAbility( udg_unit[32], 'A0JI' )
        call UnitAddAbility( udg_unit[32], 'A0JL' )
        call UnitAddAbility( udg_unit[32], 'A0JK' )
        call KillDestructable(gg_dest_LTg1_0180)
        call SetDestructableAnimation(gg_dest_LTg1_0180, "death alternate")
        set udg_Color_Player_Red[1] = 80.00
        set udg_Player_Color[1] = "|cffff0000"
        set udg_unit[5] = gg_unit_h01B_0061
        set udg_unit[11] = gg_unit_n01L_0079
        set udg_unit[18] = gg_unit_h00D_0040
        set udg_artifzone[1] = gg_unit_ncp3_0069
        set udg_point[1] = Location(GetRectCenterX(gg_rct_Artifact1), GetRectCenterY(gg_rct_Artifact1))
        set udg_point[5] = Location(GetRectCenterX(gg_rct_Tphero1), GetRectCenterY(gg_rct_Tphero1))
        set udg_point[18] = Location(GetRectCenterX(gg_rct_ImpArena1), GetRectCenterY(gg_rct_ImpArena1))
        set udg_point[22] = Location(GetRectCenterX(gg_rct_Preparation1), GetRectCenterY(gg_rct_Preparation1))
        set udg_point[26] = Location(GetRectCenterX(gg_rct_HeroSpawn1), GetRectCenterY(gg_rct_HeroSpawn1))
        set udg_point[30] = Location(GetRectCenterX(gg_rct_Tphero1Small), GetRectCenterY(gg_rct_Tphero1Small))
        set udg_itemcentr[1] = Location(GetRectCenterX(gg_rct_ItemSpawn1), GetRectCenterY(gg_rct_ItemSpawn1))
        set udg_itemcentr[2] = Location(GetRectCenterX(gg_rct_ItemSpawn2), GetRectCenterY(gg_rct_ItemSpawn2)) 
        set udg_itemcentr[3] = Location(GetRectCenterX(gg_rct_ItemSpawn3), GetRectCenterY(gg_rct_ItemSpawn3)) 
        set udg_Visible[1] = CreateFogModifierRectBJ( false, Player(0), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn1 )
        set udg_CameraChoose[1] = gg_cam_Choose1
    else
        call RemoveUnit( gg_unit_h00D_0040 )
        call RemoveUnit( gg_unit_n01L_0079 )
        call RemoveUnit( gg_unit_h01B_0061 )
        call RemoveUnit( gg_unit_h01T_0009 )
    endif
    if GetPlayerSlotState(Player(1)) == PLAYER_SLOT_STATE_PLAYING then
        call KillDestructable(gg_dest_LTg1_0394)
        call SetDestructableAnimation(gg_dest_LTg1_0394, "death alternate")
        set udg_Color_Player_Blue[2] = 80.00
        set udg_Player_Color[2] = "|cff0000ff"
        set udg_unit[6] = gg_unit_h01B_0092
        set udg_unit[12] = gg_unit_n01L_0080
        set udg_unit[19] = gg_unit_h00D_0041
        set udg_artifzone[2] = gg_unit_ncp3_0068
        set udg_point[2] = Location(GetRectCenterX(gg_rct_Artifact2), GetRectCenterY(gg_rct_Artifact2))
        set udg_point[6] = Location(GetRectCenterX(gg_rct_Tphero2), GetRectCenterY(gg_rct_Tphero2))
        set udg_point[19] = Location(GetRectCenterX(gg_rct_ImpArena2), GetRectCenterY(gg_rct_ImpArena2))
        set udg_point[23] = Location(GetRectCenterX(gg_rct_Preparation2), GetRectCenterY(gg_rct_Preparation2))
        set udg_point[27] = Location(GetRectCenterX(gg_rct_HeroSpawn2), GetRectCenterY(gg_rct_HeroSpawn2))
        set udg_point[31] = Location(GetRectCenterX(gg_rct_Tphero2Small), GetRectCenterY(gg_rct_Tphero2Small))
        set udg_itemcentr[4] = Location(GetRectCenterX(gg_rct_ItemSpawn4), GetRectCenterY(gg_rct_ItemSpawn4))
        set udg_itemcentr[5] = Location(GetRectCenterX(gg_rct_ItemSpawn5), GetRectCenterY(gg_rct_ItemSpawn5)) 
        set udg_itemcentr[6] = Location(GetRectCenterX(gg_rct_ItemSpawn6), GetRectCenterY(gg_rct_ItemSpawn6))
    	set udg_Visible[2] = CreateFogModifierRectBJ( false, Player(1), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn2 )
    	set udg_CameraChoose[2] = gg_cam_Choose2
    else
        call RemoveUnit( gg_unit_h00D_0041 )
        call RemoveUnit( gg_unit_n01L_0080 )
        call RemoveUnit( gg_unit_h01B_0092 )
	call RemoveUnit( gg_unit_h01T_0016 )
    endif
    if GetPlayerSlotState(Player(2)) == PLAYER_SLOT_STATE_PLAYING then
        call KillDestructable(gg_dest_LTg1_0395)
        call SetDestructableAnimation(gg_dest_LTg1_0395, "death alternate")
        set udg_Color_Player_Green[3] = 70.00
        set udg_Color_Player_Blue[3] = 70.00
        set udg_Player_Color[3] = "|cff40e0d0"
        set udg_unit[7] = gg_unit_h01B_0093
        set udg_unit[13] = gg_unit_n01L_0081
        set udg_unit[20] = gg_unit_h00D_0042
        set udg_artifzone[3] = gg_unit_ncp3_0067
        set udg_point[3] = Location(GetRectCenterX(gg_rct_Artifact3), GetRectCenterY(gg_rct_Artifact3))
        set udg_point[7] = Location(GetRectCenterX(gg_rct_Tphero3), GetRectCenterY(gg_rct_Tphero3))
        set udg_point[20] = Location(GetRectCenterX(gg_rct_ImpArena3), GetRectCenterY(gg_rct_ImpArena3))
        set udg_point[24] = Location(GetRectCenterX(gg_rct_Preparation3), GetRectCenterY(gg_rct_Preparation3))
        set udg_point[28] = Location(GetRectCenterX(gg_rct_HeroSpawn3), GetRectCenterY(gg_rct_HeroSpawn3))
        set udg_point[32] = Location(GetRectCenterX(gg_rct_Tphero3Small), GetRectCenterY(gg_rct_Tphero3Small))
        set udg_itemcentr[7] = Location(GetRectCenterX(gg_rct_ItemSpawn7), GetRectCenterY(gg_rct_ItemSpawn7))
        set udg_itemcentr[8] = Location(GetRectCenterX(gg_rct_ItemSpawn8), GetRectCenterY(gg_rct_ItemSpawn8)) 
        set udg_itemcentr[9] = Location(GetRectCenterX(gg_rct_ItemSpawn9), GetRectCenterY(gg_rct_ItemSpawn9))
    	set udg_Visible[3] = CreateFogModifierRectBJ( false, Player(2), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn3 )
    	set udg_CameraChoose[3] = gg_cam_Choose3
    else
        call RemoveUnit( gg_unit_h00D_0042 )
        call RemoveUnit( gg_unit_n01L_0081 )
        call RemoveUnit( gg_unit_h01B_0093 )
	call RemoveUnit( gg_unit_h01T_0017 )
    endif
    if GetPlayerSlotState(Player(3)) == PLAYER_SLOT_STATE_PLAYING then
        call KillDestructable(gg_dest_LTg1_0396)
        call SetDestructableAnimation(gg_dest_LTg1_0396, "death alternate")
        set udg_Color_Player_Red[4] = 50.00
        set udg_Color_Player_Blue[4] = 80.00
        set udg_Player_Color[4] = "|cff652187"
        set udg_unit[8] = gg_unit_h01B_0094
        set udg_unit[14] = gg_unit_n01L_0082
        set udg_unit[21] = gg_unit_h00D_0007
        set udg_artifzone[4] = gg_unit_ncp3_0064
        set udg_point[4] = Location(GetRectCenterX(gg_rct_Artifact4), GetRectCenterY(gg_rct_Artifact4))
        set udg_point[8] = Location(GetRectCenterX(gg_rct_Tphero4), GetRectCenterY(gg_rct_Tphero4))
        set udg_point[21] = Location(GetRectCenterX(gg_rct_ImpArena4), GetRectCenterY(gg_rct_ImpArena4))
        set udg_point[25] = Location(GetRectCenterX(gg_rct_Preparation4), GetRectCenterY(gg_rct_Preparation4))
        set udg_point[29] = Location(GetRectCenterX(gg_rct_HeroSpawn4), GetRectCenterY(gg_rct_HeroSpawn4))
        set udg_point[33] = Location(GetRectCenterX(gg_rct_Tphero4Small), GetRectCenterY(gg_rct_Tphero4Small))
        set udg_itemcentr[10] = Location(GetRectCenterX(gg_rct_ItemSpawn10), GetRectCenterY(gg_rct_ItemSpawn10))
        set udg_itemcentr[11] = Location(GetRectCenterX(gg_rct_ItemSpawn11), GetRectCenterY(gg_rct_ItemSpawn11)) 
        set udg_itemcentr[12] = Location(GetRectCenterX(gg_rct_ItemSpawn12), GetRectCenterY(gg_rct_ItemSpawn12))
    	set udg_Visible[4] = CreateFogModifierRectBJ( false, Player(3), FOG_OF_WAR_VISIBLE, gg_rct_HeroSpawn4 )
    	set udg_CameraChoose[4] = gg_cam_Choose4
    else
        call RemoveUnit( gg_unit_n01L_0082 )
        call RemoveUnit( gg_unit_n01L_0082 )
        call RemoveUnit( gg_unit_h01B_0094 )
        call RemoveUnit( gg_unit_h00D_0007 )
        call RemoveUnit( gg_unit_h01T_0021 )
    endif
    set udg_SpellDamage[11] = 1
    set udg_Hardest = "Normal"
    set udg_ModName = ""
    call ShowUnit(gg_unit_h01Q_0273, false) 
    
    call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 0.00, 0.00, 33.00, 100.00, 20.00, 30.00, 33.00 )
    call DisplayCineFilter(false)
    call SetMapFlag( MAP_LOCK_ALLIANCE_CHANGES, true )
    call SetMapFlag( MAP_RESOURCE_TRADING_ALLIES_ONLY, true )
    call SetMapFlag( MAP_ALLIANCE_CHANGES_HIDDEN, true )
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12 )
    call SetTimeOfDayScale(0)
    call SetPlayerOnScoreScreen(Player(4), false)
    call SetPlayerOnScoreScreen(Player(10), false)
    call SetPlayerOnScoreScreen(Player(11), false)
    call SetPlayerState( Player(4), PLAYER_STATE_GIVES_BOUNTY, 0)
    call SetPlayerState( Player(10), PLAYER_STATE_GIVES_BOUNTY, 0)
    call SetPlayerState( Player(11), PLAYER_STATE_GIVES_BOUNTY, 0)
    call CreateFogModifierRectBJ( true, Player(4), FOG_OF_WAR_VISIBLE, GetWorldBounds() )
    call CreateFogModifierRectBJ( true, Player(10), FOG_OF_WAR_VISIBLE, GetWorldBounds() )
    call CreateFogModifierRectBJ( true, Player(11), FOG_OF_WAR_VISIBLE, GetWorldBounds() )
    set bj_forLoopAIndex = 1
    loop
        exitwhen bj_forLoopAIndex > 4
        if GetPlayerController(Player(bj_forLoopAIndex - 1)) == MAP_CONTROL_COMPUTER then
            set udg_logic[54] = true
        endif
        if GetPlayerSlotState(Player(bj_forLoopAIndex - 1)) == PLAYER_SLOT_STATE_PLAYING then
            if udg_Host == null then
                set udg_Host = Player(bj_forLoopAIndex - 1)
            endif
            call SetPlayerName( ConvertedPlayer(bj_forLoopAIndex), HeroWords(GetPlayerName( Player( bj_forLoopAIndex - 1 ) ) ) )
            set udg_Heroes_Amount = udg_Heroes_Amount + 1
            set udg_Player_Color_Int[bj_forLoopAIndex] = bj_forLoopAIndex
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Feerverk )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Vision1 )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Vision2 )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Vision3 )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Vision4 )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_VISIBLE, gg_rct_Vision5 )
            call CreateFogModifierRectBJ( true, Player(bj_forLoopAIndex - 1), FOG_OF_WAR_MASKED, gg_rct_LoseVision )
            set udg_HeroSpawn[bj_forLoopAIndex] = CreateUnit( Player(PLAYER_NEUTRAL_PASSIVE), 'u000', GetLocationX(udg_point[25+bj_forLoopAIndex]), GetLocationY(udg_point[25+bj_forLoopAIndex]), bj_UNIT_FACING )
            call CameraSetupApplyForPlayer( true, udg_CameraChoose[bj_forLoopAIndex], Player(bj_forLoopAIndex-1), 0 )
    		call SetCameraTargetControllerNoZForPlayer( Player(bj_forLoopAIndex-1), udg_HeroSpawn[bj_forLoopAIndex], 200.00, -150.00, false )
            set bj_forLoopBIndex = 1
            loop
                exitwhen bj_forLoopBIndex > 4
                if udg_Multiboard_Position[bj_forLoopAIndex] == 0 and udg_Multiboard_Position[bj_forLoopAIndex - 1] != bj_forLoopBIndex and udg_Multiboard_Position[bj_forLoopAIndex - 2] != bj_forLoopBIndex and udg_Multiboard_Position[bj_forLoopAIndex - 3] != bj_forLoopBIndex then
                    set udg_Multiboard_Position[bj_forLoopAIndex] = bj_forLoopBIndex
                endif
                set bj_forLoopBIndex = bj_forLoopBIndex + 1
            endloop
        endif
        set bj_forLoopAIndex = bj_forLoopAIndex + 1
    endloop
    if udg_Heroes_Amount == 1 then
        set udg_logic[54] = true
    endif
    set udg_BossHP = udg_BossHP - ( 0.15 * ( 4 - udg_Heroes_Amount ) ) 
    set udg_BossAT = udg_BossAT - ( 0.1 * ( 4 - udg_Heroes_Amount ) )
    set udg_SpellDamage[0] = udg_SpellDamage[0] - ( 0.1 * ( 4 - udg_Heroes_Amount ) )
endfunction

//===========================================================================
function InitTrig_Database takes nothing returns nothing
    set gg_trg_Database = CreateTrigger(  )
    call TriggerRegisterTimerExpireEvent( gg_trg_Database, udg_StartTimer )
    call TriggerAddAction( gg_trg_Database, function Trig_Database_Actions )
endfunction

