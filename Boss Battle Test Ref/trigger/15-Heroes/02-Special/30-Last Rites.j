scope LastRites

    globals
        private constant integer ID_ABILITY = 'AZ03'
        private constant integer MP_COST = 25
        
        private constant string ANIMATION = "CallofDreadPurple.mdx"
    endglobals

    function Trig_Last_Rites_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
    endfunction

    function LastRitesCD takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "zlrcz" ) )

        call BlzStartUnitAbilityCooldown( u, ID_ABILITY, 5 )
        call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA ) + MP_COST )
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction  

    private function StartRessurection takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "zlrc" ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "zlrct" ) )
        local real hp
    
        call DestroyEffect( AddSpecialEffectTarget( ANIMATION, caster, "origin" ) )
        set hp = GetUnitLifePercent( caster ) 
        call ResInBattle( caster, target, R2I(hp) )
        call KillUnit( caster )
    
        set caster = null
        set target = null
    endfunction

    function Trig_Last_Rites_Actions takes nothing returns nothing
        local integer id 
        local unit caster
        local unit u 
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        set u = GroupPickRandomUnit(udg_DeadHero)
        if u != null then
            set id = InvokeTimerWithUnit(caster, "zlrc", 0.01, false, function StartRessurection )
            call SaveUnitHandle( udg_hash, id, StringHash( "zlrct" ), u )
        elseif GetSpellAbilityId() == ID_ABILITY then
            set id = GetHandleId( caster )
            if LoadTimerHandle( udg_hash, id, StringHash( "zlrcz" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "zlrcz" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "zlrcz" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "zlrcz" ), caster )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "zlrcz" ) ), 0.01, false, function LastRitesCD )
        endif
    
        set caster = null
        set u = null
    endfunction

    //===========================================================================
    function InitTrig_Last_Rites takes nothing returns nothing
        set gg_trg_Last_Rites = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_Last_Rites, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_Last_Rites, Condition( function Trig_Last_Rites_Conditions ) )
        call TriggerAddAction( gg_trg_Last_Rites, function Trig_Last_Rites_Actions )
    endfunction

endscope