function Trig_Goat_Dragon_Claw_Conditions takes nothing returns boolean
    return not( udg_IsDamageSpell ) and combat( udg_DamageEventSource, false, 0 ) and luckylogic( udg_DamageEventSource, 10, 1, 100 ) and ( inv( udg_DamageEventSource, 'I0GA') > 0 or ( inv( udg_DamageEventSource, 'I030') > 0 and udg_Set_Weapon_Logic[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1 + 108] ) )
endfunction

function Trig_Goat_Dragon_Claw_Actions takes nothing returns nothing
    local unit u = udg_hero[GetPlayerId(GetOwningPlayer(udg_DamageEventSource)) + 1]
    local integer id = GetHandleId( u )
    local integer k = LoadInteger( udg_hash, id, StringHash( "dgca" ) )
    local integer i = GetPlayerId(GetOwningPlayer(u)) + 1
    
    if k < 10 then
        call UnitAddAbility( u, 'A1AH' )
        set k = k + 1
        call SaveInteger( udg_hash, id, StringHash( "dgca" ), k )
        call SpellUniqueUnit(u, 20)
        call textst( "|cff60C445 +" + I2S(k*20) + "%", u, 64, 90, 10, 1 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Goat_Dragon_Claw takes nothing returns nothing
    set gg_trg_Goat_Dragon_Claw = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Goat_Dragon_Claw, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Goat_Dragon_Claw, Condition( function Trig_Goat_Dragon_Claw_Conditions ) )
    call TriggerAddAction( gg_trg_Goat_Dragon_Claw, function Trig_Goat_Dragon_Claw_Actions )
endfunction

