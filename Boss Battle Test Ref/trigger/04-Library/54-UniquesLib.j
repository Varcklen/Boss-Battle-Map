library UniquesLib requires SetCount, CorrectPlayerLib

    //Условие использования Uniques
    function Uniques_Logic takes integer spell returns boolean
        local integer cyclA = 1
        local boolean l = false
        
        loop
            exitwhen cyclA > 4
            if spell == udg_Ability_Uniq[cyclA] then
                set l = true
                set cyclA = 4
            endif
            set cyclA = cyclA + 1
        endloop
        return l
    endfunction

    function IsUniqueUpgraded takes unit u returns boolean
        local boolean l = false
        if LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "unique" )) then
            set l = true
        endif
        set u = null
        return l
    endfunction

    function BeerUqCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "beeruq" ) )
        local integer ab = LoadInteger( udg_hash, id, StringHash( "beeruq" ) )
        local integer rand
        
        if GetUnitAbilityLevel( caster, ab) == 0 then
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        elseif udg_fightmod[0] and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 then
            set udg_RandomLogic = true
            set udg_Caster = caster
            set udg_Level = 5
            set rand = GetRandomInt( 1, 3 )
            if rand == 1 then
                call TriggerExecute( udg_DB_Trigger_One[GetRandomInt( 1, udg_Database_NumberItems[14])] )
            elseif rand == 2 then
                call TriggerExecute( udg_DB_Trigger_Two[GetRandomInt( 1, udg_Database_NumberItems[15])] )
            else
                call TriggerExecute( udg_DB_Trigger_Three[GetRandomInt( 1, udg_Database_NumberItems[16])] )
            endif
        endif
        
        set caster = null
    endfunction

    function NewUniques takes unit caster, integer uniq returns integer
        local unit u = caster
        local integer i = GetUnitUserData(u)
        local integer cyclA
        local integer cyclAEnd
        local integer spnew
        local boolean l
        local integer unold 
        local integer id

        /*if udg_logic[59] then
            set i = CorrectPlayer(caster)
            set u = caster
            set udg_logic[59] = false
        else
            set u = udg_hero[GetPlayerId(GetOwningPlayer(caster)) + 1]
            set i = GetPlayerId(GetOwningPlayer(u)) + 1
        endif*/
        
        set unold = udg_Ability_Uniq[i]
        set l = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "unique" ) )

        set cyclA = 1
        set cyclAEnd = udg_Database_NumberItems[13]
        set spnew = uniq
        loop
            exitwhen cyclA > cyclAEnd
            if uniq == udg_DB_Hero_SpecAb[cyclA] or uniq == udg_DB_Hero_SpecAbPlus[cyclA] then
                if l then
                    set spnew = udg_DB_Hero_SpecAbPlus[cyclA]
                else
                    set spnew = udg_DB_Hero_SpecAb[cyclA]
                endif
            endif
            set cyclA = cyclA + 1
        endloop
        
        if unold == 'A0XI' then
            call SetCount_AddPiece( u, SET_MECH, -2 )
        endif
        if unold == 'A0XK' then
            call SetCount_AddPiece( u, SET_MECH, -3 )
        endif
        
        call UnitRemoveAbility( u, udg_Ability_Uniq[i] )
        set udg_Ability_Uniq[i] = spnew
        call UnitAddAbility( u, udg_Ability_Uniq[i] )

        if spnew == 'A0XI' then
            call SetCount_AddPiece( u, SET_MECH, 2 )
        endif
        if spnew == 'A0XK' then
            call SetCount_AddPiece( u, SET_MECH, 3 )
        endif
        if spnew == 'A15W' then
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "beeruq" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "beeruq" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "beeruq" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "beeruq" ), u )
            call SaveInteger( udg_hash, id, StringHash( "beeruq" ), spnew )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "beeruq" ) ), 10, true, function BeerUqCast )
        endif
        if spnew == 'A15X' then
            set id = GetHandleId( u )
            if LoadTimerHandle( udg_hash, id, StringHash( "beeruq" ) ) == null then
                call SaveTimerHandle( udg_hash, id, StringHash( "beeruq" ), CreateTimer() )
            endif
            set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "beeruq" ) ) ) 
            call SaveUnitHandle( udg_hash, id, StringHash( "beeruq" ), u )
            call SaveInteger( udg_hash, id, StringHash( "beeruq" ), spnew )
            call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "beeruq" ) ), 5, true, function BeerUqCast )
        endif
        
        if spnew != 0 then
            call BlzFrameSetVisible( uniqframe[i],true)
            call BlzFrameSetTexture( uniqframe[i], BlzGetAbilityIcon(spnew),0, true)
        else
            call BlzFrameSetVisible( uniqframe[i],false)
        endif
        
        set caster = null
        set u = null
        return spnew
    endfunction

    function skillst takes integer k, integer i returns nothing
        local unit u = udg_hero[k]
        local integer g = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "unique" ) ) + i
        local boolean b = LoadBoolean( udg_hash, GetHandleId( u ), StringHash( "unique" ) )

        call SaveInteger( udg_hash, GetHandleId( u ), StringHash( "unique" ), g )

        if g >= 1 and not(b) then
            call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "unique" ), true )
            set udg_logic[59] = true
            call NewUniques( u, udg_Ability_Uniq[k] )
        elseif g < 1 and b then
            call SaveBoolean( udg_hash, GetHandleId( u ), StringHash( "unique" ), false )
            set udg_logic[59] = true
            call NewUniques( u, udg_Ability_Uniq[k] )
        endif

        set u = null
    endfunction

endlibrary