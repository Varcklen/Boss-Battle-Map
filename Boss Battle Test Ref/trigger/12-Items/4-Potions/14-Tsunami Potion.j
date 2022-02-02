globals
    constant integer TSUNAMI_POTION_DURATION = 10
    
    constant string TSUNAMI_POTION_ANIMATION = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
endglobals

function Trig_Tsunami_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A168'
endfunction

function Tsunami_Heal takes unit caster returns nothing
    call manast(caster, null, GetUnitState(caster, UNIT_STATE_MAX_MANA))
    call PlaySpecialEffect( TSUNAMI_POTION_ANIMATION, caster )
    
    set caster = null
endfunction

function TsunamiPotCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "tsnm" ) )
    local integer pattern = LoadInteger( udg_hash, id, StringHash( "tsnm" ) )
    
    if IsUnitAlive(u) and pattern == udg_Pattern then
        call Tsunami_Heal( u )
    endif

    call DestroyTimer( GetExpiredTimer() )
    
    set u = null
endfunction

function Trig_Tsunami_Potion_Actions takes nothing returns nothing
    local integer id
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf020FFFF Tsunami", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    call potionst( caster )
    call Tsunami_Heal( caster )
    
    set id = InvokeTimerWithUnit(caster, "tsnm", TSUNAMI_POTION_DURATION, false, function TsunamiPotCast)
    call SaveInteger( udg_hash, id, StringHash( "tsnm" ), udg_Pattern )
 
    set caster = null
endfunction

//===========================================================================
function InitTrig_Tsunami_Potion takes nothing returns nothing
    set gg_trg_Tsunami_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Tsunami_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Tsunami_Potion, Condition( function Trig_Tsunami_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Tsunami_Potion, function Trig_Tsunami_Potion_Actions )
endfunction

