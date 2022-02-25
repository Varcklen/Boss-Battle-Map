function Trig_Sparkle_Wand_Conditions takes nothing returns boolean
    return inv(GetSpellAbilityUnit(), 'I0AY') > 0 and luckylogic( GetSpellAbilityUnit(), 25, 1, 100 )
endfunction

function Sparkle_WandCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "spklw" ) ) )
    call FlushChildHashtable( udg_hash, id )
endfunction

function Trig_Sparkle_Wand_Actions takes nothing returns nothing
    local unit u = randomtarget( GetSpellAbilityUnit(), 900, "enemy", "", "", "", "" )
    local real dmg = 200
    local lightning l 
    local integer id 

    if u != null then
        set l = AddLightningEx("CLPB", true, GetUnitX(GetSpellAbilityUnit()), GetUnitY(GetSpellAbilityUnit()), GetUnitFlyHeight(GetSpellAbilityUnit()) + 50, GetUnitX(u), GetUnitY(u), GetUnitFlyHeight(u) + 50 )
        set id = GetHandleId( l )
        call SaveTimerHandle( udg_hash, id, StringHash( "spklw" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "spklw" ) ) ) 
        call SaveLightningHandle( udg_hash, id, StringHash( "spklw" ), l )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( l ), StringHash( "spklw" ) ), 0.5, false, function Sparkle_WandCast )

        call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0 , 0 )
        call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( u ), GetUnitY( u ) ) )
        call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    endif
    set l = null
    set u = null
endfunction

//===========================================================================
function InitTrig_Sparkle_Wand takes nothing returns nothing
    set gg_trg_Sparkle_Wand = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Sparkle_Wand, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Sparkle_Wand, Condition( function Trig_Sparkle_Wand_Conditions ) )
    call TriggerAddAction( gg_trg_Sparkle_Wand, function Trig_Sparkle_Wand_Actions )
endfunction

