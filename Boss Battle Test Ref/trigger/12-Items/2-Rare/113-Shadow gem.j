function Trig_Shadow_gem_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A11I'
endfunction

function Trig_Shadow_gem_Actions takes nothing returns nothing
    local integer x
    local integer cyclA = 1
    local unit caster
    local real sh
    local real t
    
    if CastLogic() then
        set caster = udg_Caster
        set t = udg_Time
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A11I'), caster, 64, 90, 10, 1.5 )
        set t = 60
    else
        set caster = GetSpellAbilityUnit()
        set t = 60
    endif
    set t = timebonus(caster, t)
    
    set x = eyest( caster )
    if IsUnitType( caster, UNIT_TYPE_HERO) or IsUnitType( caster, UNIT_TYPE_ANCIENT) then
        set sh = GetUnitState( caster, UNIT_STATE_LIFE) - ( GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.1 )
        call SetUnitState( caster, UNIT_STATE_LIFE, GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.1 )
        call shield( caster, caster, sh, t )
        if BuffLogic() then
            call effst( caster, caster, "Trig_Shadow_gem_Actions", 1, t )
        endif
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Shadow_gem takes nothing returns nothing
    set gg_trg_Shadow_gem = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Shadow_gem, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Shadow_gem, Condition( function Trig_Shadow_gem_Conditions ) )
    call TriggerAddAction( gg_trg_Shadow_gem, function Trig_Shadow_gem_Actions )
endfunction

