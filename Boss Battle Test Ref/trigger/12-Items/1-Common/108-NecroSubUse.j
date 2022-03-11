function Trig_NecroSubUse_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 4
        if GetSpellAbilityId() == 'AA01' + cyclA then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_NecroSubUse_Actions takes nothing returns nothing
    local unit caster
    local integer cyclA
    local integer cyclAEnd
    local integer lvl

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('AA01'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set lvl = LoadInteger( udg_hash,  GetHandleId(GetItemOfTypeFromUnitBJ( caster, 'I022')), StringHash( "undslvl" ) )

    set cyclA = 1
    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer( caster ), 'u00H', GetUnitX( caster ) + GetRandomReal( -200, 200 ), GetUnitY( caster ) + GetRandomReal( -200, 200 ), GetRandomReal( 0, 360 ) )
        call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
        call QueueUnitAnimationBJ( bj_lastCreatedUnit, "stand" )
        call UnitApplyTimedLife( bj_lastCreatedUnit, 'BTLF', 40 )
        call DestroyEffect( AddSpecialEffect( "war3mapImported\\SoulRitual.mdx", GetUnitX( bj_lastCreatedUnit ), GetUnitY( bj_lastCreatedUnit ) ) )
        
        call BlzSetUnitMaxHP( bj_lastCreatedUnit, 420+(210*lvl) )
        call BlzSetUnitArmor( bj_lastCreatedUnit, lvl+1 )
        call BlzSetUnitBaseDamage( bj_lastCreatedUnit, 41+(21*lvl), 0 )
        call SetUnitState( bj_lastCreatedUnit, UNIT_STATE_LIFE, GetUnitState( bj_lastCreatedUnit, UNIT_STATE_MAX_LIFE) )
        
        call SetUnitScale( bj_lastCreatedUnit, 1 + (lvl * 0.2), 1 + (lvl * 0.2), 1 + (lvl * 0.2) )
        set cyclA = cyclA + 1
    endloop

    set caster = null
endfunction

//===========================================================================
function InitTrig_NecroSubUse takes nothing returns nothing
    set gg_trg_NecroSubUse = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_NecroSubUse, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_NecroSubUse, Condition( function Trig_NecroSubUse_Conditions ) )
    call TriggerAddAction( gg_trg_NecroSubUse, function Trig_NecroSubUse_Actions )
endfunction

