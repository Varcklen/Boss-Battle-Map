function Trig_ifrange_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetOwningPlayer(udg_hero[1])) + 1
    local integer ab = udg_DB_Hero_FirstSpell[udg_HeroNum[i]]


	call DisplayTimedTextToForce( GetPlayersAll(), 5.00, R2S(BlzGetAbilityRealLevelField(BlzGetUnitAbility(udg_hero[1], ab), ABILITY_RLF_CAST_RANGE, 0)) )
endfunction

//===========================================================================
function InitTrig_ifrange takes nothing returns nothing
    set gg_trg_ifrange = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_ifrange, Player(0), "1", true )
    call TriggerAddAction( gg_trg_ifrange, function Trig_ifrange_Actions )
endfunction

