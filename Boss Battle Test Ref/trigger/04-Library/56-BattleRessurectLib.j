library BattleRessurectLib requires CommonTimer

    globals
        constant integer RESSURECTION_DURATION = 3
    endglobals

    function BattleRessurectEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "btrs1" ) )
        local real r = LoadReal( udg_hash, id, StringHash( "btrs1" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "btrs1c" ) )
        local real x = LoadReal( udg_hash, id, StringHash( "btrs1x" ) )
        local real y = LoadReal( udg_hash, id, StringHash( "btrs1y" ) )

        if udg_combatlogic[GetPlayerId( GetOwningPlayer( u ) ) + 1] and GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
            call ReviveHero( u, x, y, true )
            call ShowUnitShow( u )
            call PanCameraToTimedForPlayer( GetOwningPlayer( u ), GetUnitX(u), GetUnitY(u), 0.25 )
            call SelectUnitForPlayerSingle( u, GetOwningPlayer( u ) )
            if GetUnitState( u, UNIT_STATE_LIFE) <= 0.405 then
                if GetPlayerSlotState(GetOwningPlayer(u)) == PLAYER_SLOT_STATE_PLAYING then
                    set udg_Heroes_Deaths = udg_Heroes_Deaths + 1
                    call GroupAddUnit( udg_DeadHero, u )
                endif
            else
                call GroupAddUnit( udg_otryad, u )
                call PauseUnit( u, false )
                call SetUnitState( u, UNIT_STATE_LIFE, GetUnitState( u, UNIT_STATE_MAX_LIFE) * r * 0.01 )
                call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MAX_MANA) * r * 0.01 )
            endif
            call UnitRemoveAbility(u, 'A19D')
        endif
        
        call FlushChildHashtable( udg_hash, id )
        set u = null
        set caster = null
    endfunction

    function BattleRessurectExecute takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "btrs" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "btrsc" ) )
        local integer id1 = GetHandleId( target )
        local real r = LoadInteger( udg_hash, id, StringHash( "btrslvl" ) )
        local player p = GetOwningPlayer( target )

        if udg_combatlogic[GetPlayerId( p ) + 1] then
            if GetLocalPlayer() == p then
                call StartSound(gg_snd_Warning)
            endif
            call DisplayTimedTextToPlayer( p, 0, 0, 5, "|cffffcc00WARNING!|r Your hero will be resurrected." )
            call UnitAddAbility(target, 'A19D')

            set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
            call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', RESSURECTION_DURATION )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",  bj_lastCreatedUnit, "origin" ) )
            
            set id1 = InvokeTimerWithUnit( target, "btrs1", RESSURECTION_DURATION, false, function BattleRessurectEnd )
            call SaveUnitHandle( udg_hash, id1, StringHash( "btrs1c" ), caster )
            call SaveReal( udg_hash, id1, StringHash( "btrs1" ), r )
            call SaveReal( udg_hash, id1, StringHash( "btrs1x" ), GetUnitX( caster ) )
            call SaveReal( udg_hash, id1, StringHash( "btrs1y" ), GetUnitY( caster ) )
        endif

        call FlushChildHashtable( udg_hash, id )

        set target = null
        set caster = null
        set p = null
    endfunction 

    function ResInBattle takes unit caster, unit u, integer perc returns nothing
        local integer id 

        if u != null then
            if perc > 100 then
                set perc = 100
            elseif perc < 0 then
                set perc = 0
            endif
            set udg_Heroes_Deaths = udg_Heroes_Deaths - 1

            call GroupRemoveUnit( udg_DeadHero, u )
            
            set id = InvokeTimerWithUnit( u, "btrs", 0.01, false, function BattleRessurectExecute )
            call SaveUnitHandle( udg_hash, id, StringHash( "btrsc" ), caster )
            call SaveInteger( udg_hash, id, StringHash( "btrslvl" ), perc )
        endif
        
        set caster = null
        set u = null
    endfunction

endlibrary