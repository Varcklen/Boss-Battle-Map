scope MagicFern initializer init

    globals
        private constant integer ID_ITEM = 'I0E8'
        
        private constant string ANIMATION = "war3mapImported\\SoulRitual.mdx"
        
        private integer array Stealed_SpellPower[PLAYERS_LIMIT_ARRAYS][PLAYERS_LIMIT_ARRAYS]//YourHero/DeadHero
        private integer array Stealed_Luck[PLAYERS_LIMIT_ARRAYS][PLAYERS_LIMIT_ARRAYS]//YourHero/DeadHero
        private boolean array IsStealed[PLAYERS_LIMIT_ARRAYS][PLAYERS_LIMIT_ARRAYS]//YourHero/DeadHero
    endglobals

    function Trig_Magic_Fern_Conditions takes nothing returns boolean
        return IsUnitInGroup(GetDyingUnit(), udg_heroinfo)
    endfunction
    
    private function Steal takes unit hero, unit diedHero returns nothing
        local integer diedIndex = GetUnitUserData(diedHero)
        local integer index = GetUnitUserData(hero)
        local integer luck = udg_lucky[diedIndex]
        local integer spellPower = R2I((GetUnitSpellPower(diedHero)-1)*100)
    
        set IsStealed[index][diedIndex] = true
        call PlaySpecialEffect(ANIMATION, hero)
        
        call spdst( hero, spellPower )
        call luckyst (hero, luck )
        set Stealed_SpellPower[index][diedIndex] = Stealed_SpellPower[index][diedIndex] + spellPower
        set Stealed_Luck[index][diedIndex] = Stealed_Luck[index][diedIndex] + luck
        
        set hero = null
        set diedHero = null
    endfunction
    
    private function GetIsStealed takes unit hero returns boolean
        local boolean isWork = false
        local integer i = 1
        local integer index = GetUnitUserData(hero)
        
        loop
            exitwhen i > PLAYERS_LIMIT or isWork
            if IsStealed[index][i] then
                set isWork = true
            endif
            set i = i + 1
        endloop
        set hero = null
        return isWork
    endfunction
    
    function Trig_Magic_Fern_Actions takes nothing returns nothing
        local integer i 
        local unit hero
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            set hero = udg_hero[i]
            if IsHeroHasItem(hero, ID_ITEM) and udg_fightmod[3] == false and combat( hero, false, 0 ) and IsUnitAlive(hero) and IsStealed[GetUnitUserData(hero)][GetUnitUserData(GetDyingUnit())] == false then
                call Steal(hero, GetDyingUnit())
            endif
            set i = i + 1
        endloop
        
        set hero = null
    endfunction
    
    private function FightEnd_Conditions takes nothing returns boolean
        return GetIsStealed(udg_FightEnd_Unit)
    endfunction
    
    private function FightEnd takes nothing returns nothing
        local unit hero = udg_FightEnd_Unit
        local integer index = GetUnitUserData(hero)
        local integer i 
        
        set i = 1
        loop
            exitwhen i > PLAYERS_LIMIT
            if IsStealed[index][i] then
                set IsStealed[index][i] = false
                call spdst( hero, -Stealed_SpellPower[index][i] )
                call luckyst (hero, -Stealed_Luck[index][i] )
                set Stealed_SpellPower[index][i] = 0
                set Stealed_Luck[index][i] = 0
            endif
            set i = i + 1
        endloop

        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_Magic_Fern = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Magic_Fern, EVENT_PLAYER_UNIT_DEATH )
        call TriggerAddCondition( gg_trg_Magic_Fern, Condition( function Trig_Magic_Fern_Conditions ) )
        call TriggerAddAction( gg_trg_Magic_Fern, function Trig_Magic_Fern_Actions )
        
        call CreateEventTrigger( "udg_FightEnd_Real", function FightEnd, function FightEnd_Conditions )
    endfunction

endscope

