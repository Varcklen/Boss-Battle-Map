function Trig_AL_End_Conditions takes nothing returns boolean
    return udg_fightmod[4] and ( DeathIf(GetDyingUnit()) or GetUnitTypeId(GetDyingUnit()) == 'n00F' or GetUnitTypeId(GetDyingUnit()) == 'o006' )
endfunction

function Trig_AL_End_Actions takes nothing returns nothing
    local integer cyclA
    local integer cyclB
    local group g = CreateGroup()
    local unit u
    local integer m = GetPlayerId(GetOwningPlayer(GetDyingUnit())) + 1

    if udg_LvL[m] <= 5 then
        call DisplayTimedTextToPlayer( Player(m-1), 0, 0, 20, "|cffff0000Warning!|r |cffffcc00Death in this arena will not bring defeat.|r" )
    endif
    
    call GroupRemoveUnit( udg_otryad, GetDyingUnit() )
    call GroupAddUnit( udg_DeadHero, GetDyingUnit())
    set udg_Heroes_Deaths = udg_Heroes_Deaths + 1
    if GetUnitTypeId(GetDyingUnit()) == 'n00F' or GetUnitTypeId(GetDyingUnit()) == 'o006' then
        set udg_logic[41] = true
    endif
    if udg_Heroes_Deaths == udg_Heroes_Amount or GetUnitTypeId(GetDyingUnit()) == 'n00F' or GetUnitTypeId(GetDyingUnit()) == 'o006' then
        call GroupEnumUnitsInRect( g, udg_Boss_Rect, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if GetUnitTypeId( u ) == 'h00C' then
                call KillUnit( u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        set bj_livingPlayerUnitsTypeId = 'h00J'
        call GroupEnumUnitsOfPlayer(g, Player( 10 ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            call RemoveUnit( u )
            call GroupRemoveUnit(g,u)
        endloop
        
        call Between( "end_AL" )
        call DisableTrigger( GetTriggeringTrigger() )
        //set g = udg_Bosses
        //Отключает триггеры всех боссов, оставшихся на поле
        /*call GroupAddGroup( udg_Bosses, g )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            set s = 1
            set n = 1
            set k = 1
            set cyclA = 1
            set i = DB_Boss_id[1][1]
            loop
                exitwhen cyclA > 1
                if i == GetUnitTypeId( u ) then
                    set cyclB = 1
                    set l = false
                    loop
                        exitwhen l
                        set h = cyclB + ( ( s - 1 ) * 10 )
                        if DB_Trigger_Boss[n][h] != null and cyclB <= 10 then
                            call DisableTrigger( DB_Trigger_Boss[n][h] )
                            set cyclB = cyclB + 1
                        else
                            set l = true
                        endif
                    endloop
                elseif k < 500 then
                    set cyclA = cyclA - 1 
                    set s = s + 1
                    set i = DB_Boss_id[n][s]
                    if i == 0 then
                        set s = 1
                        set n = n + 1
                        set i = DB_Boss_id[n][s]
                    endif
                endif
                set k = k + 1
                set cyclA = cyclA + 1
            endloop
            call RemoveUnit( u )
            call GroupRemoveUnit(g,u)
        endloop*/
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_AL_End takes nothing returns nothing
    set gg_trg_AL_End = CreateTrigger(  )
    call DisableTrigger( gg_trg_AL_End )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AL_End, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_AL_End, Condition( function Trig_AL_End_Conditions ) )
    call TriggerAddAction( gg_trg_AL_End, function Trig_AL_End_Actions )
endfunction

