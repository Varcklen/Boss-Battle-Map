function Trig_PriestessW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A03V'
endfunction

function PriestessWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "prsw" ) )
    local integer r = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "prsw" ) )

    call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - r, 0 )
    call UnitRemoveAbility( u, 'A03W' )
    call UnitRemoveAbility( u, 'B00N' )
    call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "prsw" ) )
    call FlushChildHashtable( udg_hash, id )
    
    set u = null
endfunction

function Trig_PriestessW_Actions takes nothing returns nothing
    local integer id 
    local integer r
    local integer rsum
    local real b
    local unit caster
    local real t
    local integer lvl
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A03V'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set t = 20
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
    endif
    set t = timebonus(caster, t)
    
    if CountLivingPlayerUnitsOfTypeId('n020', GetOwningPlayer(caster)) > 0 then
        set b = 0.05+(0.15*lvl)
        set bj_livingPlayerUnitsTypeId = 'n020'
        call GroupEnumUnitsOfPlayer(g, GetOwningPlayer( caster ), filterLivingPlayerUnitsOfTypeId)
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if BlzGetUnitBaseDamage(u, 0) < 10000 then
                call BlzSetUnitBaseDamage( u, R2I(BlzGetUnitBaseDamage(u, 0) + (BlzGetUnitBaseDamage(u, 0)*b)), 0 )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", u, "origin" ) )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    elseif BlzGetUnitBaseDamage(caster, 0) < 10000 then
        call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) - LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "prsw" ) ), 0 )
        call RemoveSavedInteger( udg_hash, GetHandleId( caster ), StringHash( "prsw" ) )
    
        set b = 0.1+(0.1*lvl)
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", caster, "origin" ) )
        set r = R2I(BlzGetUnitBaseDamage(caster, 0)*b)
        set rsum = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "prsw" ) ) + r
        call BlzSetUnitBaseDamage( caster, BlzGetUnitBaseDamage(caster, 0) + r, 0 )
        call UnitAddAbility( caster, 'A03W')
        
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "prsw" ) ) == null then
            call SaveTimerHandle( udg_hash, GetHandleId( caster), StringHash( "prsw" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, GetHandleId( caster), StringHash( "prsw" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "prsw" ), caster )
        call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "prsw" ), rsum )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "prsw" ) ), t, false, function PriestessWCast ) 
        
        call effst( caster, caster, null, 1, t )
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_PriestessW takes nothing returns nothing
    set gg_trg_PriestessW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PriestessW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PriestessW, Condition( function Trig_PriestessW_Conditions ) )
    call TriggerAddAction( gg_trg_PriestessW, function Trig_PriestessW_Actions )
endfunction

