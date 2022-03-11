globals
    constant integer THIEF_VIST_CHANCE = 10
    constant integer THIEF_VIST_GOLD = 30
endglobals

function Trig_Thiefs_Vest_Conditions takes nothing returns boolean
    if udg_IsDamageSpell then
        return false
    elseif udg_fightmod[3] then
        return false
    elseif IsHeroHasItem(udg_DamageEventSource, 'I0CV') == false then
        return false
    elseif combat( udg_DamageEventSource, false, 0 ) == false then
        return false
    elseif IsUnitEnemy( udg_DamageEventSource, GetOwningPlayer( udg_DamageEventTarget ) ) == false then
        return false
    elseif luckylogic( udg_DamageEventSource, THIEF_VIST_CHANCE, 1, 100 ) == false then
        return false
    endif
    return true
endfunction

function Trig_Thiefs_Vest_Actions takes nothing returns nothing
    call moneyst(udg_DamageEventSource, THIEF_VIST_GOLD)
endfunction

//===========================================================================
function InitTrig_Thiefs_Vest takes nothing returns nothing
    set gg_trg_Thiefs_Vest = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Thiefs_Vest, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Thiefs_Vest, Condition( function Trig_Thiefs_Vest_Conditions ) )
    call TriggerAddAction( gg_trg_Thiefs_Vest, function Trig_Thiefs_Vest_Actions )
endfunction

