function Trig_GhostKnight4_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'n008' and GetUnitLifePercent(udg_DamageEventTarget) <= 20
endfunction

function Trig_GhostKnight4_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    call DisableTrigger( GetTriggeringTrigger() )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", udg_DamageEventTarget, "origin") )
    
    call GroupEnumUnitsInRange( g, GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, udg_DamageEventTarget, "enemy" ) and not( IsUnitType( u, UNIT_TYPE_HERO) ) and not( IsUnitType( u, UNIT_TYPE_ANCIENT) ) and GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            call SetUnitOwner( u, GetOwningPlayer(udg_DamageEventTarget), true )
            call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", u, "origin") )
        endif
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_GhostKnight4 takes nothing returns nothing
    set gg_trg_GhostKnight4 = CreateTrigger(  )
    call DisableTrigger( gg_trg_GhostKnight4 )
    call TriggerRegisterVariableEvent( gg_trg_GhostKnight4, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_GhostKnight4, Condition( function Trig_GhostKnight4_Conditions ) )
    call TriggerAddAction( gg_trg_GhostKnight4, function Trig_GhostKnight4_Actions )
endfunction

