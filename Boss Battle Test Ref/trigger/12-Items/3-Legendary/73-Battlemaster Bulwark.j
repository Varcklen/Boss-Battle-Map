globals
    constant real BATTLEMASTER_BULWARK_SHIELD_BONUS = 0.4
endglobals

function Trig_Battlemaster_Bulwark_Conditions takes nothing returns boolean
    return udg_DamageEventAmount > 0 and IsHeroHasItem( udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1], 'I0GO') and (GetUnitTypeId(udg_DamageEventSource) == 'u000' or IsUnitType( udg_DamageEventSource, UNIT_TYPE_HERO))
endfunction

function Trig_Battlemaster_Bulwark_Actions takes nothing returns nothing
    local unit hero = udg_hero[GetPlayerId( GetOwningPlayer(udg_DamageEventSource) ) + 1]
    
    call shield(hero, hero, udg_DamageEventAmount*BATTLEMASTER_BULWARK_SHIELD_BONUS, 60 )
    
    set hero = null
endfunction

//===========================================================================
function InitTrig_Battlemaster_Bulwark takes nothing returns nothing
    set gg_trg_Battlemaster_Bulwark = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Battlemaster_Bulwark, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Battlemaster_Bulwark, Condition( function Trig_Battlemaster_Bulwark_Conditions ) )
    call TriggerAddAction( gg_trg_Battlemaster_Bulwark, function Trig_Battlemaster_Bulwark_Actions )
endfunction

