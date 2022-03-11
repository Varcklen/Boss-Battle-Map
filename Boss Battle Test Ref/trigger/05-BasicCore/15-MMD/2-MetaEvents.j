library MetaEvents initializer init requires MMD
	globals
		private integer execution_count
		private integer elapsed_seconds
	endglobals

	private function action_onHeroSkilled takes nothing returns nothing
		local unit u = GetTriggerUnit()
        local integer i = GetUnitUserData(u)
	
        if IsUnitInGroup(u, udg_heroinfo) and i > 0 and i < 5 then
            call MMD_LogEvent2("hero_skill_" + I2S(i),GetUnitName(u),GetAbilityName(GetLearnedSkill()))
        endif
		
		set u = null
	endfunction
    
    private function action_onHeroLevelUp takes nothing returns nothing
		local unit u = GetLevelingUnit()
        local integer i = GetUnitUserData(u)
	
        if IsUnitInGroup(u, udg_heroinfo) and i > 0 and i < 5 then
            call MMD_LogEvent2("hero_level_" + I2S(i),GetUnitName(u),I2S(GetUnitLevel(u)) )
        endif
		
		set u = null
	endfunction

	private function action_increaseElapsedSeconds takes nothing returns nothing
		set elapsed_seconds = elapsed_seconds + 1
	endfunction
	
	//DefineEvent2(name, format, argName1, argName2)
	private function init2 takes nothing returns nothing
        local trigger onHeroAbilityLearned = CreateTrigger()
        local trigger secondsPeriodic = CreateTrigger()
        local trigger OnLevelUp = CreateTrigger()
    
		local integer i
        
        call MMD_DefineEvent0("boss_kill","{0}")
        
        call MMD_DefineValue("hero",MMD_TYPE_STRING,MMD_GOAL_NONE,MMD_SUGGEST_NONE)
        call MMD_DefineValue("bosses_killed",  MMD_TYPE_INT, MMD_GOAL_NONE, MMD_SUGGEST_NONE)
        call MMD_DefineValue("difficulty", MMD_TYPE_STRING, MMD_GOAL_NONE, MMD_SUGGEST_NONE)
        set i = 0
        loop
            exitwhen i > 3
            call MMD_UpdateValueString("hero",Player(i),"none")
            call MMD_DefineEvent1("used_tome_of_oblivion_" + I2S(i+1),"{0}","Hero")
            call MMD_DefineEvent2("hero_skill_"+ I2S(i+1),"{0} {1}","Hero","Learned Skill")
            call MMD_DefineEvent2("hero_level_"+ I2S(i+1),"{0} {1}","Hero","Hero's level")
            call MMD_DefineEvent2("aspect_"+ I2S(i+1),"{0} {1}","Hero","Aspect")
            set i = i + 1
        endloop
        
        call TriggerRegisterAnyUnitEventBJ(onHeroAbilityLearned,EVENT_PLAYER_HERO_SKILL)
		call TriggerAddAction(onHeroAbilityLearned,function action_onHeroSkilled)	
        
        call TriggerRegisterTimerEvent(secondsPeriodic,1,true)
		call TriggerAddAction(secondsPeriodic,function action_increaseElapsedSeconds)	
		
        call TriggerRegisterAnyUnitEventBJ(OnLevelUp,EVENT_PLAYER_HERO_LEVEL)
		call TriggerAddAction(OnLevelUp,function action_onHeroLevelUp)
        
        set onHeroAbilityLearned = null
        set secondsPeriodic = null
        set OnLevelUp = null
	endfunction
	
	private function init takes nothing returns nothing
		local trigger delay = CreateTrigger()

		set execution_count = 1
		set elapsed_seconds = 0

		call TriggerRegisterTimerEvent(delay,1.,false)
		call TriggerAddAction(delay,function init2)

        set delay = null
	endfunction

endlibrary