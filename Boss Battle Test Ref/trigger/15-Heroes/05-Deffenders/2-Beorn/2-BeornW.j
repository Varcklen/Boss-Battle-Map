globals
    constant integer BEORN_W_DURATION = 30
    constant integer BEORN_W_AREA = 450
    constant integer BEORN_W_ARMOR_FIRST_LEVEL = 1
    constant integer BEORN_W_ARMOR_LEVEL_BONUS = 2
    
    constant real BEORN_W_ARMOR_BONUS_ALTERNATIVE = 0.7
    
    constant string BEORN_W_ANIMATION = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
endglobals

function Trig_BeornW_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0B4'
endfunction

function BeornWCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
	local unit u = LoadUnitHandle( udg_hash, id, StringHash( "pers" ) )
    local integer rsum = LoadInteger( udg_hash, GetHandleId( u ), StringHash( "pers" ) )

    call BlzSetUnitArmor( u, BlzGetUnitArmor(u) - rsum )
    call RemoveSavedInteger( udg_hash, GetHandleId( u ), StringHash( "pers" ) )
    call UnitRemoveAbility( u, 'A004' )
    call UnitRemoveAbility( u, 'B000' )
    call FlushChildHashtable( udg_hash, id )

	set u = null
endfunction

function BeornWAddArmor takes unit caster, unit target, real duration, integer armor returns nothing
    local integer rsum = LoadInteger( udg_hash, GetHandleId( target ), StringHash( "pers" ) )
    
    call BlzSetUnitArmor( target, BlzGetUnitArmor(target) - rsum )
    call RemoveSavedInteger( udg_hash, GetHandleId( target ), StringHash( "pers" ) )
    call BlzSetUnitArmor( target, BlzGetUnitArmor(target) + armor )
    
    call UnitAddAbility( target, 'A004' )
    call InvokeTimerWithUnit(target, "pers", duration, false, function BeornWCast )
    call SaveInteger( udg_hash, GetHandleId( target ), StringHash( "pers" ), armor )
    call effst( caster, target, null, 1, 1 )
    
    set caster = null
    set target = null
endfunction

function BeornW_Alternative takes unit caster, real duration, integer armor returns nothing
    set armor = armor + R2I(armor*BEORN_W_ARMOR_BONUS_ALTERNATIVE)
    
    call BeornWAddArmor(caster, caster, duration, armor)
    
    set caster = null
endfunction

function BeornW takes unit caster, real duration, integer armor returns nothing
    local group g = CreateGroup()
    local unit u

    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), BEORN_W_AREA, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, TARGET_ALLY ) then
    		call BeornWAddArmor(caster, u, duration, armor)
        endif
        call GroupRemoveUnit(g,u)
    endloop
    
    call GroupClear( g )
    call DestroyGroup( g )
    set u = null
    set g = null
    set caster = null
endfunction

function Trig_BeornW_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real t
    local integer armor
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A0B4'), caster, 64, 90, 10, 1.5 )
        set t = BEORN_W_DURATION
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = BEORN_W_DURATION
    endif
    set t = timebonus(caster, t)
    
    set armor = BEORN_W_ARMOR_FIRST_LEVEL + (lvl*BEORN_W_ARMOR_LEVEL_BONUS)
    
    if Aspects_IsHeroAspectActive( caster, ASPECT_02 ) then
        call BeornW_Alternative( caster, t, armor )
    else
        call BeornW( caster, t, armor )
    endif
    call DestroyEffect( AddSpecialEffectTarget( BEORN_W_ANIMATION, caster, "origin" ) )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_BeornW takes nothing returns nothing
    set gg_trg_BeornW = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_BeornW, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_BeornW, Condition( function Trig_BeornW_Conditions ) )
    call TriggerAddAction( gg_trg_BeornW, function Trig_BeornW_Actions )
endfunction

scope BeornW initializer Triggs
    private function DeleteBuff_Conditions takes nothing returns boolean
        return GetUnitAbilityLevel( Event_DeleteBuff_Unit, 'A004') > 0
    endfunction
    
    private function DeleteBuff takes nothing returns nothing
        local unit hero = Event_DeleteBuff_Unit
        local integer rsum = LoadInteger( udg_hash, GetHandleId( hero ), StringHash( "pers" ) )

        call BlzSetUnitArmor( hero, BlzGetUnitArmor(hero) - rsum )
        call RemoveSavedInteger( udg_hash, GetHandleId( hero ), StringHash( "pers" ) )
        call UnitRemoveAbility( hero, 'A004' )
        call UnitRemoveAbility( hero, 'B000' )
        
        set hero = null
    endfunction

    private function Triggs takes nothing returns nothing
        call CreateEventTrigger( "Event_DeleteBuff_Real", function DeleteBuff, function DeleteBuff_Conditions )
    endfunction
endscope

