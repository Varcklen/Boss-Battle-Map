scope ShoggothQ

    globals
        private integer EntropyCount = 0
    endglobals

    function Trig_ShoggothQ_Conditions takes nothing returns boolean
        return GetSpellAbilityId() == 'A194'
    endfunction

    function Trig_ShoggothQ_Actions takes nothing returns nothing
        local group g = CreateGroup()
        local unit u
        local real dmg
        local real mnbn
        local real mana = 0
        local integer entdone = 0
        local unit caster
        local integer lvl
        local real x
        local real y
        local real extra
        
        if CastLogic() then
            set caster = udg_Caster
            set x = GetLocationX( GetSpellTargetLoc() )
            set y = GetLocationY( GetSpellTargetLoc() )
            set lvl = udg_Level
        elseif RandomLogic() then
            set caster = udg_Caster
            set lvl = udg_Level
            set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
            set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
            call textst( udg_string[0] + GetObjectName('A194'), caster, 64, 90, 10, 1.5 )
        else
            set caster = GetSpellAbilityUnit()
            set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
            set x = GetLocationX( GetSpellTargetLoc() )
            set y = GetLocationY( GetSpellTargetLoc() )
        endif
        
        set extra = 3*lvl*udg_entropy[GetPlayerId( GetOwningPlayer( caster ) ) + 1]
        set dmg = extra+135 + ( 35 * lvl )
        set mnbn = 4 + lvl
        
        call dummyspawn( caster, 1, 0, 0, 0 )
        call GroupEnumUnitsInRange( g, x, y, 350, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) then
                call DestroyEffect( AddSpecialEffect("war3mapImported\\Soul Discharge.mdx", GetUnitX(u), GetUnitY(u) ) )
                call UnitDamageTarget( bj_lastCreatedUnit, u, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                set mana = mana + mnbn
                set EntropyCount = EntropyCount + 1
                if EntropyCount >= 4 then
                    set entdone = entdone + 1
                    set EntropyCount = 0
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
        
        if mana > 0 then
            call manast( caster, null, mana )
        endif
        if entdone > 0 and not( udg_fightmod[3] ) and combat( caster, false, 0 ) then
            call entropy( caster, entdone )
        endif
        
        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction

    //===========================================================================
    function InitTrig_ShoggothQ takes nothing returns nothing
        set gg_trg_ShoggothQ = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( gg_trg_ShoggothQ, EVENT_PLAYER_UNIT_SPELL_EFFECT )
        call TriggerAddCondition( gg_trg_ShoggothQ, Condition( function Trig_ShoggothQ_Conditions ) )
        call TriggerAddAction( gg_trg_ShoggothQ, function Trig_ShoggothQ_Actions )
    endfunction

endscope