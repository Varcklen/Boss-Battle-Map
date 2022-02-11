library PolyLib requires TimebonusLib, UnitstLib, BuffsLibLib

    globals
        constant integer POLYMORPH_SHEEP = 'n02L'
        constant integer POLYMORPH_RAT = 'n02N'
        constant integer POLYMORPH_FROG = 'n02M'
    endglobals

    function PolyCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "poly" ) )
        local integer h = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "poly" ) ) - 1
        local integer skin = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "polysk" ) )
        local real c = LoadReal( udg_hash, GetHandleId( u ), StringHash( "polyc" ) )

        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "poly" ), h )
        if h <= 0 then
            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            endif
            call SetUnitSkin( u, skin )
            call BlzSetUnitRealFieldBJ( u, UNIT_RF_SELECTION_SCALE, c )
            call UnitRemoveAbility( u, 'A1A0' )
            call UnitRemoveAbility( u, 'B043' )
            call UnitRemoveAbility( u, 'BNsi' )
        endif
        call FlushChildHashtable( udg_hash, id )

        set u = null
    endfunction

    function UnitPoly takes unit caster, unit target, integer skin, real r returns nothing
        local integer h = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "poly" ) )
        local real t = timebonus(caster, r)
        local integer id

        if GetUnitState( target, UNIT_STATE_LIFE) > 0.405 and GetUnitTypeId(target) != ID_SHEEP then
            if GetUnitAbilityLevel(target, 'BNsi') == 0 then
                set bj_lastCreatedUnit = CreateUnit( Player( PLAYER_NEUTRAL_AGGRESSIVE ), 'u000', GetUnitX( target ), GetUnitY( target ), 270 )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 1)   
                call UnitAddAbility( bj_lastCreatedUnit, 'A1B6' )
                call IssuePointOrder( bj_lastCreatedUnit, "silence", GetUnitX(bj_lastCreatedUnit), GetUnitY(bj_lastCreatedUnit) )
            endif
        
            call IssueImmediateOrderBJ( target, "unimmolation" )
            if BlzGetUnitSkin(target) != skin then
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX( target ), GetUnitY( target ) ) )
            endif
            if h == 0 then
                call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "polysk" ), BlzGetUnitSkin(target) )
                call SaveReal( udg_hash, GetHandleId( target ), StringHash( "polyc" ), BlzGetUnitRealField(target, UNIT_RF_SELECTION_SCALE) )
            endif
            call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "poly" ), h + 1 )
            call SetUnitSkin( target, skin )
            call UnitAddAbility( target, 'A1A0' )
            set id = GetHandleId( target )
            
            //намеренно без условия
            call SaveTimerHandle( udg_hash, id, StringHash( "poly" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "poly" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "poly" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "poly" ) ), t, false, function PolyCast )
        endif
        call debuffst( caster, target, null, 1, t )
        
        set caster = null
        set target = null
    endfunction

endlibrary