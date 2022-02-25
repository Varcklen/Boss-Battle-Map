function Trig_Love_potion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00Q'
endfunction

function Trig_Love_potion_Actions takes nothing returns nothing
    local integer x
    local unit caster
    local unit target
    local group g = CreateGroup()
    local unit u
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "all", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A00Q'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
        set t = 8
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 8
    endif
    set t = timebonus(caster, t)
    
    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", target, "origin" ) )
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 450, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) and target != u then
            call taunt( target, u, t )
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

//===========================================================================
function InitTrig_Love_potion takes nothing returns nothing
    set gg_trg_Love_potion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Love_potion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Love_potion, Condition( function Trig_Love_potion_Conditions ) )
    call TriggerAddAction( gg_trg_Love_potion, function Trig_Love_potion_Actions )
endfunction

