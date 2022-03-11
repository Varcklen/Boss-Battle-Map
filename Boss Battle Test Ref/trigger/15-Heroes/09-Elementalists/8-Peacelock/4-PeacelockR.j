function Trig_PeacelockR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A05Y'
endfunction

function PeacelockRKill takes nothing returns nothing
    local integer id = GetHandleId( GetExpiredTimer() )
    local unit caster = LoadUnitHandle( udg_hash, id, StringHash( "pckwr" ) )

    call KillUnit(caster)
    call FlushChildHashtable( udg_hash, id )
   
    set caster = null
endfunction

function Trig_PeacelockR_Actions takes nothing returns nothing
    local integer lvl
    local integer id
    local unit caster
    local real bonus
    local real t
    local group g = CreateGroup()
    local unit u
    local real heal
    local integer num
    local integer cyclA
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A05Y'), caster, 64, 90, 10, 1.5 )
        set t = 40
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 40
    endif 
    set t = timebonus(caster, t)
    set bonus = 0.25 + (0.15*lvl)

    call DestroyEffect( AddSpecialEffect("Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl", GetUnitX( caster ), GetUnitY( caster ) ) )
    call GroupEnumUnitsInRange( g, GetUnitX( caster ), GetUnitY( caster ), 900, null )
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if unitst( u, caster, "ally" ) and IsUnitType( u, UNIT_TYPE_HERO) and u != caster then
            call DestroyEffect( AddSpecialEffect("Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            call DestroyEffect( AddSpecialEffect("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl", GetUnitX( u ), GetUnitY( u ) ) )
            
            call SaveReal( udg_hash, GetHandleId( u ), StringHash( "pckrb" ), bonus )
            call bufst( caster, u, 'A067', 'B04O', "pckr", t )
            call effst( caster, u, null, lvl, t )
        endif
        call GroupRemoveUnit(g,u)
    endloop

    set num = CountUnitsInGroup(udg_otryad)-1
    set heal = GetUnitState( caster, UNIT_STATE_LIFE)/IMaxBJ(1,num)

    if num > 1 then
        set cyclA = 1
        loop
            exitwhen cyclA > 4
            if unitst( udg_hero[cyclA], caster, "ally" ) and udg_hero[cyclA] != caster then
                call healst(caster, udg_hero[cyclA], heal)
            endif
            set cyclA = cyclA + 1
        endloop
    endif

    set id = GetHandleId( caster )
    if LoadTimerHandle( udg_hash, id, StringHash( "pckwr" ) ) == null  then
    	call SaveTimerHandle( udg_hash, id, StringHash( "pckwr" ), CreateTimer() )
    endif
    set id = GetHandleId( LoadTimerHandle( udg_hash, id, StringHash( "pckwr" ) ) ) 
    call SaveUnitHandle( udg_hash, id, StringHash( "pckwr" ), caster )
    call TimerStart( LoadTimerHandle( udg_hash, GetHandleId( caster ), StringHash( "pckwr" ) ), 0.02, false, function PeacelockRKill )
    
    call GroupClear( g )
    call DestroyGroup( g )
    set g = null
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_PeacelockR takes nothing returns nothing
    set gg_trg_PeacelockR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_PeacelockR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_PeacelockR, Condition( function Trig_PeacelockR_Conditions ) )
    call TriggerAddAction( gg_trg_PeacelockR, function Trig_PeacelockR_Actions )
endfunction

