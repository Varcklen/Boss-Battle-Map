function Trig_AngerP_Conditions takes nothing returns boolean
    return GetLearnedSkill() == 'A016'
endfunction

function AngelPCast takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer( ) )
    local group g = CreateGroup()
    local unit u
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "angelpas" ) )
    local real heal = LoadReal( udg_hash, id, StringHash( "angelpas" ) )
    local integer lvl = LoadInteger( udg_hash, id, StringHash( "angelpas" ) )
    
    if GetUnitState( caster, UNIT_STATE_LIFE) > 0.405 and not( IsUnitLoaded( caster ) ) then
        call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Undead\\ReplenishHealth\\ReplenishHealthCasterOverhead.mdl", caster, "overhead") )
        call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 450, null )
        loop
            set u = FirstOfGroup(g)
            exitwhen u == null
            if unitst( u, caster, "ally" ) then
                call healst( caster, u, heal )
                call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", u, "origin" ) )
                if lvl == 5 and IsUnitType( u, UNIT_TYPE_HERO) then
                    call manast( caster, u, 20 )
                endif
            endif
            call GroupRemoveUnit(g,u)
        endloop
        if GetUnitAbilityLevel( caster, 'A016') > 0 then
            call BlzStartUnitAbilityCooldown( caster, 'A016', 8 )
        endif
    endif
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

function Trig_AngerP_Actions takes nothing returns nothing
    local integer id = GetHandleId( GetLearningUnit() )
    local integer lvl = GetUnitAbilityLevel( GetLearningUnit(), 'A016' )
    
    if LoadTimerHandle( udg_hash, id, StringHash( "angelpas" ) ) == null then
        call SaveTimerHandle( udg_hash, id, StringHash( "angelpas" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "angelpas" ) ) )
    call SaveUnitHandle ( udg_hash, id, StringHash( "angelpas" ), GetLearningUnit() )
    call SaveInteger( udg_hash, id, StringHash( "angelpas" ), lvl )
    call SaveReal( udg_hash, id, StringHash( "angelpas" ), 15 + ( 10 * lvl ) )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( GetLearningUnit() ), StringHash( "angelpas" ) ), 8, true, function AngelPCast )
endfunction

//===========================================================================
function InitTrig_AngelP takes nothing returns nothing
    set gg_trg_AngelP = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AngelP, EVENT_PLAYER_HERO_SKILL )
    call TriggerAddCondition( gg_trg_AngelP, Condition( function Trig_AngerP_Conditions ) )
    call TriggerAddAction( gg_trg_AngelP, function Trig_AngerP_Actions )
endfunction

