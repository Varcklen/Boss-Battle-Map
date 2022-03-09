function Trig_OwlQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A011'
endfunction

function OwlQCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local real dmg = LoadReal( udg_hash, id, StringHash( "owlq" ) )
    local unit target = LoadUnitHandle( udg_hash, id, StringHash( "owlqt" ) )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "owlq" ) )
    local unit dummy = CreateUnit( GetOwningPlayer( caster ), 'u000', GetUnitX( caster ), GetUnitY( caster ), 270 )
    
    call UnitApplyTimedLife( dummy, 'BTLF', 1)
    call UnitAddAbility( dummy, 'A0N5')
    call UnitDamageTarget( dummy, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
    
    call FlushChildHashtable( udg_hash, id )
    set target = null
    set caster = null
    set dummy = null
endfunction

function Trig_OwlQ_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer lvl
    local integer id
    local real dmg
    local group g = CreateGroup()
    local unit u
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "enemy", "", "", "", "" )
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A011'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    set dmg = ( 20. + ( 20. * lvl ) ) * GetUnitSpellPower(caster)
    
    if GetUnitAbilityLevel( caster, 'B003') > 0 then
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 600, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Starfall\\StarfallTarget.mdl", u, "origin") )
                set id = GetHandleId( u )
                
                call SaveTimerHandle( udg_hash, id, StringHash( "owlq" ), CreateTimer() )
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "owlq" ) ) ) 
                call SaveUnitHandle( udg_hash, id, StringHash( "owlqt" ), u )
                call SaveUnitHandle( udg_hash, id, StringHash( "owlq" ), caster )
                call SaveReal( udg_hash, id, StringHash( "owlq" ), dmg )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( u ), StringHash( "owlq" ) ), 0.7, false, function OwlQCast )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif

    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\NightElf\\Starfall\\StarfallTarget.mdl", target, "origin") )
    set id = GetHandleId( target )
    
    call SaveTimerHandle( udg_hash, id, StringHash( "owlq" ), CreateTimer() )
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "owlq" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "owlqt" ), target )
    call SaveUnitHandle( udg_hash, id, StringHash( "owlq" ), caster )
    call SaveReal( udg_hash, id, StringHash( "owlq" ), dmg )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( target ), StringHash( "owlq" ) ), 0.7, false, function OwlQCast )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_OwlQ takes nothing returns nothing
    set gg_trg_OwlQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_OwlQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_OwlQ, Condition( function Trig_OwlQ_Conditions ) )
    call TriggerAddAction( gg_trg_OwlQ, function Trig_OwlQ_Actions )
endfunction

