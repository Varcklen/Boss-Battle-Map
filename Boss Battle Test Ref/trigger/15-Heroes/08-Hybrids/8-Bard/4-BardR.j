scope BardR initializer init

    globals
        private constant integer ID_ABILITY = 'A1B0'
        
        private constant integer DURATION_FIRST_LEVEL = 4
        private constant integer DURATION_LEVEL_BONUS = 3
        private constant integer MANA_BONUS = 15
        private constant integer SET_HEALTH_PERCENT_AFTER_RESSURECT = 50
        
        private constant integer RESSURECTS_ALTERNATIVE = 2
        
        private constant integer EFFECT = 'A1B1'
        private constant integer BUFF = 'B09O'
    endglobals

    function Trig_BardR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and udg_fightmod[3] == false
    endfunction 

    private function BardRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "brdr" ) )

        if IsUnitAlive(u) and combat( u, false, 0 ) and udg_fightmod[3] == false and GetUnitAbilityLevel( u, EFFECT) > 0 then
            call KillUnit(u)
        endif
        call UnitRemoveAbility( u, EFFECT )
        call UnitRemoveAbility( u, BUFF )
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction
    
    private function Alternative takes unit caster, real duration, integer level returns nothing 
        local unit deadHero
        local unit randomHero
        local integer i
    
        set deadHero = GroupPickRandomUnit(udg_DeadHero)
        if deadHero != null then
            set i = 1
            loop
                exitwhen i > RESSURECTS_ALTERNATIVE or deadHero == null
                set deadHero = GroupPickRandomUnit(udg_DeadHero)
                if deadHero != null then
                    call ResInBattle( caster, deadHero, SET_HEALTH_PERCENT_AFTER_RESSURECT )
                
                    call BlzSetUnitMaxMana( deadHero, BlzGetUnitMaxMana(deadHero) + MANA_BONUS )
                    
                    call UnitAddAbility( deadHero, EFFECT )
                    call InvokeTimerWithUnit(deadHero, "brdr", duration, false, function BardRCast)
                endif
                set i = i + 1
            endloop
        else
            set randomHero = GroupPickRandomUnit(udg_otryad)
            if randomHero != null then
                call BardEUse( caster, randomHero, level )
            endif
        endif
        
        set randomHero = null
        set deadHero = null
        set caster = null
    endfunction
    
    private function Main takes unit caster, real duration, integer level returns nothing 
        local unit deadHero
        local integer i
    
        set deadHero = GroupPickRandomUnit(udg_DeadHero)

        if deadHero != null then
            call ResInBattle( caster, deadHero, SET_HEALTH_PERCENT_AFTER_RESSURECT )
            
            call BlzSetUnitMaxMana( deadHero, BlzGetUnitMaxMana(deadHero) + MANA_BONUS )
            
            call UnitAddAbility( deadHero, EFFECT )
            call InvokeTimerWithUnit(deadHero, "brdr", duration, false, function BardRCast)
        else
            set i = 1
            loop
                exitwhen i > PLAYERS_LIMIT
                if unitst( caster, udg_hero[i], TARGET_ALLY ) then
                    call BardEUse( caster, udg_hero[i], level )
                endif
                set i = i + 1
            endloop
        endif
        
        set deadHero = null
        set caster = null
    endfunction

    function Trig_BardR_Actions takes nothing returns nothing
        local unit caster
        local integer lvl
        local real t
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set t = DURATION_FIRST_LEVEL+(DURATION_LEVEL_BONUS*lvl)
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = DURATION_FIRST_LEVEL+(DURATION_LEVEL_BONUS*lvl)
        endif
        set t = timebonus(caster, t)+RESSURECTION_DURATION
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_03 ) then
            call Alternative( caster, t, lvl )
        else
            call Main( caster, t, lvl )
        endif

        set caster = null
    endfunction

    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_BardR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_BardR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_BardR, Condition( function Trig_BardR_Conditions ) )
        call TriggerAddAction( gg_trg_BardR, function Trig_BardR_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction

endscope