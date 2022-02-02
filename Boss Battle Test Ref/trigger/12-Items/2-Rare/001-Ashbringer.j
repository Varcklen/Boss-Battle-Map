function Trig_Ashbringer_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0GI' and combat( GetSpellAbilityUnit(), true, 'A0GI' )
endfunction

function Trig_Ashbringer_Actions takes nothing returns nothing
    local group g = CreateGroup()
    local unit u
    local integer cyclA = 1
    local integer cyclAEnd 
    local unit caster
    local real dmg
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0GI'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd =  eyest( caster )
    set dmg = 100. + ( ( SetCount_GetPieces(caster, SET_MECH) - 1 ) * 100. ) 
    
    call dummyspawn( caster, 1, 0, 0, 0 )
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", caster, "origin" ) )
    loop
        exitwhen cyclA > cyclAEnd
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 5000, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
            endif
            call GroupRemoveUnit(g,u)
        endloop
        set cyclA = cyclA + 1
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Ashbringer takes nothing returns nothing
    set gg_trg_Ashbringer = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Ashbringer, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Ashbringer, Condition( function Trig_Ashbringer_Conditions ) )
    call TriggerAddAction( gg_trg_Ashbringer, function Trig_Ashbringer_Actions )
endfunction

