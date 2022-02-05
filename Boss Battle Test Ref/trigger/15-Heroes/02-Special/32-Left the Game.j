scope LeftTheGame

    globals
        private constant integer ID_ABILITY = 'AZ04'
        private constant integer MP_COST = 25
        private constant real MULTIPLIER = 0.25
        
        private constant string ANIMATION = "ColdRitual.mdx"
    endglobals

    function Trig_Left_the_Game_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function LeftTheGameCD takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "zltgcz" ) )

        call BlzStartUnitAbilityCooldown( u, ID_ABILITY, 5 )
        call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA ) + MP_COST )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction  

    function Trig_Left_the_Game_Actions takes nothing returns nothing
        local integer id 
        local unit caster
        local integer cyclA = 1
        local boolean found = false
        local integer pointer
        local integer AbilInQ
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        
        /*Если это где-то хранится, было бы неплохо знать, где; я нашел...
        loop
            exitwhen cyclA > udg_Database_InfoNumberHeroes
            if GetUnitTypeId( caster ) == udg_Database_Hero[cyclA] then
                set pointer = cyclA
            endif
            set cyclA = cyclA + 1
        endloop*/
        set pointer = udg_HeroNum[GetUnitUserData(caster)]
        //set found = false
        //Спагетти, не смотреть
        set AbilInQ = udg_DB_Hero_FirstSpell[pointer]
        if GetUnitAbilityLevel( caster, AbilInQ ) > 0 and BlzGetUnitAbilityCooldownRemaining( caster, AbilInQ ) > 0 then
            set found = true
        else
            set AbilInQ = udg_Database_EarringSpell[pointer]
            if GetUnitAbilityLevel( caster, AbilInQ ) > 0 and BlzGetUnitAbilityCooldownRemaining( caster, AbilInQ ) > 0 then
                set found = true
            else
                set AbilInQ = udg_DB_Hero_Passive[pointer]
                if GetUnitAbilityLevel( caster, AbilInQ ) > 0 and BlzGetUnitAbilityCooldownRemaining( caster, AbilInQ ) > 0 then
                    set found = true
                else
                    set AbilInQ = udg_DB_Hero_Fourth[pointer]
                    if GetUnitAbilityLevel( caster, AbilInQ ) > 0 and BlzGetUnitAbilityCooldownRemaining( caster, AbilInQ ) > 0 then
                        set found = true
                    endif
                endif
            endif
        endif

        if found then    
            call BlzStartUnitAbilityCooldown( caster, AbilInQ, BlzGetUnitAbilityCooldownRemaining(caster, AbilInQ) * (1-MULTIPLIER) )
            //call BlzStartUnitAbilityCooldown( caster, AbilInQ, RMaxBJ(0.,BlzGetUnitAbilityCooldownRemaining(caster, AbilInQ) - BlzGetUnitAbilityCooldown(caster, AbilInQ, GetUnitAbilityLevel( caster, AbilInQ)) * MULTIPLIER ))
            call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, "chest" ) )
          
        elseif GetSpellAbilityId() == ID_ABILITY then
            set id = GetHandleId( caster )
            if LoadTimerHandle( udg_hash, id, StringHash( "zltgcz" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "zltgcz" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "zltgcz" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "zltgcz" ), caster )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "zltgcz" ) ), 0.01, false, function LeftTheGameCD )
        endif
    
        set caster = null

    endfunction

    //===========================================================================
    function InitTrig_Left_the_Game takes nothing returns nothing
        set gg_trg_Left_the_Game = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Left_the_Game, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Left_the_Game, Condition( function Trig_Left_the_Game_Conditions ) )
        call TriggerAddAction( gg_trg_Left_the_Game, function Trig_Left_the_Game_Actions )
    endfunction

endscope
