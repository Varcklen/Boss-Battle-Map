scope SoulMarry

    globals
        private constant integer ID_SOULMARRY_ABILITY = 'AZ01'
    endglobals

    function Trig_SoulMarry_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_SOULMARRY_ABILITY and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
    endfunction

    function SoulMarryEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "zsoma" ) )
    
        call heroswap()
        call shield(u, u, 100*CountUnitsInGroup(udg_otryad), 60)
        call FlushChildHashtable( udg_hash, id )
        set u = null
    endfunction

    function Trig_SoulMarry_Actions takes nothing returns nothing
        local unit caster
        local integer id
        
        if CastLogic() then
            set caster = udg_Caster
        elseif RandomLogic() then
            set caster = udg_Caster
            call textst( udg_string[0] + GetObjectName(ID_SOULMARRY_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
        endif
        call heroswap()
        call shield(caster, caster, 100*(udg_Heroes_Amount-CountUnitsInGroup(udg_DeadHero)), 60)
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "zsoma" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "zsoma" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "zsoma" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "zsoma" ), caster )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId(caster), StringHash( "zsoma" ) ), 0.01, false, function SoulMarryEnd )
        set caster = null
    endfunction

    //===========================================================================
    function InitTrig_SoulMarry takes nothing returns nothing
        set gg_trg_SoulMarry = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulMarry, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SoulMarry, Condition( function Trig_SoulMarry_Conditions ) )
        call TriggerAddAction( gg_trg_SoulMarry, function Trig_SoulMarry_Actions )
    endfunction

endscope
