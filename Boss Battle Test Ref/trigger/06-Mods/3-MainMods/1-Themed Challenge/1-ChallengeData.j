library ChallengeData initializer init requires LibDataItems
    globals
        private constant integer DARK_PORTAL = 1
        private constant integer SLOWNESS = 2
        private constant integer GRAVE = 3
        private constant integer FLAME = 4
        private constant integer SUPPRESSION = 5
        private constant integer SUCCUMBING = 6
        private constant integer EQUALITY = 7
        private constant integer FATIGUE = 8
        private constant integer DEFICIT = 9
        private constant integer THE_POWER_OF_MAGIC = 10
        private constant integer ACCELERATION = 11
        private constant integer REINCARNATION = 12
        private constant integer SEAL_OF_WEAKNESS = 13
        private constant integer SUPPORT = 14
        private constant integer SCATTER = 15
        private constant integer DETONATION = 16
        private constant integer STORM = 17
        private constant integer STEADFASTNESS = 18
        private constant integer DARKNESS = 19
        private constant integer TRASH = 20
        private constant integer COUNTERSTRIKE = 21
        private constant integer ZEAL = 22
        private constant integer LAZINESS = 23
        private constant integer SEEKER = 24
        private constant integer MYSTERY = 25
        private constant integer ANGER = 26
        private constant integer WILD_GROWTH = 27
        private constant integer ELECTRIC_STORM = 28
        private constant integer MISTRUST = 29
        private constant integer FIRST_BLOOD = 30
        private constant integer CONFUSION = 31
        private constant integer RIVALVY = 32
        
        private constant integer CHALLENGE_COUNT = 10
        public constant integer CURSES = 5
        private constant integer CURSES_ARRAYS = CURSES + 1
        integer array Theme_Ability[CHALLENGE_COUNT]
        integer array Challenges[CHALLENGE_COUNT][CURSES_ARRAYS]//Номер испытания/проклятия
        
        integer Chosen_Challenge = 0
    endglobals
    
    private function SetMod takes integer number, integer themeId, integer curse1, integer curse2, integer curse3, integer curse4, integer curse5 returns nothing
        set Theme_Ability[number] = themeId
        set Challenges[number][1] = curse1
        set Challenges[number][2] = curse2
        set Challenges[number][3] = curse3
        set Challenges[number][4] = curse4
        set Challenges[number][5] = curse5
    endfunction
    
    private function SetNewDescription takes nothing returns nothing
        local string newDesc = BlzFrameGetText(modesDescription[3][1])
        local integer i
    
        //BlzGetAbilityTooltip(udg_DB_ModesFrame_Ability[cyclA], 0), BlzGetAbilityExtendedTooltip(udg_DB_ModesFrame_Ability[cyclA], 0)
        set newDesc = newDesc + "|n|n" + BlzGetAbilityTooltip(Theme_Ability[Chosen_Challenge], 0) + "|n" + BlzGetAbilityExtendedTooltip(Theme_Ability[Chosen_Challenge], 0) + "|n"
        
        set i = 1
        loop
            exitwhen i > CURSES
            set newDesc = newDesc + "|n -" + BlzGetAbilityExtendedTooltip(udg_DB_BadMod[Challenges[Chosen_Challenge][i]], 0)
            set i = i + 1
        endloop
    
        call SetStableToolDescription( modesDescription[3][1], newDesc )
    endfunction
    
    private function SetMods takes nothing returns nothing
        set udg_base = 0
        call SetMod(BaseNum(), 'A1D4', STORM, ELECTRIC_STORM, DETONATION, WILD_GROWTH, SEEKER )
        call SetMod(BaseNum(), 'A1D5', ANGER, COUNTERSTRIKE, STEADFASTNESS, SUPPORT, ZEAL )
        call SetMod(BaseNum(), 'A1D6', MYSTERY, GRAVE, TRASH, DEFICIT, ACCELERATION )
        call SetMod(BaseNum(), 'A1D7', MISTRUST, RIVALVY, SCATTER, FLAME, DARKNESS )
        call SetMod(BaseNum(), 'A1D8', FIRST_BLOOD, REINCARNATION, SUCCUMBING, EQUALITY, SUPPRESSION )
        call SetMod(BaseNum(), 'A1D9', CONFUSION, FATIGUE, LAZINESS, SEAL_OF_WEAKNESS, MISTRUST )
        
        set Chosen_Challenge = GetRandomInt(1, udg_base)
        
        call SetNewDescription()
    endfunction
    
    private function init takes nothing returns nothing
        call TimerStart( CreateTimer(), 1, false, function SetMods )
    endfunction
endlibrary

