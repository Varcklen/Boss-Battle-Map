function Trig_OrbDesecrated_Land_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A193'
endfunction

function Trig_OrbDesecrated_Land_Actions takes nothing returns nothing
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
        set target = randomtarget( caster, 900, "ally", "", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A193'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
        set t = 10
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set t = 10
    endif
    set t = timebonus(caster, t)
    
    set x = eyest( caster )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", target, "origin" ) )
    call GroupEnumUnitsInRange( g, GetUnitX( target ), GetUnitY( target ), 450, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call taunt( target, u, t )
        endif
        call GroupRemoveUnit(g,u)
    endloop
    if not( IsUnitType(target, UNIT_TYPE_ANCIENT ) ) and not( IsUnitType(target, UNIT_TYPE_HERO ) ) then
        call BlzSetUnitArmor( target, BlzGetUnitArmor(target)+BlzGetUnitArmor(caster) )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OrbDesecrated_Land takes nothing returns nothing
    set gg_trg_OrbDesecrated_Land = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OrbDesecrated_Land, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OrbDesecrated_Land, Condition( function Trig_OrbDesecrated_Land_Conditions ) )
    call TriggerAddAction( gg_trg_OrbDesecrated_Land, function Trig_OrbDesecrated_Land_Actions )
endfunction

