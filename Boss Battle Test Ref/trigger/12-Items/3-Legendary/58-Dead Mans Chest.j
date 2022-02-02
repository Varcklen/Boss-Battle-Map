function Trig_Dead_Mans_Chest_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00H' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Dead_Mans_Chest_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer i
    local integer n
    local integer m
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A00H'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set i = 0
        set cyclB = 1
        call KillUnit( LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "dmch" ) ) )
        loop
            exitwhen cyclB > 1
            set m = GetRandomInt( 1, 4 )
            set n = GetRandomInt( 1, 5 )
            if CountUnitsInGroup(GetUnitsOfTypeIdAll(DB_Boss_id[m][n])) == 0 and i < 30 then
                set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), DB_Boss_id[m][n], GetUnitX( caster ) + GetRandomReal(-200, 200), GetUnitY( caster ) + GetRandomReal(-200, 200), GetRandomReal( 0, 360) )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", bj_lastCreatedUnit, "origin" ) )
                call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 60 )
                call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "dmch" ), bj_lastCreatedUnit )
            else
                set cyclB = cyclB - 1
            endif
            set cyclB = cyclB + 1
            set i = i + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Dead_Mans_Chest takes nothing returns nothing
    set gg_trg_Dead_Mans_Chest = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dead_Mans_Chest, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Dead_Mans_Chest, Condition( function Trig_Dead_Mans_Chest_Conditions ) )
    call TriggerAddAction( gg_trg_Dead_Mans_Chest, function Trig_Dead_Mans_Chest_Actions )
endfunction

