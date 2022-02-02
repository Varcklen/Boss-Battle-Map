function Trig_MaidenR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A16Q' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function MaidenRCool takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit u = LoadUnitHandle( udg_hash, id, StringHash( "mdnrc" ) )
    local integer sk = LoadInteger( udg_hash, id, StringHash( "mdnrc" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "mdnrlvl" ) )

    call BlzStartUnitAbilityCooldown( u, sk, 5 )
    call SetUnitState( u, UNIT_STATE_MANA, GetUnitState( u, UNIT_STATE_MANA ) + BlzGetAbilityManaCost( sk, lvl-1 ) )
    call FlushChildHashtable( udg_hash, id )

    set u = null
endfunction  

function Trig_MaidenR_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local unit u
    local integer lvl
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A16Q'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set u = GroupPickRandomUnit(udg_DeadHero)

    if u != null then
         call ResInBattle( caster, u, 25+(15 * lvl) )
    elseif GetSpellAbilityId() == 'A16Q' then
        set id = GetHandleId( caster )
        if LoadTimerHandle( udg_hash, id, StringHash( "mdnrc" ) ) == null then
            call SaveTimerHandle( udg_hash, id, StringHash( "mdnrc" ), CreateTimer() )
        endif
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "mdnrc" ) ) ) 
        call SaveUnitHandle( udg_hash, id, StringHash( "mdnrc" ), caster )
        call SaveInteger( udg_hash, id, StringHash( "mdnrc" ), GetSpellAbilityId() )
        call SaveInteger( udg_hash, id, StringHash( "mdnrlvl" ), lvl )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "mdnrc" ) ), 0.01, false, function MaidenRCool )
    endif
    
    set caster = null
    set u = null
endfunction

//===========================================================================
function InitTrig_MaidenR takes nothing returns nothing
    set gg_trg_MaidenR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_MaidenR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_MaidenR, Condition( function Trig_MaidenR_Conditions ) )
    call TriggerAddAction( gg_trg_MaidenR, function Trig_MaidenR_Actions )
endfunction