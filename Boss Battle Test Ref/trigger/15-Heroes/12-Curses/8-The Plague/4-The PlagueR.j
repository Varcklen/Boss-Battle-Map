scope ThePlagueR initializer init

    globals
        private constant integer ID_ABILITY = 'A1CX'
        
        private constant integer DAMAGE_FIRST_LEVEL = 100
        private constant integer DAMAGE_LEVEL_BONUS = 50
        private constant integer STEP_SIZE = 150
        
        private constant real DAMAGE_BONUS_FIRST_LEVEL = 0.5
        private constant real DAMAGE_BONUS_LEVEL_BONUS = 0.2
        
        private constant string ANIMATION = "war3mapImported\\Soul Discharge.mdx"
        private constant string LIGHTNING = "DNKL"
    endglobals

    function Trig_The_PlagueR_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function DestroyLight takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        call DestroyLightning( LoadLightningHandle( udg_hash, id, StringHash( "light" ) ) )
        call FlushChildHashtable( udg_hash, id )
    endfunction
    
    private function CreateLightning takes unit caster, unit target returns nothing
        local lightning light
        local integer id
        
        call PlaySpecialEffect(ANIMATION, target)
        set light = AddLightningEx(LIGHTNING, true, GetUnitX(caster), GetUnitY(caster), GetUnitFlyHeight(caster) + 50, GetUnitX(target), GetUnitY(target), GetUnitFlyHeight(target) + 50 )
        set id = GetHandleId( light )
        call SaveTimerHandle( udg_hash, id, StringHash( "light" ), CreateTimer() )
        set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "light" ) ) ) 
        call SaveLightningHandle( udg_hash, id, StringHash( "light" ), light )
        call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( light ), StringHash( "light" ) ), 0.5, false, function DestroyLight )
    
        set light = null
        set target = null
        set caster = null
    endfunction
    
    private function UseLightning takes unit caster, group units, real damage, real bonus returns nothing
        local unit u
        local real bonusDamage
        
        loop
            set u = FirstOfGroup(units)
            exitwhen u == null
            call CreateLightning(caster, u)
            
            set bonusDamage = 1
            if IsUnitHasAbility( u, ThePlagueE_BUFF) then
                set bonusDamage = bonusDamage + bonus
            endif
            if IsUnitHasAbility( u, ThePlagueW_EFFECT) then
                set bonusDamage = bonusDamage + bonus
            endif
            call UnitTakeDamage(caster, u, damage*bonusDamage, DAMAGE_TYPE_MAGIC)
            call GroupRemoveUnit(units,u)
        endloop
    
        set u = null
        set units = null
        set caster = null
    endfunction
    
    private function AddToGroup takes unit caster, group units, real x, real y returns nothing
        local group g = CreateGroup()
        local unit u
        
        call GroupEnumUnitsInRange( g, x, y, STEP_SIZE*2, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and IsUnitInGroup( u, units ) == false then
                call GroupAddUnit( units, u )
            endif
            call GroupRemoveUnit(g,u)
        endloop
    
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set units = null
        set caster = null
    endfunction

    private function AddUnitsToGroup takes unit caster, real x, real y, real damage, real bonus returns nothing
        local group units = CreateGroup()
        local point newPoint = 0
        local point casterPoint = point.create()
        local point targetPoint = point.create()
        local real distance
        local real angle
        local integer i
        local integer iEnd
        
        call casterPoint.Set(GetUnitX( caster ), GetUnitY( caster ))
        call targetPoint.Set(x, y)
        set distance = DistanceBetweenCustomPoints(casterPoint, targetPoint)
        set angle = Deg2Rad(GetAngleBetweenPoints(targetPoint, casterPoint))

        call newPoint.SetFromPoint(casterPoint)
        set i = 1
        set iEnd = R2I(distance/STEP_SIZE) + 1
        loop
            exitwhen i > iEnd
            set newPoint = GetMovedPointByPoint( newPoint, angle, STEP_SIZE )
            call AddToGroup( caster, units, newPoint.x, newPoint.y)
            set i = i + 1
        endloop
        
        call UseLightning(caster, units, damage, bonus)
        
        call casterPoint.destroy()
        call targetPoint.destroy()
        call newPoint.destroy()
        call GroupClear( units )
        call DestroyGroup( units )
        set caster = null
        set units = null
    endfunction

    function Trig_The_PlagueR_Actions takes nothing returns nothing
        local unit caster
        local integer level
        local real x
        local real y
        local real damage
        local real bonus
        
        if CastLogic() then
            set caster = udg_Target
            set level = udg_Level
            set x = GetLocationX( GetSpellTargetLoc() )
            set y = GetLocationY( GetSpellTargetLoc() )
        elseif RandomLogic() then
            set caster = udg_Caster
            set level = udg_Level
            set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
            set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
            set level = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set x = GetLocationX( GetSpellTargetLoc() )
            set y = GetLocationY( GetSpellTargetLoc() )
        endif
        
        set damage = DAMAGE_FIRST_LEVEL + (DAMAGE_LEVEL_BONUS * level)
        set bonus = DAMAGE_BONUS_FIRST_LEVEL + (level*DAMAGE_BONUS_LEVEL_BONUS)
        call AddUnitsToGroup(caster, x, y, damage, bonus )

        set caster = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_The_PlagueR = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_The_PlagueR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_The_PlagueR, Condition( function Trig_The_PlagueR_Conditions ) )
        call TriggerAddAction( gg_trg_The_PlagueR, function Trig_The_PlagueR_Actions )
    endfunction

endscope

