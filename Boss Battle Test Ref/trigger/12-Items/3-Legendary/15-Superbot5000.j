library Superbot5000

    globals
        private constant integer ID_SUPERBOT = 'n01Z'
        private constant integer INVUL = 'Avul'
        private constant integer RAVEN = 'Amrf'
        
        private constant string ANIMATION = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    
        unit array Transport[PLAYERS_LIMIT_ARRAYS]
    endglobals

    function SuperbotLog takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sprb2" ) )
        local unit bot = LoadUnitHandle( udg_hash, id, StringHash( "sprbh2" ) )
        
        if not( IsUnitInTransport( caster, bot ) ) then
            call KillUnit( bot )
            call UnitRemoveAbility( caster, INVUL )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        endif
        
        set caster = null
        set bot = null
    endfunction

    function SuperbotEnd takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local integer id1 
        local unit bot = LoadUnitHandle( udg_hash, id, StringHash( "sprbh1" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sprb1" ) )

        call PauseUnit( caster, false )
        call PauseUnit( bot, false )
        
        call UnitRemoveAbility( bot, RAVEN)
        call DestroyEffect( AddSpecialEffect(ANIMATION, GetUnitX( bot ), GetUnitY( bot ) ) )
        call SetUnitPosition( bot, GetUnitX(caster), GetUnitY(caster) )
        call IssueTargetOrder( caster, "board", bot )
        
        set id1 = InvokeTimerWithUnit(caster, "sprb2", 1, true, function SuperbotLog )
        call SaveUnitHandle( udg_hash, id1, StringHash( "sprbh2" ), bot )
        
        call FlushChildHashtable( udg_hash, id )
        
        set bot = null
        set caster = null
    endfunction

    function SuperbotCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local integer id1 
        local unit bot = LoadUnitHandle( udg_hash, id, StringHash( "sprbh" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sprb" ) )

        call SetUnitFlyHeight( bot, -600, 3000 )
        call ShowUnit( bot, true )
        
        set id1 = InvokeTimerWithUnit(caster, "sprb1", 0.6, false, function SuperbotEnd )
        call SaveUnitHandle( udg_hash, id1, StringHash( "sprbh1" ), bot )
        
        call FlushChildHashtable( udg_hash, id )
        
        set bot = null
        set caster = null
    endfunction

    function Superbot takes unit caster returns nothing
        local integer id
        local integer index = GetUnitUserData(caster)
        
        call UnitAddAbility( caster, INVUL )
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), ID_SUPERBOT, GetUnitX( caster ), GetUnitY( caster ), 270 )
        set Transport[index] = bj_lastCreatedUnit
        call ShowUnit( bj_lastCreatedUnit, false)
        call PauseUnit( bj_lastCreatedUnit, true )
        call PauseUnit( caster, true )
        call UnitAddAbility( bj_lastCreatedUnit, RAVEN)
        call SetUnitFlyHeight( bj_lastCreatedUnit, 3000, 3000 )
        
        set id = InvokeTimerWithUnit(caster, "sprb", 0.5, false, function SuperbotCast )
        call SaveUnitHandle( udg_hash, id, StringHash( "sprbh" ), bj_lastCreatedUnit )
        
        set caster = null
    endfunction

endlibrary