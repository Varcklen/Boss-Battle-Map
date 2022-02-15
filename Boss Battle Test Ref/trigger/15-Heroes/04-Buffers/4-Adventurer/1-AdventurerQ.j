function Trig_AdventurerQ_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A12J' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_AdventurerQ_Actions takes nothing returns nothing
    local integer id 
    local unit caster
    local integer lvl
    local real dmg
    local group g = CreateGroup()
    local unit u
    local integer i
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A12J'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set i = GetPlayerId(GetOwningPlayer( caster ) ) + 1
    set dmg = (100 + ( 50 * lvl )) * GetUnitSpellPower(caster)
    call DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    
    if IsUnitGroupEmptyBJ(udg_Bosses) then
        set udg_dmgboss[i] = udg_dmgboss[i] + dmg
        call textst( "|c00FFcc00 " + I2S( R2I( udg_dmgboss[i] ) ) + " damage", caster, 64, 90, 12, 2.5 )
    else
        call GroupEnumUnitsOfPlayer(g, Player(10), null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if IsUnitType( u, UNIT_TYPE_ANCIENT) and GetUnitState( u, UNIT_STATE_LIFE) > 0.405 then
                call dummyspawn( caster, 0, 0, 'A12K', 'A0N5' )
                set id = GetHandleId( bj_lastCreatedUnit )
                
                call SaveTimerHandle( udg_hash, id, StringHash( "advq" ), CreateTimer() )
                set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "advq" ) ) )
                call SaveUnitHandle( udg_hash, id, StringHash( "advqt" ), u )
                call SaveUnitHandle( udg_hash, id, StringHash( "advq" ), bj_lastCreatedUnit )
                call SaveReal( udg_hash, id, StringHash( "advq" ), dmg )
                call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( bj_lastCreatedUnit ), StringHash( "advq" ) ), 0.04, true, function AdventurerQMotion )
            endif
            call GroupRemoveUnit(g,u)
            set u = FirstOfGroup(g)
        endloop
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction
//===========================================================================
function InitTrig_AdventurerQ takes nothing returns nothing
    set gg_trg_AdventurerQ = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AdventurerQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AdventurerQ, Condition( function Trig_AdventurerQ_Conditions ) )
    call TriggerAddAction( gg_trg_AdventurerQ, function Trig_AdventurerQ_Actions )
endfunction

