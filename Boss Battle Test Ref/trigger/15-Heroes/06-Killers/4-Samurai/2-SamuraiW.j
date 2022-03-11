globals
    constant real SAMURAI_W_ATTACK_BONUS_FIRST_LEVEL = 0.5
    constant real SAMURAI_W_ATTACK_BONUS_LEVEL_BONUS = 0.5
endglobals

function Trig_SamuraiW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0QJ'
endfunction

function Trig_SamuraiW_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0QJ'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    call SaveReal( udg_hash, GetHandleId( caster ), StringHash( "smrw" ), SAMURAI_W_ATTACK_BONUS_FIRST_LEVEL + ( SAMURAI_W_ATTACK_BONUS_LEVEL_BONUS * lvl ) )
    call UnitAddAbility( caster, 'A0VS' )
     
    set caster = null
endfunction

//===========================================================================
function InitTrig_SamuraiW takes nothing returns nothing
    set gg_trg_SamuraiW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_SamuraiW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_SamuraiW, Condition( function Trig_SamuraiW_Conditions ) )
    call TriggerAddAction( gg_trg_SamuraiW, function Trig_SamuraiW_Actions )
endfunction

scope SamuraiW initializer Triggs
    //OnAttackEvent
    private function Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventSource, 'A0VS') > 0 and udg_IsDamageSpell == false
    endfunction
    
    private function SamuraiW_Alternative takes real bonus returns nothing
        if IsUnitType( udg_DamageEventTarget, UNIT_TYPE_ANCIENT) == false then
            set udg_DamageEventType = udg_DamageTypeCriticalStrike
            set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage * bonus)
        endif
    endfunction
    
    private function SamuraiW takes unit hero, real bonus returns nothing
        set udg_DamageEventType = udg_DamageTypeCriticalStrike
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage * bonus)
        call UnitRemoveAbility( hero, 'A0VS' )  
        call UnitRemoveAbility( hero, 'B046' )
        
        set hero = null
    endfunction
    
    private function Action takes nothing returns nothing
        local unit hero = udg_DamageEventSource
        local real bonus = LoadReal( udg_hash, GetHandleId( hero ), StringHash( "smrw" ) )

        if Aspects_IsHeroAspectActive(hero, ASPECT_02) then
            call SamuraiW_Alternative( bonus)
        else
            call SamuraiW( hero, bonus )
        endif

        set hero = null
    endfunction
    
    //DeleteBuff
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A0VS') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, 'A0VS' )  
        call UnitRemoveAbility( hero, 'B046' )
        
        set hero = null
    endfunction

    //Init
    private function Triggs takes nothing returns nothing
        call CreateEventTrigger( "Event_OnDamageChange_Real", function Action, function Conditions )
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope