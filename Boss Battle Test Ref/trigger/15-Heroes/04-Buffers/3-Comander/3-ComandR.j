scope ComanderR

    globals
        private constant integer STRENGTH_LIMIT = 100000
    endglobals

    function Trig_ComandR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'A0UV'
    endfunction

    function ComandRSpell takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "comr" ) )
        local real hp = GetUnitState( u, UNIT_STATE_LIFE)
        local integer str = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "comrs" ) )
        
        if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
            call statst( u, -str, 0, 0, 0, false )
            call SetUnitState( u, UNIT_STATE_LIFE, hp )
            call UnitRemoveAbility( u, 'A0UX' )
            call UnitRemoveAbility( u, 'B056' )
            call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "comrs" ) )
        endif
        call FlushChildHashtable( udg_hash, id )
        
        set u = null
    endfunction

    function Trig_ComandR_Actions takes nothing returns nothing
        local integer id 
        local integer str 
        local integer strsum
        local unit caster
        local unit target
        local integer lvl
        local real t
        local real hp
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName('A0UV'), caster, 64, 90, 10, 1.5 )
            set t = 20 
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = 20 
        endif
        set t = timebonus(caster, t)

        set id = GetHandleId( target )
        
        if IsUnitType( target, UNIT_TYPE_HERO) then
            set str = 10+(10*lvl)
            call UnitAddAbility( target, 'A0UX' )
            if GetHeroStr( target, false) < STRENGTH_LIMIT then
                call statst( target, str, 0, 0, 0, false )
                set strsum = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "comrs" ) ) + str
            endif

            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            
            set id = GetHandleId( target )
            if LoadTimerHandle( udg_hash, id, StringHash( "comr" ) ) == null  then
                call SaveTimerHandle( udg_hash, id, StringHash( "comr" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "comr" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "comr" ), target )
            call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "comrs" ), strsum )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "comr" ) ), t, false, function ComandRSpell )
            
            if BuffLogic() then
                call effst( caster, target, null, lvl, t )
            endif
        endif
        
        set caster = null
        set target = null
    endfunction

    //===========================================================================
    function InitTrig_ComandR takes nothing returns nothing
        set gg_trg_ComandR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ComandR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_ComandR, Condition( function Trig_ComandR_Conditions ) )
        call TriggerAddAction( gg_trg_ComandR, function Trig_ComandR_Actions )
    endfunction
    
endscope