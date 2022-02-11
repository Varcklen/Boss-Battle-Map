function Trig_PrismPurple_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0IX'
endfunction

function Trig_PrismPurple_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0IX'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd =  eyest( caster )
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffect( "war3mapImported\\ArcaneExplosion.mdx", GetUnitX(caster), GetUnitY(caster) ) )
    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 450, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, 250, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_PrismPurple takes nothing returns nothing
    set gg_trg_PrismPurple = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PrismPurple, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PrismPurple, Condition( function Trig_PrismPurple_Conditions ) )
    call TriggerAddAction( gg_trg_PrismPurple, function Trig_PrismPurple_Actions )
endfunction

