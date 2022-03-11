globals
    constant integer MONEY_BAG_R_MONEY_MULTIPLIER = 7
endglobals

function Trig_Money_BagR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A17Y' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not( udg_fightmod[3] )
endfunction

function Trig_Money_BagR_Actions takes nothing returns nothing
    local integer lvl
    local unit caster
    local unit u
    local integer money
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        call textst( udg_string[0] + GetObjectName('A17Y'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
    endif
    
    set money = 12 + (lvl*12)
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", caster, "chest") )
    set u = LoadUnitHandle( udg_hash, GetHandleId( caster ), StringHash( "mbgqtt" ) )
    if GetUnitAbilityLevel(u, 'A17U') > 0 then
        call healst( caster, null, GetUnitState( u, UNIT_STATE_LIFE) )
        call manast( caster, null, GetUnitState( u, UNIT_STATE_MANA) )
        call KillUnit(u)
    	set money = money * MONEY_BAG_R_MONEY_MULTIPLIER
    endif
    call moneyst(caster, money)
    
    set u = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Money_BagR takes nothing returns nothing
    set gg_trg_Money_BagR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Money_BagR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Money_BagR, Condition( function Trig_Money_BagR_Conditions ) )
    call TriggerAddAction( gg_trg_Money_BagR, function Trig_Money_BagR_Actions )
endfunction

