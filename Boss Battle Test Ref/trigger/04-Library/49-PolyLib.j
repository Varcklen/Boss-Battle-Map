library PolyLib initializer init requires TimebonusLib, UnitstLib, BuffsLibLib

    globals
        constant integer POLYMORPH_SHEEP = 'n02L'
        constant integer POLYMORPH_RAT = 'n02N'
        constant integer POLYMORPH_FROG = 'n02M'
        
        private constant string ANIMATION = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    endglobals
    
    private function EndPolymorph takes unit target returns nothing
        local integer unitId = GetHandleId( target )
        local integer skin = LoadInteger( udg_hash, unitId, StringHash( "polysk" ) )
        local real selectionScale = LoadReal( udg_hash, unitId, StringHash( "polyc" ) )

        if IsUnitAlive( target ) then
            call PlaySpecialEffect(ANIMATION, target)
        endif
        call SetUnitSkin( target, skin )
        call BlzSetUnitRealFieldBJ( target, UNIT_RF_SELECTION_SCALE, selectionScale )
        call UnitRemoveAbility( target, 'A1A0' )
        call UnitRemoveAbility( target, 'B043' )
        call UnitRemoveAbility( target, 'BNsi' )
        call SaveInteger( udg_hash, unitId, StringHash( "poly" ), 0 )

        set target = null
    endfunction
    
    function PolyCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local unit u = LoadUnitHandle( udg_hash, id, StringHash( "poly" ) )
        local integer unitId = GetHandleId( u )
        local integer h = LoadInteger( udg_hash, unitId, StringHash( "poly" ) ) - 1
        local integer skin = LoadInteger( udg_hash, unitId, StringHash( "polysk" ) )
        local real c = LoadReal( udg_hash, unitId, StringHash( "polyc" ) )

        call SaveInteger( udg_hash, unitId, StringHash( "poly" ), h )
        if h <= 0 and IsUnitHasAbility( u, 'A1A0') then
            call EndPolymorph(u)
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
            
            //РЅР°РјРµСЂРµРЅРЅРѕ Р±РµР· СѓСЃР»РѕРІРёСЏ
            call SaveTimerHandle( udg_hash, id, StringHash( "poly" ), CreateTimer() )
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "poly" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "poly" ), target )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "poly" ) ), t, false, function PolyCast )
        endif
        call debuffst( caster, target, null, 1, t )
        
        set caster = null
        set target = null
    endfunction

    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, 'A1A0')
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call EndPolymorph(Event_DeleteBuff_Unit)
    endfunction
    
    private function DeleteSilence takes nothing returns nothing
        if IsUnitHasAbility( Event_DeleteBuff_Unit, 'BNsi') then
            call UnitRemoveAbility( Event_DeleteBuff_Unit, 'BNsi' )
        endif
    endfunction
    
    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteSilence, null )
    endfunction

endlibrary