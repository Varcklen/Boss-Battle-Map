function Trig_Orb_of_Shadow_Conditions takes nothing returns boolean
    if (GetUnitAbilityLevel( udg_DamageEventSource, 'B029') > 0 or inv( udg_DamageEventSource, 'I0FU') > 0) == false then
        return false
    elseif IsUnitType( udg_DamageEventTarget, UNIT_TYPE_HERO) then
        return false
    elseif IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT) then
        return false
    elseif udg_IsDamageSpell then
        return false
    elseif luckylogic( udg_DamageEventSource, 8, 1, 100 ) == false then
        return false
    elseif IsUnitDead(udg_DamageEventTarget) then
        return false
    endif

    return true
endfunction

function Trig_Orb_of_Shadow_Actions takes nothing returns nothing
    call PlaySpecialEffect("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", udg_DamageEventTarget)
    if GetUnitTypeId( udg_DamageEventTarget ) != 'u00X' then
        call SetUnitOwner( udg_DamageEventTarget, GetOwningPlayer(udg_DamageEventSource), true )
        call UnitApplyTimedLife( udg_DamageEventTarget, 'BTLF', 30 )
    endif
endfunction

//===========================================================================
function InitTrig_Orb_of_Shadow takes nothing returns nothing
    call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Orb_of_Shadow_Actions, function Trig_Orb_of_Shadow_Conditions )//udg_DamageEvent
endfunction

