function Trig_Endgame_Conditions takes nothing returns boolean
    return not( udg_fightmod[0] ) and udg_logic[43]
endfunction

function Trig_Endgame_Actions takes nothing returns nothing
    local integer v = IMinBJ(6, udg_HardNum+2)
    local integer p
    local integer i

    call DisplayTimedTextToForce( GetPlayersAll(), 5.00, "Endgame mode №" +I2S(R2I(udg_Endgame)) + " enabled." )

    set udg_HardNum = v
    set p = udg_DB_Hardest_On[udg_HardNum]
    call IconFrame( "HardMode", BlzGetAbilityIcon(p), BlzGetAbilityTooltip(p, 0), BlzGetAbilityExtendedTooltip(p, 0) )
    call EnableTrigger( gg_trg_HardModActive )
	call RemoveUnit( udg_Portal ) 
    call StopMusic(false)
    call PlayThematicMusic( "music" )
	set udg_Endgame = udg_Endgame + 2
	set udg_SpellDamage[0] = udg_SpellDamage[0] + 2
	set udg_logic[43] = false
	set udg_Boss_LvL = 1
	set udg_Boss_Random = GetRandomInt( 1, 5 )
	set udg_Player_Readiness = udg_Heroes_Amount
    call TriggerExecute( gg_trg_StartFight )
endfunction

//===========================================================================
function InitTrig_Endgame takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Endgame = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Endgame, Player(cyclA), "-endgame", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Endgame, Condition( function Trig_Endgame_Conditions ) )
    call TriggerAddAction( gg_trg_Endgame, function Trig_Endgame_Actions )
endfunction