function Trig_BossDamage_Conditions takes nothing returns boolean
    return IsUnitInGroup(udg_DamageEventTarget, udg_Bosses)
endfunction

globals
    real array dps[5][11]//герой/позиция
endglobals

function BossDamageCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local integer i = LoadInteger( udg_hash, id, StringHash( "bssd" ) ) + 1
    local integer n = LoadInteger( udg_hash, id, StringHash( "bssdn" ) ) + 1
    local integer dmg = LoadInteger( udg_hash, id, StringHash( "bssdd" ) ) + 1
    local integer cyclA
    local integer cyclB
    local real m
    
    set udg_Info_Time = udg_Info_Time + 1
    if udg_fightmod[0] and not(udg_fightmod[3]) then
        call SaveInteger( udg_hash, id, StringHash( "bssd" ), i )
        if not(udg_fightmod[4]) and udg_logic[73] then
            call SaveInteger( udg_hash, id, StringHash( "bssdn" ), n )
            if n >= 3 then
                call SaveInteger( udg_hash, id, StringHash( "bssdn" ), 0 )
                call SaveInteger( udg_hash, id, StringHash( "bssdd" ), dmg )
                if udg_real[0] > 0 then
                    set udg_real[0] = udg_real[0] - 0.01
                    if udg_real[0] <= 0 then
                        set udg_real[0] = 0
                    endif
                endif
                set cyclA = 1
                loop
                    exitwhen cyclA > 4
                    if GetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 then
                        call SetUnitState( udg_hero[cyclA], UNIT_STATE_LIFE, GetUnitState( udg_hero[cyclA], UNIT_STATE_MAX_LIFE) * RMaxBJ(0,GetUnitStatePercent( udg_hero[cyclA], UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) - dmg ) * 0.01)
                        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", GetUnitX( udg_hero[cyclA] ), GetUnitY( udg_hero[cyclA] ) ) )
                    endif
                    set cyclA = cyclA + 1
                endloop
            endif
        endif
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if IsUnitAlive( udg_hero[cyclA]) then
                if not( udg_logic[43] ) then
                    set udg_dpsnum[cyclA] = udg_dpsnum[cyclA] + 1
                    if udg_dpsnum[cyclA] > 10 then
                        set udg_dpsnum[cyclA] = 1
                    endif
                    set dps[cyclA][udg_dpsnum[cyclA]] = udg_DamageFight[cyclA] - udg_dpslast[cyclA]
                    set udg_dpslast[cyclA] = udg_DamageFight[cyclA]
                
                    set udg_DPS[cyclA] = 0
                    set cyclB = 1
                    loop
                        exitwhen cyclB > 10
                        set udg_DPS[cyclA] = udg_DPS[cyclA] + dps[cyclA][cyclB]
                        set cyclB = cyclB + 1
                    endloop
                    set udg_DPS[cyclA] = udg_DPS[cyclA] / 10
                    if udg_DPS[cyclA] > udg_DPSMax[cyclA] then
                        set udg_DPSMax[cyclA] = udg_DPS[cyclA]
                    endif
                    call MultiSetValue( udg_multi, ( udg_Multiboard_Position[cyclA] * 3 ) - 1, 8, I2S(R2I(udg_DPS[cyclA])) )
                endif
            endif
            set cyclA = cyclA + 1
        endloop
    else
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
endfunction

function BossDamageTimer takes nothing returns nothing
    local integer cyclA = 0
    
    set udg_logic[73] = true
    loop
        exitwhen cyclA > 3
        if GetPlayerSlotState(Player(cyclA)) == PLAYER_SLOT_STATE_PLAYING then
            call DisplayTimedTextToPlayer(Player(cyclA), 0, 0, 10., "|cffffcc00Warning!|r Battle limit exceeded! The health of the heroes begins to gradually decline.")
        endif
        set cyclA = cyclA + 1
    endloop
    call StartSound(gg_snd_Warning)
    call TimerDialogDisplay( udg_timerdialog[0], false )
    call FlushChildHashtable( udg_hash, GetHandleId( GetExpiredTimer( ) ) )
endfunction

function Trig_BossDamage_Actions takes nothing returns nothing
    local integer id = GetHandleId( gg_unit_u00F_0006 )
    
    call DisableTrigger( GetTriggeringTrigger() )
        
    if LoadTimerHandle( udg_hash, id, StringHash( "bssd" ) ) == null  then
        call SaveTimerHandle( udg_hash, id, StringHash( "bssd" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssd" ) ) ) 
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_u00F_0006 ), StringHash( "bssd" ) ), 1, true, function BossDamageCast )
    
    if not( udg_fightmod[4] ) or udg_logic[72] then
        set udg_logic[72] = false
        set id = GetHandleId( gg_unit_u00F_0006 )
        if LoadTimerHandle( udg_hash, id, StringHash( "bssdtimer" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "bssdtimer" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "bssdtimer" ) ) ) 
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_u00F_0006 ), StringHash( "bssdtimer" ) ), udg_timelimit, false, function BossDamageTimer )
        set udg_timerdialog[0] = CreateTimerDialog( LoadTimerHandle( udg_hash, GetHandleId( gg_unit_u00F_0006 ), StringHash( "bssdtimer" ) ) )
        call TimerDialogSetTitle(udg_timerdialog[0], "Battle limit:" )
        call TimerDialogDisplay(udg_timerdialog[0], true)
    endif
endfunction

//===========================================================================
function InitTrig_BossDamage takes nothing returns nothing
    set gg_trg_BossDamage = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_BossDamage, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_BossDamage, Condition( function Trig_BossDamage_Conditions ) )
    call TriggerAddAction( gg_trg_BossDamage, function Trig_BossDamage_Actions )
endfunction

