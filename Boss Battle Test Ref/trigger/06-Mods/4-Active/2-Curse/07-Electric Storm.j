scope Storm

    globals
        constant integer STORM_COOLDOWN = 15
        constant integer STORM_TIME_TO_ACTIVATION = 3
        constant integer STORM_HOW_MUCH = 15
        constant integer STORM_AREA = 128
        
        constant real STORM_PERC_HP_DAMAGE = 0.2
        
        constant string STORM_WARNING = "war3mapImported\\AuraOfDeath.mdx"
        constant string STORM_LIGHTNING = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    endglobals

    function Trig_Electric_Storm_Conditions takes nothing returns boolean
        return udg_modbad[28]
    endfunction

    function Storm_Use takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local effect storm = LoadEffectHandle( udg_hash, id, StringHash( "mdb28" ) )
        local group g = CreateGroup()
        local unit u
        local real x = BlzGetLocalSpecialEffectX( storm )
        local real y = BlzGetLocalSpecialEffectY( storm )
        
        set bj_lastCreatedUnit = CreateUnit( Player( 10 ), 'u000', 0, 0, 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)
        call GroupEnumUnitsInRange( g, x, y, STORM_AREA, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, bj_lastCreatedUnit, "enemy" ) then
                call UnitTakeDamage(bj_lastCreatedUnit, u, GetUnitState(u, UNIT_STATE_MAX_LIFE)*STORM_PERC_HP_DAMAGE, DAMAGE_TYPE_MAGIC)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        call DestroyEffect( AddSpecialEffect( STORM_LIGHTNING, x, y ) )
        call DestroyEffect( storm )
        
        call DestroyTimer( GetExpiredTimer() )
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set storm = null
    endfunction

    function Storm_Start takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local effect storm
        local point lightPoint 
        local integer i

        if udg_fightmod[0] == false then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            set i = 1
            loop
                exitwhen i > STORM_HOW_MUCH
                set lightPoint = GetRandomPointInRect(udg_Boss_Rect)
                set storm = AddSpecialEffect(STORM_WARNING, lightPoint.x, lightPoint.y)
                call InvokeTimerWithEffect(storm, "mdb28", STORM_TIME_TO_ACTIVATION, false, function Storm_Use )
                set i = i + 1
            endloop
        endif
        
        call lightPoint.destroy()
        set storm = null
    endfunction

    function Trig_Electric_Storm_Actions takes nothing returns nothing
        if LoadTimerHandle( udg_hash, 1, StringHash("mdb28c") ) == null then
            call SaveTimerHandle( udg_hash, 1, StringHash("mdb28c"), CreateTimer() )
        endif
        call TimerStart( LoadTimerHandle( udg_hash, 1, StringHash("mdb28c") ), STORM_COOLDOWN, true, function Storm_Start )
    endfunction
    
    //===========================================================================
    function InitTrig_Electric_Storm takes nothing returns nothing
        call CreateEventTrigger( "udg_FightStartGlobal_Real", function Trig_Electric_Storm_Actions, function Trig_Electric_Storm_Conditions )
    endfunction

endscope
