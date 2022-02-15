library BuffsLibLib requires Inventory, LuckylogicLib, UnitstLib, CombatLib, TextLib

    function BuffLogic takes nothing returns boolean
        local boolean l = true
        
        if udg_BuffLogic then
            set udg_BuffLogic = false
            set l = false
        endif
        return l
    endfunction

    function Unreachable takes unit caster returns nothing
        local group g = CreateGroup()
        local unit u
        local integer at = 1+GetUnitAbilityLevel( caster, 'A04L')

        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 500, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "enemy" ) and BlzGetUnitBaseDamage(u, 0) > at and not( IsUnitType( u, UNIT_TYPE_HERO ) ) then
                call BlzSetUnitBaseDamage( u, BlzGetUnitBaseDamage(u, 0) - at, 0 )
                call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl", u, "origin" ) )
            endif
            call GroupRemoveUnit(g,u)
        endloop

        call GroupClear( g )
        call DestroyGroup( g )
        set u = null
        set g = null
        set caster = null
    endfunction

    function effst takes unit caster, unit target, string str, integer lvl, real t returns nothing
        if GetUnitAbilityLevel( caster, 'A04L') > 0 then
            call Unreachable(caster)
        endif
        
        set caster = null
        set target = null
    endfunction

    function debuffst takes unit caster, unit target, string str, integer lvl, real t returns nothing
        local integer s 
        local integer i = GetPlayerId( GetOwningPlayer( caster ) ) + 1

        if GetUnitAbilityLevel( caster, 'A08U' ) > 0 and combat( caster, false, 0 ) and not( udg_fightmod[3] ) and udg_DamageEventSource != caster and udg_DamageEventTarget != caster then
            call spdst( caster,  0.15 * GetUnitAbilityLevel(caster, 'A08U') )
            set udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 112] = udg_Data[GetPlayerId(GetOwningPlayer(caster)) + 1 + 112] + GetUnitAbilityLevel(caster, 'A08U')
            call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl", caster, "origin" ) )
        endif
        
        if inv( caster, 'I09B' ) > 0 and GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and combat( caster, false, 0 ) and not( udg_fightmod[3] ) then
            set s = LoadInteger( udg_hash, GetHandleId( caster ), StringHash( udg_QuestItemCode[6] ) ) + 1
            call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( udg_QuestItemCode[6] ), s )

            if s >= udg_QuestNum[6] then
                call SetWidgetLife( GetItemOfTypeFromUnitBJ( caster, 'I09B'), 0. )
                set bj_lastCreatedItem = CreateItem( 'I092', GetUnitX(caster), GetUnitY(caster))
                call UnitAddItem(caster, bj_lastCreatedItem)
                call textst( "|c00ffffff Trembling enemies done!", caster, 64, GetRandomReal( 45, 135 ), 12, 1.5 )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", GetUnitX(caster), GetUnitY(caster) ) )
                set udg_QuestDone[i] = true
            else
                call QuestDiscription( caster, 'I09B', s, udg_QuestNum[6] )
            endif
        endif

        set caster = null
        set target = null
    endfunction
    
    function RemoveEffect takes unit target, integer myEffect, integer myBuff returns nothing
        call UnitRemoveAbility(target, myEffect)
        call UnitRemoveAbility(target, myBuff)
    
        set target = null
    endfunction

endlibrary