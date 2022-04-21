scope MephistarQ

    function Trig_MephistarQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'A14P'
    endfunction

    private function SummonNewUnit takes unit caster, integer lvl returns nothing
        local unit newUnit
        local real sp
    
        set sp = GetUnitSpellPower(caster)
        set newUnit = CreateUnit( GetOwningPlayer( caster ), 'n053', GetUnitX( caster ) + GetRandomReal( -250, 250 ), GetUnitY( caster ) + GetRandomReal( -250, 250 ), GetRandomReal( 0, 360 ) )
    
        call SaveUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mephw" ), newUnit )
        call SaveInteger( udg_hash, GetHandleId( newUnit ), StringHash( "mephw" ), lvl )
        call BlzSetUnitMaxHP( newUnit, R2I(BlzGetUnitMaxHP(newUnit)+((lvl-1)*100)) )
        call BlzSetUnitBaseDamage( newUnit, R2I(BlzGetUnitBaseDamage(newUnit, 0)+((lvl-1)*5)), 0 )

        call BlzSetUnitMaxHP( newUnit, R2I(BlzGetUnitMaxHP(newUnit)*sp) )
        call BlzSetUnitBaseDamage( newUnit, R2I(GetUnitDamage(newUnit)*sp-GetUnitAvgDiceDamage(newUnit)), 0 )
        call SetUnitState( newUnit, UNIT_STATE_LIFE, GetUnitState( newUnit, UNIT_STATE_MAX_LIFE) )
        call BlzSetUnitArmor( newUnit, BlzGetUnitArmor(newUnit)*sp )
        call SetUnitMoveSpeed( newUnit, GetUnitDefaultMoveSpeed(newUnit)*sp )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", newUnit, "origin" ) )
    
        set newUnit = null
        set caster = null
    endfunction

    function Trig_MephistarQ_Actions takes nothing returns nothing
        local integer lvl
        local unit caster
        local unit oldpet
        
        if CastLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            call textst( udg_string[0] + GetObjectName('A14P'), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId() )
        endif

        set oldpet = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mephw" ) )
        if IsUnitAlive( oldpet ) then
            call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", GetUnitX( oldpet ), GetUnitY( oldpet ) ) )
            call RemoveUnit( oldpet )
        endif

        call SummonNewUnit(caster, lvl)

        set caster = null
        set oldpet = null
    endfunction

    //===========================================================================
    function InitTrig_MephistarQ takes nothing returns nothing
        set gg_trg_MephistarQ = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_MephistarQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_MephistarQ, Condition( function Trig_MephistarQ_Conditions ) )
        call TriggerAddAction( gg_trg_MephistarQ, function Trig_MephistarQ_Actions )
    endfunction

endscope