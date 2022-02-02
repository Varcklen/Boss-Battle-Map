globals
    constant integer EARTHQUAKE_POTION_DURATION = 10
    
    constant string EARTHQUAKE_POTION_ANIMATION = "Abilities\\Spells\\Other\\Awaken\\Awaken.mdl"
endglobals

function Trig_Earthquake_Potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A166'
endfunction

function Earthquake_Heal takes unit caster returns nothing
    set udg_logic[52] = true
    call healst(caster, null, GetUnitState(caster, UNIT_STATE_MAX_LIFE))
    call PlaySpecialEffect( EARTHQUAKE_POTION_ANIMATION, caster )
    
    set caster = null
endfunction

function EarthquakePotCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "erth" ) )
    local integer pattern = LoadInteger( udg_hash, id, StringHash( "erth" ) )
    
    if IsUnitAlive(u) and pattern == udg_Pattern then
        call Earthquake_Heal( u )
    endif

    call DestroyTimer( GetExpiredTimer() )
    
    set u = null
endfunction

function Trig_Earthquake_Potion_Actions takes nothing returns nothing
    local integer id
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( "|cf0FF20FF Earthquake", caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    call potionst( caster )
    call Earthquake_Heal( caster )
    
    set id = InvokeTimerWithUnit(caster, "erth", EARTHQUAKE_POTION_DURATION, false, function EarthquakePotCast)
    call SaveInteger( udg_hash, id, StringHash( "erth" ), udg_Pattern )
 
    set caster = null
endfunction

//===========================================================================
function InitTrig_Earthquake_Potion takes nothing returns nothing
    set gg_trg_Earthquake_Potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Earthquake_Potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Earthquake_Potion, Condition( function Trig_Earthquake_Potion_Conditions ) )
    call TriggerAddAction( gg_trg_Earthquake_Potion, function Trig_Earthquake_Potion_Actions )
endfunction

