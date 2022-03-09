library HeroesTableDatabase initializer init

    globals
        real Event_DatabaseLoaded
        public constant integer CLASSES = 9
        public constant integer HEROES_IN_COLUMN_MAX = 9
        public integer array HEROES_IN_CLASS[CLASSES]
        public integer array Uniques[CLASSES]
        
        ClassFramehandle array ClassFrame[CLASSES]
        HeroFramehandle array HeroFrame[CLASSES][HEROES_IN_COLUMN_MAX]//Class/Position
    endglobals

    struct ClassFramehandle
        readonly string className
        readonly string icon
        readonly string description
        readonly integer unique
        
        method SetDescription takes string description returns nothing
            set .description = description
        endmethod
        
        static method create takes string className, string icon, integer unique returns ClassFramehandle
            local ClassFramehandle this = ClassFramehandle.allocate()
            
            set .className = className
            set .icon = icon
            set .unique = unique
            return this
        endmethod
    endstruct
    
    globals
        private constant integer ALL_ROLES = 7
        constant integer ROLE_DEFEND = 1
        constant integer ROLE_SUPPORT = 2
        constant integer ROLE_HEAL = 3
        constant integer ROLE_MAGIC_DAMAGE = 4
        constant integer ROLE_PHYSICAL_DAMAGE = 5
        constant integer ROLE_SUMMONER = 6
        constant integer ROLE_CONTROL = 7
    endglobals
    
    struct HeroFramehandle
        readonly integer heroId
        readonly string author
        readonly integer difficulty
        readonly string icon
        readonly integer alternativeUnique = 0
        readonly unit array hero[PLAYERS_LIMIT]
        readonly boolean array role[ALL_ROLES]
        string story = null
        
        method SetAlternativeUnique takes integer alternativeUnique returns nothing
            set .alternativeUnique = alternativeUnique
        endmethod

        method AddRoles takes integer role1, integer role2, integer role3, integer role4 returns nothing
            if role1 > 0 and role1 <= ALL_ROLES then
                set role[role1] = true
            endif
            if role2 > 0 and role2 <= ALL_ROLES then
                set role[role2] = true
            endif
            if role3 > 0 and role3 <= ALL_ROLES then
                set role[role3] = true
            endif
            if role4 > 0 and role4 <= ALL_ROLES then
                set role[role4] = true
            endif
        endmethod
        
        static method create takes integer heroId, string author, integer difficulty, string icon returns HeroFramehandle
            local HeroFramehandle this = HeroFramehandle.allocate()
            
            set .heroId = heroId
            set .author = author
            set .difficulty = difficulty
            set .icon = icon
            
            return this
        endmethod
    endstruct

    private function Database takes nothing returns nothing
        set ClassFrame[0] = ClassFramehandle.create("Encouragers", "ReplaceableTextures\\PassiveButtons\\PASBTNCommand.blp", 'A0GD')
        set ClassFrame[1] = ClassFramehandle.create("Defenders", "ReplaceableTextures\\PassiveButtons\\PASBTNUnholyAura.blp", 'A088')
        set ClassFrame[2] = ClassFramehandle.create("Rippers", "ReplaceableTextures\\PassiveButtons\\PASBTNCleavingAttack.blp", 'A05L')
        set ClassFrame[3] = ClassFramehandle.create("Hybrids", "ReplaceableTextures\\PassiveButtons\\PASBTNEvasion.blp", 'A05Y')
        set ClassFrame[4] = ClassFramehandle.create("Marauders", "ReplaceableTextures\\PassiveButtons\\PASBTNPillage.blp", 'A0GA')
        set ClassFrame[5] = ClassFramehandle.create("Killers", "ReplaceableTextures\\PassiveButtons\\PASBTNCriticalStrike.blp", 'A0GB')
        set ClassFrame[6] = ClassFramehandle.create("Elementalists", "ReplaceableTextures\\PassiveButtons\\PASBTNThickFur.blp", 'A0GC')
        set ClassFrame[7] = ClassFramehandle.create("Healers", "ReplaceableTextures\\PassiveButtons\\PASBTNMagicImmunity.blp", 'A0AG')
        set ClassFrame[8] = ClassFramehandle.create("Weakenings", "ReplaceableTextures\\PassiveButtons\\PASBTNFrost.blp", 'A0GF')
        
        call ClassFrame[0].SetDescription("Encouragers - powerful warriors that strengthen their allies.|n|n|cffffcc00Main stat:|r |cffff3300Strength|r|n|cff00cc00- Health: +100.|n- Mana: +100.|r|n|cffff3300- Attack speed: -10%.|r")
        call ClassFrame[1].SetDescription("Defenders - strong warriors defending their allies.|n|n|cffffcc00- Main stat:|r |cffff3300Strength|r|n|cff00cc00- Health: +400.|n- Armor: +2.|r|n|cffff3300- Movement speed: -30.|n- Attack speed: -20%.|r")
        call ClassFrame[2].SetDescription("Rippers - skillful killers of stupid, inept and worthless minions.|n|n|cffffcc00- Main stat:|r |cffff3300Strength|r|n|cff00cc00- Attack speed: + 10%.|n- Attack power: +5.|r|n|cffff3300- Mana: -50.|r")
        call ClassFrame[3].SetDescription("Hybrids - special type of heroes that combine many types of heroes.|n|n|cffffcc00- Main stat:|r |cff00cc00Agility|r|n|cff00cc00- Do not have positive and negative effects.|r")
        call ClassFrame[4].SetDescription("Marauders - skillful dodgers who find gold in the most unexpected places.|n|n|cffffcc00- Main stat:|r |cff00cc00Agility|r|n|cff00cc00- Attack speed: +20%|r|n|cffff3300- Movement speed: -30.|r")
        call ClassFrame[5].SetDescription("Assassins - professional boss destroyers.|n|n|cffffcc00- Main stat:|r |cff00cc00Agility|r|n|cff00cc00- Attack power: +10.|r|n|cffff3300- Health: -100.|n- Armor: -2.|r")
        call ClassFrame[6].SetDescription("Elementalists - powerful magicians who use different powers.|n|n|cffffcc00- Main stat:|r |cff0099FFIntelligence|r|n|cff00cc00- Mana: +50.|n- Mana regeneration: +1.|n- Spell power: +10%.|r|n|cffff3300- Health: -50.|n- Attack speed: -10%.|n- Armor: - 1.|r")
        call ClassFrame[7].SetDescription("Healers - wizards who use their magic to support allies.|n|n|cffffcc00- Main stat:|r |cff0099FFIntelligence|r|n|cff00cc00- Health: +75.|n- Mana: +150.|r|n|cffff3300- Attack Speed: -20%.|n- Attack Power: -10. |r")
        call ClassFrame[8].SetDescription("Weakers - special type of mage that weakens enemies with their spells.|n|n|cffffcc00- Main stat:|r |cff0099FFIntelligence|r|n|cff00cc00- Mana: +150.|n- Movement speed: +30.|r|n|cffff3300- Health: -100.|r")
    
        //Uniques
        set Uniques[0] = 'A0GD'
        set Uniques[1] = 'A088'
        set Uniques[2] = 'A05L'
        set Uniques[3] = 'A0MW'
        set Uniques[4] = 'A0GA'
        set Uniques[5] = 'A0GB'
        set Uniques[6] = 'A0GC'
        set Uniques[7] = 'A0AG'
        set Uniques[8] = 'A0GF'
    
        //Random hero
        set HeroFrame[9][0] = HeroFramehandle.create('u002', "", 0, "" )
        
        // Buffers
        set HEROES_IN_CLASS[0] = 8
        set HeroFrame[0][0] = HeroFramehandle.create('O00S', "pashtet", 0, "ReplaceableTextures\\CommandButtons\\BTNNagaMyrmidonRoyalGuard.blp" )
        set HeroFrame[0][1] = HeroFramehandle.create('O00L', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNPitLord.blp" )
        set HeroFrame[0][2] = HeroFramehandle.create('O010', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNTuskaarBlack.blp" )
        set HeroFrame[0][3] = HeroFramehandle.create('N054', "faceroll", 1, "ReplaceableTextures\\CommandButtons\\BTNDragonHawk.blp" )
        set HeroFrame[0][4] = HeroFramehandle.create('N05A', "SkifterOk", 1, "ReplaceableTextures\\CommandButtons\\BTNScout.blp" )
        set HeroFrame[0][5] = HeroFramehandle.create('N02H', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNMedivh.blp" )
        set HeroFrame[0][6] = HeroFramehandle.create('O00C', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNBlueDragonSpawn.blp" )
        set HeroFrame[0][7] = HeroFramehandle.create('O00S', "Sheepy", 2, "war3mapImported\\BTNHolyMage.blp" )
        
        set HeroFrame[0][0].story = "A seafarer who escaped from Atlantis. He was hunted by other nagas and they could not cope with him."
        set HeroFrame[0][1].story = "Warrior of the infernal wastelands."
        set HeroFrame[0][2].story = "An experienced Tuskar roaming the world in search of curious artifacts."
        set HeroFrame[0][3].story = "Tiberius's first memory is opening his eyes and seeing a Dragon Hawk dangling a mangled sheep over him. He remembers eating with the baby Dragon Hawks, raised as one of them. Tiberius' first years in nature hunting and living with his pack of Dragon Hawks has attuned him to the Sun, his god which he communes with every day. In return, he has been granted a great power - he spends the next 20 years in mastering the power, and now soars the sky looking to recruit an army for the Sun, their purpose unknown."
        set HeroFrame[0][4].story = "In his youth, Soren loved to hear stories of mysterious Guardians of Ga'Hoole - legendary group of owls and owe their life to fight to protect their fellow Guardians, as well as innocent owls throughout the world. And after being snatched by St Aggie's, those legends were everything that he could hope for. Who would've thought, that after seizing his one and only chance to escape, after travelling seemingly to nowhere, he will not only find the Great Tree itself, but also find out, that legends were true. Guardians were true. And moreover, now he is the part of the legends. But not even Soren could dream of becoming a leader of the elite group of the Guardians - Chaw of Chaws. And even less so - became the King of the Great Ga'Hoole Tree."
        set HeroFrame[0][5].story = "It is unknown where did Zote come from, nor where does his destination lie. A man of immense wits and intelligence, he saw the history of the world being written with his very own eyes. \"Pulvis et umbra sumus\" - was all he told me."
        set HeroFrame[0][6].story = "Valiant protector of dragons."
        
        call HeroFrame[0][0].AddRoles(ROLE_SUPPORT, ROLE_PHYSICAL_DAMAGE, 0, 0)
        call HeroFrame[0][1].AddRoles(ROLE_SUPPORT, ROLE_PHYSICAL_DAMAGE, ROLE_DEFEND, ROLE_CONTROL)
        call HeroFrame[0][2].AddRoles(ROLE_SUPPORT, ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0)
        call HeroFrame[0][3].AddRoles(ROLE_SUPPORT, ROLE_HEAL, ROLE_MAGIC_DAMAGE, 0)
        call HeroFrame[0][4].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[0][5].AddRoles(ROLE_SUPPORT, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[0][6].AddRoles(ROLE_SUPPORT, ROLE_PHYSICAL_DAMAGE, 0, 0)
        call HeroFrame[0][7].AddRoles(ROLE_SUPPORT, ROLE_HEAL, 0, 0)

        // Deffenders
        set HEROES_IN_CLASS[1] = 9
        set HeroFrame[1][0] = HeroFramehandle.create('N000', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNFurbolgTracker.blp" )
        set HeroFrame[1][1] = HeroFramehandle.create('N055', "faceroll", 0, "ReplaceableTextures\\CommandButtons\\BTNTheCaptain.blp" )
        set HeroFrame[1][2] = HeroFramehandle.create('N01Q', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNTauren.blp" )
        set HeroFrame[1][3] = HeroFramehandle.create('N04C', "Rena", 1, "ReplaceableTextures\\CommandButtons\\BTNSnapDragon.blp" )  
        set HeroFrame[1][4] = HeroFramehandle.create('N04J', "Mike", 1, "ReplaceableTextures\\CommandButtons\\BTNGreenDragon.blp" )
        set HeroFrame[1][5] = HeroFramehandle.create('N02O', "Yoti Coyote", 1, "ReplaceableTextures\\CommandButtons\\BTNInfernal.blp" )
        set HeroFrame[1][6] = HeroFramehandle.create('H01A', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNSkeletonWarrior.blp" )
        set HeroFrame[1][7] = HeroFramehandle.create('N01P', "Sheepy", 2, "ReplaceableTextures\\CommandButtons\\BTNHeroCryptLord.blp" )
        set HeroFrame[1][8] = HeroFramehandle.create('H01U', "Sheepy", 2, "ReplaceableTextures\\CommandButtons\\BTNDalaranReject.blp" )

        set HeroFrame[1][0].story = "Beorn from his tribe."
        set HeroFrame[1][1].story = "Galvan was a blacksmith's child before he enlisted in the local militia. He learned not only how to forge strong weapons, but to use them effectively. He's on a quest to obtain and learn how to use every weapon in the world."
        set HeroFrame[1][2].story = "Minos is an old minotaur that lives in a swamp labyrinth. One day, the swamp was infected with corruption, which drove all its inhabitants crazy. Minos had to leave the swamp to save his life. A few months later, he was offered to participate in the arena in exchange for saving the swamp. Having agreed to the terms of the contract, the minotaur fights furiously in the arena for a personal goal."
        set HeroFrame[1][3].story = "From the murky depths comes an agile and tough aquatic creature ready to absolutely thrash and exhaust prey before inevitably devouring it. However those that manage to survive its initial assault will soon discover that it has the power to command the origin pulse, power of water magic. Local hunters speculate that its an avatar, while others believe it had gained powers after eating a proper water mage, one thing is for certain though. It loves the taste of prawns and anything that bleeds."
        set HeroFrame[1][6].story = "An undead Scourge soldier."
        set HeroFrame[1][7].story = "A king searching for his lost kingdom."

        call HeroFrame[1][0].AddRoles(ROLE_DEFEND, ROLE_CONTROL, 0, 0)
        call HeroFrame[1][1].AddRoles(ROLE_DEFEND, ROLE_PHYSICAL_DAMAGE, 0, 0)
        call HeroFrame[1][2].AddRoles(ROLE_DEFEND, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[1][3].AddRoles(ROLE_DEFEND, ROLE_SUPPORT, 0, 0)
        call HeroFrame[1][4].AddRoles(ROLE_DEFEND, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[1][5].AddRoles(ROLE_DEFEND, ROLE_SUMMONER, 0, 0)
        call HeroFrame[1][6].AddRoles(ROLE_DEFEND, ROLE_CONTROL, 0, 0)
        call HeroFrame[1][7].AddRoles(ROLE_DEFEND, ROLE_CONTROL, 0, 0)
        call HeroFrame[1][8].AddRoles(ROLE_DEFEND, ROLE_SUMMONER, 0, 0)
        
        // Reapers
        set HEROES_IN_CLASS[2] = 8
        set HeroFrame[2][0] = HeroFramehandle.create('N00N', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp" )
        set HeroFrame[2][1] = HeroFramehandle.create('N02R', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNBeastMaster.blp" )
        set HeroFrame[2][2] = HeroFramehandle.create('N04B', "Rena", 0, "ReplaceableTextures\\CommandButtons\\BTNZergling.blp" )
        set HeroFrame[2][3] = HeroFramehandle.create('N04C', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp" )  
        set HeroFrame[2][4] = HeroFramehandle.create('N014', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNGarithos.blp" )
        set HeroFrame[2][5] = HeroFramehandle.create('N00X', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNOneHeadedOgre.blp" )
        set HeroFrame[2][6] = HeroFramehandle.create('N04I', "ZiHeLL", 2, "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp" )
        set HeroFrame[2][7] = HeroFramehandle.create('N03P', "ZiHeLL", 2, "ReplaceableTextures\\CommandButtons\\BTNDruidOfTheClaw.blp" )
        
        set HeroFrame[2][0].story = "Noble Lord, at least in his realm."
        set HeroFrame[2][1].story = "A fierce warrior who wants to fight in the arena."
        set HeroFrame[2][2].story = "Chaos is rampant in these lands and with constant chaos came horrific creatures from other realms, bleeding into our own reality. Acrid however just loves to act like a dog, chasing things smaller than it, playing fetch and being protective of those it cares for with complete ignorance to the fact its acid might harm those that aren't immune to it. Acrid's innocent nature just means there's much worse out there... in the great beyond."
        set HeroFrame[2][3].story = "Dio is a great vampire who previously lived in Enedaria. He withered many of the citizens of the city, for which he was recognized as a dangerous threat to the city. However, he was defeated by a certain \"Beer Fighter\" and imprisoned in the arena, in which he is obliged to fight forever."
        set HeroFrame[2][4].story = "Did nothing wrong."
        set HeroFrame[2][6].story = "No one knows why Kayn became on Outcast in the first place, but he is definitely seeking vengeance now. His powers exceed limits of any mortal, but the Demon never really abuses them in the first place."
        set HeroFrame[2][7].story = "The Atero bloodline is known for the works of many infamous druids, Furrih being one of them. He got struck with lycanthropy in his youth, which changed his life completely. Now he is a valuable warrior on the Arena, as Furrih is both known for his physical power of a lycan and magical abilities of a druid. "
        
        call HeroFrame[2][0].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[2][1].AddRoles(ROLE_PHYSICAL_DAMAGE, 0, 0, 0)
        call HeroFrame[2][2].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[2][3].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, ROLE_DEFEND, 0)
        call HeroFrame[2][4].AddRoles(ROLE_PHYSICAL_DAMAGE, 0, 0, 0)
        call HeroFrame[2][5].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_CONTROL, 0, 0)
        call HeroFrame[2][6].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[2][7].AddRoles(ROLE_PHYSICAL_DAMAGE, 0, 0, 0)
        
        // Hibryds
        set HEROES_IN_CLASS[3] = 9
        set HeroFrame[3][0] = HeroFramehandle.create('O00E', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNEarthBrewmaster.blp" )
        set HeroFrame[3][1] = HeroFramehandle.create('O00I', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNHeadhunter.blp" )
        set HeroFrame[3][2] = HeroFramehandle.create('O00Z', "LightBeam", 1, "ReplaceableTextures\\CommandButtons\\BTNDryad.blp" )
        set HeroFrame[3][3] = HeroFramehandle.create('O00N', "ZiHeLL", 1, "war3mapImported\\BTNSummonWaterElemental.blp" )  
        set HeroFrame[3][4] = HeroFramehandle.create('O017', "Eric", 1, "ReplaceableTextures\\CommandButtons\\BTNWitchDoctor.blp" )
        set HeroFrame[3][5] = HeroFramehandle.create('O01N', "faceroll and ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp" )
        set HeroFrame[3][6] = HeroFramehandle.create('U00T', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNHeroLich.blp" )
        set HeroFrame[3][7] = HeroFramehandle.create('O00T', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNUnbroken.blp" )
        set HeroFrame[3][8] = HeroFramehandle.create('O01O', "ZiHeLL", 2, "war3mapImported\\BTNEasterWabbit.blp" )
        
        set HeroFrame[3][0].story = "Cho is a peppy beer monk who wanders the world in search of new types of drinks. His life is full of fun and travel. Due to his martial arts skills, he was nicknamed the \"Beer Fighter\"."
        set HeroFrame[3][1].story = "Brave troll breeder. Summons a pet to help him fight by his side."
        set HeroFrame[3][3].story = "Created by collective effort of greatest Mages and Alchemists, Lye is abnormally destructive mindless doll. He is almost a disaster in his magical body, poisoning lives and disrupting not only physical, but even mental health of those who appear nearby."
        set HeroFrame[3][4].story = "Once, Erks tribes homelands were bound in great arcane mysteries, teeming with magic which sought manipulatable hosts. Slowly it seeped into his tribe and loved ones, irreparably blackening their thoughts and dreams. Before Erk was fully enveloped, he was able to break out and ran wherever he could. Although free, the magic still lingers within - swarming the mind with entropic visions of hate. Erk believes however, he could potentially harness this magic to help others where he once could not."
        set HeroFrame[3][5].story = "A child of noble birth, educated at esteemed schools. He began poetry at 19, and after gaining worldwide fame as one of the best minstrels in the Northern Kingdoms he is approached by a mysterious man. After some time together, the man bestows a power upon Jaskier which allows him to sew magic into his poems."
        set HeroFrame[3][6].story = "A resurrected who is able to turn your opponent into your ally."
        set HeroFrame[3][7].story = "A faceless lord who does whatever he pleases."
        set HeroFrame[3][8].story = "Bonnie and Bor Rise and real bros. They rarely brawl, but more rarely win. Never are bored and they rest undisturbed. Don't tolerate robbery and less so for snobbery. They break all the eggs and wear some rags. Bravo, i guess."
        
        call HeroFrame[3][0].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_HEAL, 0, 0)
        call HeroFrame[3][1].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_SUMMONER, 0, 0)
        call HeroFrame[3][2].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_SUMMONER, ROLE_SUPPORT, 0)
        call HeroFrame[3][3].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, ROLE_HEAL, 0)
        call HeroFrame[3][4].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_HEAL, 0, 0)
        call HeroFrame[3][5].AddRoles(ROLE_SUPPORT, ROLE_HEAL, 0, 0)
        call HeroFrame[3][6].AddRoles(ROLE_SUMMONER, 0, 0, 0)
        call HeroFrame[3][7].AddRoles(ROLE_DEFEND, ROLE_MAGIC_DAMAGE, ROLE_PHYSICAL_DAMAGE, ROLE_HEAL)
        call HeroFrame[3][8].AddRoles(ROLE_SUMMONER, ROLE_MAGIC_DAMAGE, ROLE_CONTROL, 0)
        
        call HeroFrame[3][0].SetAlternativeUnique('A0IJ')
        call HeroFrame[3][1].SetAlternativeUnique('A0MW')
        call HeroFrame[3][2].SetAlternativeUnique('A0JJ')
        call HeroFrame[3][3].SetAlternativeUnique('A0FS')
        call HeroFrame[3][4].SetAlternativeUnique('A13G')
        call HeroFrame[3][5].SetAlternativeUnique('A0CR')
        call HeroFrame[3][6].SetAlternativeUnique('A0IP')
        call HeroFrame[3][7].SetAlternativeUnique('A0IS')
        call HeroFrame[3][8].SetAlternativeUnique('A1BD')
        
        // Marauders
        set HEROES_IN_CLASS[4] = 8
        set HeroFrame[4][0] = HeroFramehandle.create('O00J', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNForestTrollShadowPriest.blp" )
        set HeroFrame[4][1] = HeroFramehandle.create('O00B', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNBandit.blp" )
        set HeroFrame[4][2] = HeroFramehandle.create('O015', "Infoneral", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp" )
        set HeroFrame[4][3] = HeroFramehandle.create('O01A', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp" )
        set HeroFrame[4][4] = HeroFramehandle.create('O01L', "Lichloved", 1, "ReplaceableTextures\\CommandButtons\\BTNKeeperGhostBlue.blp" )
        set HeroFrame[4][5] = HeroFramehandle.create('O00Q', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNProudmoore.blp" )
        set HeroFrame[4][6] = HeroFramehandle.create('O019', "Mike", 2, "ReplaceableTextures\\CommandButtons\\BTNAbomination.blp" )
        set HeroFrame[4][7] = HeroFramehandle.create('O01I', "Yoti Coyote", 2, "ReplaceableTextures\\CommandButtons\\BTNMeatWagon.blp" )
        
        set HeroFrame[4][0].story = "A troll healer who left his tribe long ago."
        set HeroFrame[4][1].story = "A brave pirate who is looking for unheard of treasures."
        set HeroFrame[4][3].story = "Drawzi is an expert banana dealer, and sees a great profit available on the way. His methods are questionable at best, but no one ever complained about the quality of the product, yet. He is able to pick up new tricks and strategies on go from others, all in the name of friendship and tax fraud."
        set HeroFrame[4][5].story = "Crusoe is a seasoned ship captain who paid the price for his greed. After the crash of his personal ship in a fight with pirates, he made a deal with a certain pharmaceutical company, which promised him an amnesty in exchange for collecting unusual components from around the world. Now the admiral has gone to the arena, as he has learned that there may be many valuable artifacts for him and his employers."
        
        call HeroFrame[4][0].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[4][1].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_SUPPORT, 0, 0)
        call HeroFrame[4][2].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_SUMMONER, 0, 0)
        call HeroFrame[4][3].AddRoles(ROLE_DEFEND, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[4][4].AddRoles(ROLE_SUPPORT, ROLE_SUMMONER, ROLE_MAGIC_DAMAGE, 0)
        call HeroFrame[4][5].AddRoles(ROLE_SUPPORT, ROLE_HEAL, ROLE_PHYSICAL_DAMAGE, 0)
        call HeroFrame[4][6].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_DEFEND, 0, 0)
        call HeroFrame[4][7].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        
        // Killers
        set HEROES_IN_CLASS[5] = 9
        set HeroFrame[5][0] = HeroFramehandle.create('N004', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNNagaSummoner.blp" )
        set HeroFrame[5][1] = HeroFramehandle.create('N019', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp" )
        set HeroFrame[5][2] = HeroFramehandle.create('N02K', "VAT01", 0, "war3mapImported\\BTNRifleman_Kul-Tiras_HD_noTC.blp" )
        set HeroFrame[5][3] = HeroFramehandle.create('N057', "stonebludgeon", 0, "war3mapImported\\BTNskinvaleera.blp" )  
        set HeroFrame[5][4] = HeroFramehandle.create('N02E', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNRifleman.blp" )
        set HeroFrame[5][5] = HeroFramehandle.create('N04M', "vatk0end", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp" )
        set HeroFrame[5][6] = HeroFramehandle.create('N02G', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp" )
        set HeroFrame[5][7] = HeroFramehandle.create('N032', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNBansheeRanger.blp" )
        set HeroFrame[5][8] = HeroFramehandle.create('N04K', "Leviolon", 2, "ReplaceableTextures\\CommandButtons\\BTNArchimonde.blp" )

        set HeroFrame[5][0].story = "A royal mermaid who came to fight."
        set HeroFrame[5][1].story = "An old blademaster who is trying to find a worthy death in combat."
        set HeroFrame[5][4].story = "Crazymeister is an elderly old man from a quiet village. He went on a journey to improve his rifle, which he affectionately calls \"Mary Sue\". Rumor has it that the old man went crazy, but no one has ever said the exact statements."
        set HeroFrame[5][6].story = "Meow meow mew meow meow. Meow, meow meew meow! Meow. Meow mew meoowwww."
        set HeroFrame[5][7].story = "A mysterious elf who came from the world of shadows."

        call HeroFrame[5][0].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[5][1].AddRoles(ROLE_PHYSICAL_DAMAGE, 0, 0, 0)
        call HeroFrame[5][2].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[5][3].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[5][4].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_HEAL, ROLE_PHYSICAL_DAMAGE, 0)
        call HeroFrame[5][5].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[5][6].AddRoles(ROLE_SUMMONER, ROLE_PHYSICAL_DAMAGE, 0, 0)
        call HeroFrame[5][7].AddRoles(ROLE_PHYSICAL_DAMAGE, ROLE_SUPPORT, 0, 0 )
        call HeroFrame[5][8].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)

        // Elementalists
        set HEROES_IN_CLASS[6] = 8
        set HeroFrame[6][0] = HeroFramehandle.create('N039', "VAT01", 0, "ReplaceableTextures\\CommandButtons\\BTNWispSplode.blp" )
        set HeroFrame[6][1] = HeroFramehandle.create('N04H', "Wondershovel", 0, "ReplaceableTextures\\CommandButtons\\BTNShaman.blp" )
        set HeroFrame[6][2] = HeroFramehandle.create('N02P', "Cotya_Ra", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroAvatarOfFlame.blp" )
        set HeroFrame[6][3] = HeroFramehandle.create('N046', "Sheepy", 1, "ReplaceableTextures\\CommandButtons\\BTNFootman.blp" )
        set HeroFrame[6][4] = HeroFramehandle.create('N02T', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNGuldan.blp" )
        set HeroFrame[6][5] = HeroFramehandle.create('N049', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNVengeanceIncarnate.blp" )
        set HeroFrame[6][6] = HeroFramehandle.create('N001', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNOwlBear.blp" )
        set HeroFrame[6][7] = HeroFramehandle.create('N00Y', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp" )
        
        set HeroFrame[6][0].story = "An energy ball consisting of lightning and energy."
        set HeroFrame[6][2].story = "An ancient lord who wishes to kindle the \"First Flame\"."
        set HeroFrame[6][4].story = "Van always dreamed about starting a cult of his own. His twisted ideals led to him becoming a warlock, but he knew that was not the way of gaining support in the masses. Using the newly acquired powers in the strangest manners imaginable, he soon became a great healer as well, but could never overcome his sadistic nature."
        set HeroFrame[6][5].story = "Shaderosia was formed out of the Abyss Matter itself. It has no goal other than slowly devastating, decimating and, eventually, devouring everything on its way. Erasing bosses is not her true intention, but Shaderosia wouldn’t mind doing it regardless."
        set HeroFrame[6][6].story = "A moonkin with arcane spells."
        set HeroFrame[6][7].story = "No one knows for sure where, how and why time exists, but many believe that Tempus is involved in the events of the creation of the World. Little is known about Tempus, but what is known about him only raises new questions. It is known that this mysterious traveler arrived at the arena to get rid of a temporary anomaly that occurred in these parts."
        
        call HeroFrame[6][0].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[6][1].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[6][2].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[6][3].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_PHYSICAL_DAMAGE, ROLE_SUMMONER, ROLE_DEFEND)
        call HeroFrame[6][4].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_HEAL, 0, 0)
        call HeroFrame[6][5].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[6][6].AddRoles(ROLE_MAGIC_DAMAGE, 0, 0, 0)
        call HeroFrame[6][7].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_PHYSICAL_DAMAGE, 0, 0)
        
        // Healers
        set HEROES_IN_CLASS[7] = 9
        set HeroFrame[7][0] = HeroFramehandle.create('N002', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNDruidOfTheTalon.blp" )
        set HeroFrame[7][1] = HeroFramehandle.create('N02S', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNMurgulShadowCaster.blp" )
        set HeroFrame[7][2] = HeroFramehandle.create('N01M', "Cotya_Ra", 1, "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp" )
        set HeroFrame[7][3] = HeroFramehandle.create('N02Q', "Varcklen", 1, "ReplaceableTextures\\CommandButtons\\BTNDranaiMage.blp" ) 
        set HeroFrame[7][4] = HeroFramehandle.create('N04A', "Ratman", 1, "ReplaceableTextures\\CommandButtons\\BTNYouDirtyRat!.blp" )
        set HeroFrame[7][5] = HeroFramehandle.create('N017', "faceroll", 1, "ReplaceableTextures\\CommandButtons\\BTNCorruptedEnt.blp" )
        set HeroFrame[7][6] = HeroFramehandle.create('N038', "Varcklen", 2, "ReplaceableTextures\\CommandButtons\\BTNHarpyWitch.blp" )
        set HeroFrame[7][7] = HeroFramehandle.create('N01R', "regint", 2, "ReplaceableTextures\\CommandButtons\\BTNKelThuzad.blp" )
        set HeroFrame[7][8] = HeroFramehandle.create('N04W', "Yoti Coyote", 2, "ReplaceableTextures\\CommandButtons\\BTNDestroyer.blp" )

        set HeroFrame[7][0].story = "Since childhood, Bob has loved to enjoy his parents' garden in Nordel. When Bob was strong enough, he left his hometown to become a druid. However, by the end of his training, his hometown was struck by an unknown corruption. Upon learning of this, this young druid decided to figure out how to get rid of this disease. He learned that if he went to the arena, he could find answers."
        set HeroFrame[7][1].story = "Experienced medicine fishman of the drained murloc tribe."
        set HeroFrame[7][2].story = "A vain paladin who was banished from the shrine."
        set HeroFrame[7][3].story = "A sage who came from a parallel universe."
        set HeroFrame[7][5].story = "A beech sapling that spent several years at the base of a factory that manufactures chemicals, warped over time by corruption and eventually grew sentience. The tree uprooted itself and left to wander the earth aimlessly. Beechbone encountered many situations that changed his perspective on man, and so he avoids them and dislikes them. He prefers to use his healing powers on animals and other flora and fauna."
        set HeroFrame[7][6].story = "A legendary harpy that was captured by a hunter and sold into the arena to please the public."

        call HeroFrame[7][0].AddRoles(ROLE_HEAL, ROLE_SUMMONER, 0, 0)
        call HeroFrame[7][1].AddRoles(ROLE_HEAL, 0, 0, 0)
        call HeroFrame[7][2].AddRoles(ROLE_HEAL, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[7][3].AddRoles(ROLE_HEAL, ROLE_SUPPORT, 0, 0)
        call HeroFrame[7][4].AddRoles(ROLE_HEAL, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[7][5].AddRoles(ROLE_HEAL, ROLE_MAGIC_DAMAGE, 0, 0)
        call HeroFrame[7][6].AddRoles(ROLE_HEAL, ROLE_SUPPORT, 0, 0)
        call HeroFrame[7][7].AddRoles(ROLE_HEAL, ROLE_SUPPORT, 0, 0 )
        call HeroFrame[7][8].AddRoles(ROLE_HEAL, ROLE_MAGIC_DAMAGE, 0, 0)
        
        // Curses
        set HEROES_IN_CLASS[8] = 8
        set HeroFrame[8][0] = HeroFramehandle.create('O00K', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNHeroTinker.blp" )
        set HeroFrame[8][1] = HeroFramehandle.create('O00X', "Varcklen", 0, "ReplaceableTextures\\CommandButtons\\BTNSatyrTrickster.blp" )
        set HeroFrame[8][2] = HeroFramehandle.create('O01Y', "Rena", 0, "ReplaceableTextures\\CommandButtons\\BTNWindSerpent.blp" )
        set HeroFrame[8][3] = HeroFramehandle.create('O018', "ZiHeLL", 1, "ReplaceableTextures\\CommandButtons\\BTNPriest.blp" )
        set HeroFrame[8][4] = HeroFramehandle.create('O01J', "Lichloved", 1, "ReplaceableTextures\\CommandButtons\\BTNRevenant.blp" )
        set HeroFrame[8][5] = HeroFramehandle.create('O014', "Shkolion and h3ts", 1, "war3mapImported\\BTNKingOfGhouls_Icon.blp" )
        set HeroFrame[8][6] = HeroFramehandle.create('O00D', "Varcklen", 2, "BTNSpell_Shadow_SummonVoidWalker.blp" )
        set HeroFrame[8][7] = HeroFramehandle.create('O016', "Rena", 2, "ReplaceableTextures\\CommandButtons\\BTNForgottenOne.blp" )
        
        set HeroFrame[8][0].story = "A merry goblin from a distant land, traveling for interesting encounters. And mechs."
        set HeroFrame[8][1].story = "An ancient monster that devours the dreams and memories of living beings. It used to live in Nordel, but now it feeds on the weaknesses of the gladiators of the arena."
        set HeroFrame[8][2].story = "A scientist named Mengeles had been experimenting with extracts, in search of potent reagents had messed up an equation and discovered a nightmarish transformation instead. Paralysis had consumed them and they fell into a coma. Mengeles awoke years later, no longer a reknown scientist, but now known as The Plague. His abandoned laboratory too confining, and some human curiosity made them set out in search of greater experiments."
        set HeroFrame[8][3].story = "Referi is a prime ice wizard, unrivalled in his ability. It is a common knowledge that he once froze the entire fourth wall just to melt it with his hot elbows. Truth be told, he is actually a machine, a divine construct of the Gods themselves."
        set HeroFrame[8][6].story = "An evil spirit that embodies the thirst for revenge."
        set HeroFrame[8][7].story = "An initial encounter with a sluglike tentacle that had sprout from the ground marked the start of an inquiry into the great beyond and inevitably led to the establishment of the council. This same council eventually had an epiphany, \"We stand like this tentacle, planted in the earth, but what if the great beyond is near us, only above our heads?\" Members of the council took to the skies with Azathot in search of astral magics that may lead them to achieving greatness and a better understanding of the crawling chaos that inhabited these lands."
        
        call HeroFrame[8][0].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_CONTROL, 0, 0)
        call HeroFrame[8][1].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_PHYSICAL_DAMAGE, 0, 0)
        call HeroFrame[8][2].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_CONTROL, 0, 0)
        call HeroFrame[8][3].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_CONTROL, 0, 0)
        call HeroFrame[8][4].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_SUPPORT, 0, 0)
        call HeroFrame[8][5].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_CONTROL, ROLE_SUMMONER, 0)
        call HeroFrame[8][8].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_SUPPORT, 0, 0)
        call HeroFrame[8][7].AddRoles(ROLE_MAGIC_DAMAGE, ROLE_SUMMONER, 0, 0)
        
        set Event_DatabaseLoaded = 0.00
        set Event_DatabaseLoaded = 1.00
        set Event_DatabaseLoaded = 0.00
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local trigger delay = CreateTrigger()
        
        call TriggerRegisterTimerEvent(delay,1.,false)
		call TriggerAddAction(delay,function Database)
        
        set delay = null
    endfunction

endlibrary