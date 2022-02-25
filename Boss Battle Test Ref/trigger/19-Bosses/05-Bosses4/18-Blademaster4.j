function Trig_Blademaster4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e001' and GetUnitLifePercent(udg_DamageEventTarget) <= 40
endfunction

function Trig_Blademaster4_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer i = 0
    
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "BarbarianSkinW.mdx", udg_DamageEventTarget, "origin") )
    
    call GroupEnumUnitsInRange( g, GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, udg_DamageEventTarget, "enemy") and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            call DestroyEffect( AddSpecialEffect( "BarbarianSkinQ.mdx", GetUnitX(u), GetUnitY(u) ) )
            call KillUnit( u )
            set i = i + 60
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    if i > 0 then
          call SetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE, GetUnitState( udg_DamageEventTarget, UNIT_STATE_LIFE ) + (i*SpellPower_GetBossSpellPower()) )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Blademaster4 takes nothing returns nothing
    set gg_trg_Blademaster4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Blademaster4 )
    call TriggerRegisterVariableEvent( gg_trg_Blademaster4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Blademaster4, Condition( function Trig_Blademaster4_Conditions ) )
    call TriggerAddAction( gg_trg_Blademaster4, function Trig_Blademaster4_Actions )
endfunction

