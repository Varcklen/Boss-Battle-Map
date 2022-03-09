function Trig_GamblerQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11U' or GetSpellAbilityId() == 'A0YG'
endfunction

function Trig_GamblerQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local real dmg 
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A11U'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(udg_hero[GetPlayerId(GetOwningPlayer( caster ) ) + 1], 'A11U' )
    endif
    
    set dmg = 40 + ( 30 * lvl )
    if combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
    	call moneyst( caster, 10 + ( 5 * lvl ) )
    endif
    call DestroyEffect( AddSpecialEffect( "BarbarianSkinW.mdx", GetUnitX(caster), GetUnitY(caster) ) )
    call dummyspawn( caster, 1, 0, 0, 0 )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 300, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            	call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_GamblerQ takes nothing returns nothing
    set gg_trg_GamblerQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_GamblerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_GamblerQ, Condition( function Trig_GamblerQ_Conditions ) )
    call TriggerAddAction( gg_trg_GamblerQ, function Trig_GamblerQ_Actions )
endfunction

