function Trig_Sacrifice_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1AE'
endfunction

function Trig_Sacrifice_Actions takes nothing returns nothing
    local integer cyclA
    local unit caster
    local item it
    local boolean l = false
    local group g = CreateGroup()
    local unit u
    local effect fx

    if CastLogic() then
        set caster = udg_Caster
        set it = null
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A1AE'), caster, 64, 90, 10, 1.5 )
        set it = null
    else
        set caster = GetSpellAbilityUnit()
        set it = GetSpellTargetItem()
    endif

    set cyclA = 0
    loop
        exitwhen cyclA > 5
        if it == UnitItemInSlot( caster, cyclA ) then
            if combat( caster, false, 0 ) and not(udg_fightmod[3]) then
                call RemoveItem( it )
            endif
            set cyclA = 5
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    
    if l then
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, GetUnitX(caster), GetUnitY(caster), 500, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                set fx = AddSpecialEffect("Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", GetUnitX(u), GetUnitY(u) )
                call BlzSetSpecialEffectScale( fx, 2 )
                call DestroyEffect( fx )
                call UnitDamageTarget( bj_lastCreatedUnit, u, 450, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set fx = null
    set it = null
endfunction

//===========================================================================
function InitTrig_Sacrifice takes nothing returns nothing
    set gg_trg_Sacrifice = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sacrifice, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sacrifice, Condition( function Trig_Sacrifice_Conditions ) )
    call TriggerAddAction( gg_trg_Sacrifice, function Trig_Sacrifice_Actions )
endfunction

