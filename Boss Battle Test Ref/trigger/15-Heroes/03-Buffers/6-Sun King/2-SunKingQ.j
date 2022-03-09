scope SunKingQ initializer init

    globals
        private constant integer ID_ABILITY = 'A1DG'
        
        private constant integer STEP_SIZE = 150
        private constant integer DISTANCE = 800
        private constant integer DURATION = 5
        
        private constant real TICK = 0.04
        private constant real DAMAGE_TICK = 0.4
        private constant real BONUS_TURN_RATE = -0.95
        
        private constant integer DAMAGE_FIRST_LEVEL = 8
        private constant integer DAMAGE_LEVEL_BONUS = 4
        
        private constant integer SHIELD_FIRST_LEVEL = 150
        private constant integer SHIELD_LEVEL_BONUS = 50
        
        private constant integer EFFECT = 'A1DH'
        private constant integer BUFF = 'B0AC'
        
        private constant string BEAM_END_ANIMATION = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBase.mdl"
        private constant string ANIMATION = "Heal.mdx"
        private constant string LIGHTNING = "HWPB"
    endglobals

    function Trig_SunKingQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == ID_ABILITY
    endfunction
    
    private function BeamDamage takes unit caster, group units, integer id returns nothing
        local real damage = LoadReal(udg_hash, id, StringHash( "snkqd" ) )
        local real heal = LoadReal(udg_hash, id, StringHash( "snkqh" ) )
        local unit u
        
        loop
            set u = FirstOfGroup(units)
            exitwhen u == null
            if unitst( u, caster, "ally" ) then
                call healst(caster, u, heal)
                if IsUnitHealthIsFull(u) == false then
                    call PlaySpecialEffect(ANIMATION, u)
                endif
            else
                call UnitTakeDamage(caster, u, damage, DAMAGE_TYPE_MAGIC)
                call PlaySpecialEffect(ANIMATION, u)
            endif
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
            if unitst( u, caster, "all" ) and IsUnitInGroup( u, units ) == false then
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
    
    private function MoveBeam takes unit caster, lightning beam, integer id returns nothing
        local real tick = LoadReal(udg_hash, id, StringHash( "snkqt" ) ) + TICK
        local effect beamEnd = LoadEffectHandle(udg_hash, id, StringHash( "snkqe" ) )
        local group units = CreateGroup()
        local point newPoint = point.create()
        local point casterPoint = point.create()
        local point targetPoint = point.create()
        local real angle
        local integer i
        local integer iEnd
        
        call casterPoint.Set(GetUnitX( caster ), GetUnitY( caster ))
        set angle = Deg2Rad(GetUnitFacing(caster))
        call targetPoint.SetFromPoint(GetMovedPointByPoint( casterPoint, angle, DISTANCE) )
        
        call casterPoint.Set(GetUnitX( caster ), GetUnitY( caster ))
        call MoveLightning( beam, true, casterPoint.x, casterPoint.y, targetPoint.x, targetPoint.y )
        
        call BlzSetSpecialEffectX( beamEnd, targetPoint.x )
        call BlzSetSpecialEffectY( beamEnd, targetPoint.y )

        call newPoint.SetFromPoint(casterPoint)
        set i = 1
        set iEnd = R2I(DISTANCE/STEP_SIZE) + 1
        loop
            exitwhen i > iEnd
            set newPoint = GetMovedPointByPoint( newPoint, angle, STEP_SIZE )
            call AddToGroup( caster, units, newPoint.x, newPoint.y)
            set i = i + 1
        endloop
        
        if tick >= DAMAGE_TICK then
            set tick = tick - DAMAGE_TICK
            call BeamDamage(caster, units, id)
        endif
        call SaveReal(udg_hash, id, StringHash( "snkqt" ), tick )
    
        call casterPoint.destroy()
        call targetPoint.destroy()
        call newPoint.destroy()
        call GroupClear( units )
        call DestroyGroup( units )
        set units = null
        set caster = null
        set beam = null
        set beamEnd = null
    endfunction

    private function BeamUse takes nothing returns nothing
        local integer id = GetHandleId( GetExpiredTimer() )
        local lightning beam = LoadLightningHandle( udg_hash, id, StringHash( "snkqb" ) )
        local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "snkq" ) )
        local integer count = LoadInteger( udg_hash, id, StringHash( "snkq" ) ) - 1
        local integer pat = LoadInteger( udg_hash, id, StringHash( "snkqe" ) )

        if count <= 0 or IsUnitDead(caster) or pat != udg_Pattern then
            call BlzSetUnitRealFieldBJ( caster, UNIT_RF_TURN_RATE, BlzGetUnitRealField(caster, UNIT_RF_TURN_RATE) - BONUS_TURN_RATE )
            call UnitRemoveAbility(caster, EFFECT)
            call UnitRemoveAbility(caster, BUFF)
            call DestroyLightning(beam)
            call DestroyEffect(LoadEffectHandle(udg_hash, id, StringHash( "snkqe" ) ) )
            call FlushChildHashtable( udg_hash, id )
            call DestroyTimer( GetExpiredTimer() )
        else
            call SaveInteger( udg_hash, id, StringHash( "snkq" ), count )
            call MoveBeam(caster, beam, id)
        endif
        
        set caster = null
        set beam = null
    endfunction
    
    private function Beam takes unit caster, real damage, real heal returns nothing
        local lightning beam
        local integer id
        local effect beamEnd
        local boolean isDisable = false
        
        if LoadTimerHandle( udg_hash, GetHandleId(caster), StringHash( "snkq" ) ) == null then
            set isDisable = true
        endif
        
        set id = InvokeTimerWithUnit(caster, "snkq", TICK, true, function BeamUse )
        call SaveReal(udg_hash, id, StringHash( "snkqd" ), damage )
        call SaveReal(udg_hash, id, StringHash( "snkqh" ), heal )
        call SaveInteger( udg_hash, id, StringHash( "snkqe" ), udg_Pattern )
        call SaveInteger( udg_hash, id, StringHash( "snkq" ), R2I(DURATION/TICK) )
        if isDisable then
            call BlzSetUnitRealFieldBJ( caster, UNIT_RF_TURN_RATE, BlzGetUnitRealField(caster, UNIT_RF_TURN_RATE) + BONUS_TURN_RATE )
            set beamEnd = AddSpecialEffect(BEAM_END_ANIMATION, GetUnitX(caster), GetUnitY(caster) )
            set beam = AddLightning(LIGHTNING, true, GetUnitX(caster), GetUnitY(caster), GetUnitX(caster), GetUnitY(caster) )
            
            call SaveLightningHandle(udg_hash, id, StringHash( "snkqb" ), beam )
            call SaveEffectHandle(udg_hash, id, StringHash( "snkqe" ), beamEnd )
        endif
        
        set caster = null
        set beam = null
        set beamEnd = null
    endfunction
    
    function Trig_SunKingQ_Actions takes nothing returns nothing
        local unit caster
        local integer level
        local real damage
        local real heal
        local real shieldAdded
        
        if CastLogic() then
            set caster = udg_Target
            set level = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set level = udg_Level
            call textst( udg_string[0] + GetObjectName(ID_ABILITY), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
            set level = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        endif
        
        set shieldAdded = SHIELD_FIRST_LEVEL + (level*SHIELD_LEVEL_BONUS)
        set damage = DAMAGE_FIRST_LEVEL + (level*DAMAGE_LEVEL_BONUS)
        set heal = damage
        
        call UnitAddAbility(caster, EFFECT)
        call shield(caster, caster, shieldAdded, 60)
        call Beam(caster, damage, heal )

        set caster = null
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        set gg_trg_SunKingQ = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_SunKingQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_SunKingQ, Condition( function Trig_SunKingQ_Conditions ) )
        call TriggerAddAction( gg_trg_SunKingQ, function Trig_SunKingQ_Actions )
    endfunction

endscope

