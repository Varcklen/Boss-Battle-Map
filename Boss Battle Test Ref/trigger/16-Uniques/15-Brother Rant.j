function Trig_Brother_Rant_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A1BD' or GetSpellAbilityId() == 'A1BE'
endfunction

function ReduceCooldownBinnie takes unit u, real time returns nothing
    local integer array a
    local integer cyclA
    
    set cyclA = 1
    loop
        exitwhen cyclA > 4
        set a[cyclA] = 0
        set cyclA = cyclA + 1
    endloop
    
    if GetUnitAbilityLevel( u, 'A1BA') > 0 then
        set a[1] = 'A1BA'
    endif
    if GetUnitAbilityLevel( u, 'A1B9') > 0 then
        set a[2] = 'A1B9'
    endif
    if GetUnitAbilityLevel( u, 'A1BB') > 0 then
        set a[3] = 'A1BB'
    endif
    if GetUnitAbilityLevel( u, 'A1BC') > 0 then
        set a[4] = 'A1BC'
    endif

    set cyclA = 1
    loop
        exitwhen cyclA > 4
        if a[cyclA] != 0 then
            if BlzGetUnitAbilityCooldownRemaining(u,a[cyclA]) > time then
                call BlzStartUnitAbilityCooldown( u, a[cyclA], RMaxBJ( 0.1,BlzGetUnitAbilityCooldownRemaining(u, a[cyclA]) - time) )
            endif
        endif
        set cyclA = cyclA + 1
    endloop

    set u = null
endfunction

function Trig_Brother_Rant_Actions takes nothing returns nothing
    local unit caster
    local unit bonnie
    local real time
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A1BD'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set bonnie = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "rlbq" ) )
    if GetUnitState( bonnie, UNIT_STATE_LIFE) > 0.405 then
        set time = 1.5
        if IsUniqueUpgraded(caster) then
            set time = time*2
        endif
        call DestroyEffect( AddSpecialEffectTarget("war3mapImported\\TimeUpheaval.mdx", bonnie, "origin" ) )
        call ReduceCooldownBinnie( bonnie, time )
    endif
    
    set caster = null
    set bonnie = null
endfunction

//===========================================================================
function InitTrig_Brother_Rant takes nothing returns nothing
    set gg_trg_Brother_Rant = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Brother_Rant, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Brother_Rant, Condition( function Trig_Brother_Rant_Conditions ) )
    call TriggerAddAction( gg_trg_Brother_Rant, function Trig_Brother_Rant_Actions )
endfunction

