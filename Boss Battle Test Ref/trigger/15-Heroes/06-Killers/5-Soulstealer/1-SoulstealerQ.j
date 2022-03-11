function Trig_SoulstealerQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0DL'
endfunction

function SoulstealerQMove takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "sslq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "sslqt" ) )
    local integer c = LoadInteger( udg_hash, id, StringHash( "sslq" ) ) + 1
    local lightning l = LoadLightningHandle( udg_hash, id, StringHash( "sslql" ) )
    local real r = LoadReal( udg_hash, GetHandleId( target ), StringHash( "sslq" ) )
    local integer g = LoadInteger( udg_hash, id, StringHash( "sslqlvl" ))
    local integer lv
    
    if GetUnitAbilityLevel(target, 'A0DZ') > 0 and DistanceBetweenUnits(caster, target) < 1350 and caster != target and (GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 or GetUnitAbilityLevel(caster, 'A0EX') > 0 ) and GetUnitState( target, UNIT_STATE_LIFE) > 0.405 then
        call MoveLightningUnits( l, caster, target )
        if c >= g then
            if r <= 0.6 then
                call spectimeunit( target, "Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl", "head", 1 )
                set r = r + 0.03
                if r > 0.6 then
                    set r = 0.6
                endif
            endif
            call SaveInteger( udg_hash, id, StringHash( "sslq" ), 0 )
            call SaveReal( udg_hash, GetHandleId( target ), StringHash( "sslq" ), r )
        else
            call SaveInteger( udg_hash, id, StringHash( "sslq" ), c )
        endif
    else
        call UnitRemoveAbility( target, 'A0DZ' )
        call UnitRemoveAbility( target, 'B07M' )
    	call DestroyLightning( l )
        call FlushChildHashtable( udg_hash, id )
        call DestroyTimer( GetExpiredTimer() )
    endif
    
    set caster = null
    set target = null
endfunction

function Trig_SoulstealerQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit target
    local integer lvl
    local real dmg
    local lightning l
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0DL'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif

    if GetUnitAbilityLevel(target, 'A0DZ') == 0 then
        set l = AddLightningEx("DRAM", true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) , GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target))
        call UnitAddAbility( target, 'A0DZ' )

        set id = GetHandleId( target )
        if LoadTimerHandle( udg_hash, id, StringHash( "sslq" ) ) == null  then
            call SaveTimerHandle( udg_hash, id, StringHash( "sslq" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "sslq" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "sslq" ), caster )
        call SaveUnitHandle( udg_hash, id, StringHash( "sslqt" ), target )
        call SaveUnitHandle( udg_hash, GetHandleId( target ), StringHash( "sslqc" ), caster )
        call SaveReal( udg_hash, GetHandleId( target ), StringHash( "sslq" ), 0.1 )
        call SaveInteger( udg_hash, id, StringHash( "sslqlvl" ), 175-(25*lvl) )
        call SaveLightningHandle( udg_hash, id, StringHash( "sslql" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "sslq" ) ), 0.02, true, function SoulstealerQMove ) 
    endif

    set caster = null
    set target = null
    set l = null
endfunction

//===========================================================================
function InitTrig_SoulstealerQ takes nothing returns nothing
    set gg_trg_SoulstealerQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SoulstealerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SoulstealerQ, Condition( function Trig_SoulstealerQ_Conditions ) )
    call TriggerAddAction( gg_trg_SoulstealerQ, function Trig_SoulstealerQ_Actions )
endfunction