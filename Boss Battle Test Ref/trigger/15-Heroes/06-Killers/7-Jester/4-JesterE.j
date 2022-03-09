function Trig_JesterE_Conditions takes nothing returns boolean
    return combat( udg_DamageEventSource, false, 0 ) and not( udg_fightmod[3] ) and not( udg_IsDamageSpell ) and GetUnitAbilityLevel(udg_DamageEventSource, 'A0KB') > 0 and luckylogic( udg_DamageEventSource, 5 + ( 3 * GetUnitAbilityLevel(udg_DamageEventSource, 'A0KB') ), 1, 100 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
endfunction

function Trig_JesterE_Actions takes nothing returns nothing
    local unit u = udg_DamageEventSource
    local item it
    
    if inv( u, 'I0EO') > 0 then
        set it = GetItemOfTypeFromUnitBJ(u, 'I0EO')
        if BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) < 50 then
            call BlzSetItemIntegerFieldBJ( it, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(it, ITEM_IF_NUMBER_OF_CHARGES) + 1 )
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        endif
    elseif UnitInventoryCount(u) < 6 then
        call UnitAddItem(u, CreateItem( 'I0EO', GetUnitX( u ), GetUnitY(u)) )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) )
    endif
    
    set u = null
    set it = null
endfunction

//===========================================================================
function InitTrig_JesterE takes nothing returns nothing
    set gg_trg_JesterE = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_JesterE, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_JesterE, Condition( function Trig_JesterE_Conditions ) )
    call TriggerAddAction( gg_trg_JesterE, function Trig_JesterE_Actions )
endfunction

