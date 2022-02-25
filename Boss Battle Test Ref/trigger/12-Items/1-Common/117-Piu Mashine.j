function Trig_Piu_Mashine_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EP'
endfunction

function Trig_Piu_Mashine_Actions takes nothing returns nothing
    local integer cyclA = 1
    local integer cyclAEnd 
    local integer cyclB
    local integer cyclBEnd 
    local unit caster
    local unit target
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0EP'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif
    
    set cyclAEnd =  eyest( caster )
    call dummyspawn( caster, 1, 0, 0, 0 )
    loop
        exitwhen cyclA > cyclAEnd
        set cyclB = 1
        set cyclBEnd = SetCount_GetPieces(caster, SET_MECH)
        loop
            exitwhen cyclB > cyclBEnd
            set target = randomtarget( caster, 600, "enemy", "", "", "", "" )
            if target != null   then
                call UnitDamageTarget( bj_lastCreatedUnit, target, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS )
                call DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", GetUnitX(target), GetUnitY(target) ) )
            else
                set cyclB = cyclBEnd
            endif
            set cyclB = cyclB + 1
        endloop
        set cyclA = cyclA + 1
    endloop
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Piu_Mashine takes nothing returns nothing
    set gg_trg_Piu_Mashine = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Piu_Mashine, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Piu_Mashine, Condition( function Trig_Piu_Mashine_Conditions ) )
    call TriggerAddAction( gg_trg_Piu_Mashine, function Trig_Piu_Mashine_Actions )
endfunction

