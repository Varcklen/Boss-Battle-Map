scope ElementalR initializer init

    globals
        private constant integer ID_ABILITY = 'A0KG'
        
        private constant integer DURATION = 20
        private constant real DAMAGE_BONUS_FIRST_LEVEL = 0.06
        private constant real DAMAGE_BONUS_LEVEL_BONUS = 0.06
        private constant real MAGIC_DAMAGE_BONUS_FIRST_LEVEL = 0.06
        private constant real MAGIC_DAMAGE_BONUS_LEVEL_BONUS = 0.06
        
        private constant integer EXTRA_DAMAGE_BONUS_ALTERNATIVE = 2
        
        private constant integer EFFECT = 'A0LO'
        private constant integer BUFF = 'B07R'
        
        private constant string ANIMATION = "Abilities\\Spells\\Undead\\UnholyFrenzyAOE\\UnholyFrenzyAOETarget.mdl"
    endglobals

    function Trig_ElementalR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction

    function ElementalRCast takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer( ) )
        local unit target = LoadUnitHandle( udg_hash, id, StringHash( "elemr" ) )
         
        call UnitRemoveAbility( target, EFFECT )
        call UnitRemoveAbility( target, BUFF )
        call FlushChildHashtable( udg_hash, id )

        set target = null
    endfunction
    
    private function AddEffect takes unit caster, unit target, real duration, real damageBonus, real magicDamageBonus returns nothing 
        local integer targetId = GetHandleId( target )
        
        call bufallst( caster, target, EFFECT, 0, 0, 0, 0, BUFF, "elemr", duration )
        call SaveReal( udg_hash, targetId, StringHash( "elemrd" ), damageBonus )
        call SaveReal( udg_hash, targetId, StringHash( "elemrm" ), magicDamageBonus )
        call PlaySpecialEffect(ANIMATION, target)

        call effst( caster, target, null, 1, duration )
        
        set caster = null
        set target = null
    endfunction
    
    private function Alternative takes unit caster, unit target, real duration, real damageBonus, real magicDamageBonus returns nothing 
        set damageBonus = damageBonus * EXTRA_DAMAGE_BONUS_ALTERNATIVE
        call AddEffect (caster, target, duration, damageBonus, magicDamageBonus )
        call AddEffect (caster, caster, duration, damageBonus, magicDamageBonus )
    endfunction
    
    private function Main takes unit caster, unit target, real duration, real damageBonus, real magicDamageBonus returns nothing 
        call AddEffect (caster, target, duration, damageBonus, magicDamageBonus )
        call AddEffect (caster, caster, duration, damageBonus, magicDamageBonus )
    endfunction

    function Trig_ElementalR_Actions takes nothing returns nothing
        local unit caster
        local unit target
        local integer lvl
        local real t
        local real damageBonus
        local real magicDamageBonus
        
        if CastLogic() then
            set caster = udg_Caster
            set target = udg_Target
            set lvl = udg_Level
            set t = udg_Time
        elseif RandomLogic() then
            set caster = udg_Caster
            set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
            set t = DURATION
            if target == null then
                set caster = null
                return
            endif
        else
            set caster = GetSpellAbilityUnit()
            set target = GetSpellTargetUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set t = DURATION
        endif
        
        set damageBonus = DAMAGE_BONUS_FIRST_LEVEL+(DAMAGE_BONUS_LEVEL_BONUS*lvl)
        set magicDamageBonus = MAGIC_DAMAGE_BONUS_FIRST_LEVEL+(MAGIC_DAMAGE_BONUS_LEVEL_BONUS*lvl)
        
        if Aspects_IsHeroAspectActive( caster, ASPECT_03 ) then
        call Alternative( caster, target, t, damageBonus, magicDamageBonus )
        else
            call Main( caster, target, t, damageBonus, magicDamageBonus )
        endif

        set caster = null
        set target = null
    endfunction
    
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, EFFECT) > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit

        call UnitRemoveAbility( hero, EFFECT )
        call UnitRemoveAbility( hero, BUFF )
        
        set hero = null
    endfunction
        
    private function OnDamageChange_Magical_Conditions takes nothing returns boolean
        return udg_IsDamageSpell and GetUnitAbilityLevel( udg_DamageEventTarget, EFFECT ) > 0
    endfunction

    private function OnDamageChange_Magical takes nothing returns nothing
        local unit hero = udg_DamageEventTarget
        local real magicDamageBonus = LoadReal( udg_hash, GetHandleId( hero ), StringHash( "elemrm" ) )
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*magicDamageBonus)
        
        set hero = null
    endfunction
    
    private function OnDamageChange_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( udg_DamageEventSource, EFFECT ) > 0
    endfunction

    private function OnDamageChange takes nothing returns nothing
        local unit hero = udg_DamageEventSource
        local real damageBonus = LoadReal( udg_hash, GetHandleId( hero ), StringHash( "elemrd" ) )
        
        set udg_DamageEventAmount = udg_DamageEventAmount + (Event_OnDamageChange_StaticDamage*damageBonus)
        
        set hero = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_ElementalR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ElementalR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_ElementalR, Condition( function Trig_ElementalR_Conditions ) )
        call TriggerAddAction( gg_trg_ElementalR, function Trig_ElementalR_Actions )
        
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange_Magical, function OnDamageChange_Magical_Conditions )
        call CreateEventTrigger( "Event_OnDamageChange_Real", function OnDamageChange, function OnDamageChange_Conditions )
    endfunction
    
endscope