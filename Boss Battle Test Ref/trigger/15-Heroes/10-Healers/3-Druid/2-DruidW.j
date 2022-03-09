globals
    constant integer DRUID_W_DURATION = 20
    constant integer DRUID_W_HEAL_FIRST_LEVEL = 25
    constant integer DRUID_W_HEAL_LEVEL_BONUS = 50
    
    constant integer DRUID_W_AREA_ALTERNATIVE = 400
endglobals

function Trig_DruidW_Conditions takes nothing returns boolean
    return GetSpellAbilityId( ) == 'A0JC'
endfunction

function DruidW_Alternative takes unit caster, unit target, real duration, integer level returns nothing
    local group g = CreateGroup()
    local unit u
    
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), DRUID_W_AREA_ALTERNATIVE, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, TARGET_ALLY ) then
            call bufallst( caster, u, 'A0U8', 'A0JD', 0, 0, 0, 'B005', "druw", duration )
            call SetUnitAbilityLevel( u, 'A0JD', level )
            call effst( caster, u, "Trig_DruidW_Actions", 1, duration )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

function DruidW takes unit caster, unit target, real duration, integer level, real heal returns nothing
    call healst( caster, target, heal )

    call bufallst( caster, target, 'A0U8', 'A0JD', 0, 0, 0, 'B005', "druw", duration )
    call SetUnitAbilityLevel( target, 'A0JD', level )
    call effst( caster, target, "Trig_DruidW_Actions", 1, duration )
    
    set caster = null
    set target = null
endfunction

function Trig_DruidW_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local real t
    local real heal
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0JC'), caster, 64, 90, 10, 1.5 )
        set t = DRUID_W_DURATION
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = DRUID_W_DURATION
    endif
    
    set heal = DRUID_W_HEAL_FIRST_LEVEL + ( DRUID_W_HEAL_LEVEL_BONUS * lvl )
    
    if Aspects_IsHeroAspectActive(caster, ASPECT_02 ) then
        call DruidW_Alternative(caster,  target, t, lvl )
    else
        call DruidW(caster,  target, t, lvl, heal )
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_DruidW takes nothing returns nothing
    set gg_trg_DruidW = CreateTrigger( )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DruidW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DruidW, Condition( function Trig_DruidW_Conditions ) )
    call TriggerAddAction( gg_trg_DruidW, function Trig_DruidW_Actions )
endfunction

scope DruidW initializer Triggs
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0U8') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'A0U8' )
        call UnitRemoveAbility( hero, 'A0JD' )
        call UnitRemoveAbility( hero, 'B005' )
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

