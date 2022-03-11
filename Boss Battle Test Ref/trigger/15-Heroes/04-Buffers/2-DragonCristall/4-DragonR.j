function Trig_DragonR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A00M'
endfunction

function Trig_DragonR_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer lvl
    local unit caster
    local integer i
    local real t
    local real r
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A00M'), caster, 64, 90, 10, 1.5 )
        set t = 20
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set t = 20
    endif
    set t = timebonus(caster, t)

    set r = udg_cristal * 5 * lvl

    if r != 0 and GetUnitTypeId(caster) == udg_Database_Hero[1] then
        loop
            exitwhen cyclA > 4
            if GetUnitState(udg_hero[cyclA], UNIT_STATE_LIFE) > 0.405 and IsUnitAlly(udg_hero[cyclA], GetOwningPlayer(caster)) and IsUnitType( udg_hero[cyclA], UNIT_TYPE_HERO) then
                call shield( caster, udg_hero[cyclA], r, t )
                call effst( caster, udg_hero[cyclA], null, lvl, t )
            endif
            set cyclA = cyclA + 1
        endloop
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_DragonR takes nothing returns nothing
    set gg_trg_DragonR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DragonR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DragonR, Condition( function Trig_DragonR_Conditions ) )
    call TriggerAddAction( gg_trg_DragonR, function Trig_DragonR_Actions )
endfunction

