function Trig_KingQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0PR'
endfunction

function Trig_KingQ_GhoulSummon takes unit caster, unit target, real life returns nothing
    set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u01K', GetUnitX( target ) + GetRandomReal( 0, 200 ), GetUnitY( target ) + GetRandomReal( 0, 200 ), GetRandomReal( 0, 360 ) )
    call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', life )
    call DestroyEffect(AddSpecialEffectTarget("war3mapImported\\SoulRitual.mdx", bj_lastCreatedUnit, "origin"))
    call IssueTargetOrder( bj_lastCreatedUnit, "attack", target )
endfunction

function Trig_KingQ_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local group g = CreateGroup()
    local unit u
    local integer life
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0PR'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set life = 6 + (lvl*2)
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "enemy" ) then
            call dummyspawn( caster, 1, 'A0PQ', 0, 0 )
            call SetUnitAbilityLevel( bj_lastCreatedUnit, 'A0PQ', lvl )
            call IssueTargetOrder( bj_lastCreatedUnit, "ensnare", u )
            call Trig_KingQ_GhoulSummon(caster, u, life)
            call Trig_KingQ_GhoulSummon(caster, u, life)
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_KingQ takes nothing returns nothing
    set gg_trg_KingQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_KingQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_KingQ, Condition( function Trig_KingQ_Conditions ) )
    call TriggerAddAction( gg_trg_KingQ, function Trig_KingQ_Actions )
endfunction

