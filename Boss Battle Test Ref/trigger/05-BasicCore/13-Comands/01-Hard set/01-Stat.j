function Trig_Stat_Conditions takes nothing returns boolean
    return not( udg_fightmod[0] )
endfunction

function Trig_Stat_Actions takes nothing returns nothing
    local integer k = GetPlayerId(GetTriggerPlayer()) + 1

	if udg_BossChange then
    		call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "CHANGED" )
	endif
    	call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Enemy health:|r " + I2S( R2I((udg_BossHP*100)) ) + "%." )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Enemy attack power:|r " + I2S( R2I((udg_BossAT*100)) ) + "%." )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Enemy spell power:|r " + I2S( R2I((udg_SpellDamage[0]*100)) ) + "%." )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Health and mana healing:|r " + I2S( R2I((udg_BossHeal[k]*100)) ) + "%." )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Physical damage:|r " + I2S( R2I(((udg_BossDamagePhysical[k]+1)*100)) ) + "%." )
        call DisplayTimedTextToForce( GetForceOfPlayer(GetTriggerPlayer()), 10, "|cffffcc00Magical damage:|r " + I2S( R2I(((udg_BossDamageMagical[k]+1)*100)) ) + "%." )
endfunction

//===========================================================================
function InitTrig_Stat takes nothing returns nothing
    local integer cyclA = 0
    set gg_trg_Stat = CreateTrigger()
    loop
        exitwhen cyclA > 3
        call TriggerRegisterPlayerChatEvent( gg_trg_Stat, Player(cyclA), "-stat", true )
        set cyclA = cyclA + 1
    endloop
    call TriggerAddCondition( gg_trg_Stat, Condition( function Trig_Stat_Conditions ) )
    call TriggerAddAction( gg_trg_Stat, function Trig_Stat_Actions )
endfunction