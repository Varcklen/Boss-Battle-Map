function Trig_ShoggothQxzx_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0A2'
endfunction

function Trig_ShoggothQxzx_Actions takes nothing returns nothing
    local real x 
    local real y
    local real dmg 
    local group g = CreateGroup()
    local unit u
    local integer id 
    local integer lvl
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0A2'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif
    
    set x = GetUnitX( caster ) + 300 * Cos( 0.017 * GetUnitFacing( caster ) )
    set y = GetUnitY( caster ) + 300 * Sin( 0.017 * GetUnitFacing( caster ) )
    set dmg = 50 + ( 50 * lvl ) 

    call GroupEnumUnitsInRange( g, x, y, 350, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( u ), GetUnitY( u ), bj_UNIT_FACING )
            call UnitAddAbility( bj_lastCreatedUnit, 'A0JR' )
            call DestroyEffect( AddSpecialEffect( "war3mapImported\\Soul Discharge Purple.mdx", GetUnitX(u), GetUnitY(u) ) )
            call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
            if GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call IssueTargetOrder( bj_lastCreatedUnit, "ensnare", u )
                if GetUnitDefaultMoveSpeed(u) != 0 then
                    call SetUnitPosition( u, GetUnitX(caster), GetUnitY(caster) )
                endif
                call SaveUnitHandle( udg_hash, GetHandleId( u ), StringHash( "shgtq" ), caster )
            endif
            if BuffLogic() then
                call debuffst( caster, u, null, lvl, 4 )
            endif
        endif
        call GroupRemoveUnit(g,u)
        set u = FirstOfGroup(g)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_ShoggothQxzx takes nothing returns nothing
    set gg_trg_ShoggothQxzx = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothQxzx, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_ShoggothQxzx, Condition( function Trig_ShoggothQxzx_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothQxzx, function Trig_ShoggothQxzx_Actions )
endfunction

