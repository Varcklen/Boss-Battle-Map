function Trig_BannerA_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell )  and inv(udg_DamageEventSource, 'I047') > 0 and combat( udg_DamageEventSource, false, 0 ) and not( udg_fightmod[3] ) and luckylogic( udg_DamageEventSource, 2, 1, 100 )
endfunction

function Trig_BannerA_Actions takes nothing returns nothing
    local integer rand = GetRandomInt(1, 3)

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", udg_DamageEventSource, "origin") )
    if rand == 1 then
        call statst( udg_DamageEventSource, 1, 0, 0, 24, true )
        call textst( "|c00FF2020 +1 strength", udg_DamageEventSource, 64, 90, 10, 1 )
    elseif rand == 2 then
        call statst( udg_DamageEventSource, 0, 1, 0, 28, true )
        call textst( "|c0020FF20 +1 agility", udg_DamageEventSource, 64, 90, 10, 1 )
    elseif rand == 3 then
        call statst( udg_DamageEventSource, 0, 0, 1, 32, true )
        call textst( "|c002020FF +1 intelligence", udg_DamageEventSource, 64, 90, 10, 1 )
    endif
endfunction

//===========================================================================
function InitTrig_BannerA takes nothing returns nothing
    set gg_trg_BannerA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_BannerA, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_BannerA, Condition( function Trig_BannerA_Conditions ) )
    call TriggerAddAction( gg_trg_BannerA, function Trig_BannerA_Actions )
endfunction

