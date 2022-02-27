    set udg_Boss_Minion[0] = GetSpellAbilityUnit()
    set udg_Boss_Minion[0] = GetSpellTargetUnit()
    set udg_Boss_Minion[0] = GetManipulatingUnit()
    
    GetUnitUserData(u)
    
    eyest( GetSpellAbilityUnit() )
    
    UnitItemInSlot( caster, i)
    
    
    call CreateEventTrigger( "udg_AfterDamageEvent", function Trig_Ancient_Sword_Actions, function Trig_Ancient_Sword_Conditions )
    
    DAMAGE_TYPE_MAGIC
    DAMAGE_TYPE_NORMAL
    
    
    UNIT_TYPE_HERO
    UNIT_TYPE_ANCIENT
    
    IsUnitType( u, UNIT_TYPE_ANCIENT)
    
    call UnitReduceCooldownPercent( udg_hero[i], 0.4 )
    
    set trig = CreateTrigger()
    call TriggerRegisterVariableEvent( trig, "udg_FightStart_Real", EQUAL, 1.00 )
    call TriggerAddCondition( trig, Condition( function StartFight_Conditions ) )
    call TriggerAddAction( trig, function StartFight)

    set hp = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.05
    set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.05

    call DisplayTimedTextToForce( bj_FORCE_ALL_PLAYERS, 5.00, "111" )
    
    call TriggerRegisterVariableEvent( gg_trg_Runestone_Zirik, "udg_FightEnd_Real", EQUAL, 1.00 )
    
    GroupAoE takes unit caster, unit dummy, real x, real y, real dmg, real area, string who, string strall, string str
    
    GetUnitAbilityLevel(udg_hero[i], 'B088') > 0
    
    call bufst( caster, target, 'A0S2', 'B06N', "slge2", t )
    
    words( u, BlzGetItemDescription(GetManipulatedItem()), "|cFF959697(", ")|r", "Active!" )
    
    udg_FightEnd_Unit
    call TriggerRegisterVariableEvent( trig, "udg_FightEnd_Real", EQUAL, 1.00 )
    
    local integer cyclA = 1
    local integer cyclAEnd = eyest( GetSpellAbilityUnit() )

    loop
        exitwhen cyclA > cyclAEnd

        set cyclA = cyclA + 1
    endloop
    
    |cffbe81f7 |r
    
    GetRandomInt( 1, udg_Database_NumberItems[10] )
    
    set Event_DeleteBuff_Unit = u

    if GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'BNsi') > 0 then
        call UnitRemoveAbility( Event_DeleteBuff_Unit, 'BNsi' )
    endif
    
    
    
    private function Alternative takes nothing returns nothing 
    
    endfunction
    
    private function Main takes nothing returns nothing 
    
    endfunction
    
    if Aspects_IsHeroAspectActive( caster, ASPECT_0 ) then
        call Alternative(  )
    else
        call Main(  )
    endif
    


scope DruidQ initializer init
    private function DeleteBuff_Conditions takes nothing returns boolean
        return IsUnitHasAbility( Event_DeleteBuff_Unit, EFFECT)
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        call RemoveEffect( Event_DeleteBuff_Unit, EFFECT, BUFF )
    endfunction

    private function init takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

    private function Use takes nothing returns nothing
        local unit caster = Event_WaveHit_Caster
        local unit target = Event_WaveHit_Target
        local real damage = LoadReal( udg_hash, GetHandleId(Event_WaveHit_Wave), StringHash( "" ) )
        
                
        set caster = null
        set target = null
    endfunction
    