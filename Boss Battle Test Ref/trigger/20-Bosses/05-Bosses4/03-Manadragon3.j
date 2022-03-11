function Trig_Manadragon3_Conditions takes nothing returns boolean
    return GetUnitTypeId( udg_DamageEventTarget ) == 'e004' and GetUnitLifePercent(udg_DamageEventTarget) <= 25
endfunction

function Trig_Manadragon3_Actions takes nothing returns nothing
   local integer id = GetHandleId( udg_DamageEventTarget )
    local group g = CreateGroup()
    local unit u
   
    call DisableTrigger( GetTriggeringTrigger() )
    call GroupEnumUnitsInRange( g, GetUnitX( udg_DamageEventTarget ), GetUnitY( udg_DamageEventTarget ), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, udg_DamageEventTarget, "enemy" ) and IsUnitType( u, UNIT_TYPE_HERO) then
            call SetUnitState( u, UNIT_STATE_MANA, 0 )
            call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\NightElf\\NECancelDeath\\NECancelDeath.mdl", u, "origin" ) )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call DestroyTimer( LoadTimerHandle( udg_hash, id, StringHash( "bsmd" ) ) )
    call FlushChildHashtable( udg_hash, id )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
endfunction

//===========================================================================
function InitTrig_Manadragon3 takes nothing returns nothing
    set gg_trg_Manadragon3 = CreateTrigger(  )
    call DisableTrigger( gg_trg_Manadragon3 )
    call TriggerRegisterVariableEvent( gg_trg_Manadragon3, "udg_AfterDamageEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Manadragon3, Condition( function Trig_Manadragon3_Conditions ) )
    call TriggerAddAction( gg_trg_Manadragon3, function Trig_Manadragon3_Actions )
endfunction

