globals
    constant integer FINANCIAL_VEIN_GOLD_BONUS = 3
endglobals

function Trig_Financial_vein_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0BM' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() ) and not(udg_fightmod[3])
endfunction

function Trig_Financial_vein_Actions takes nothing returns nothing
    local unit caster
    local integer gold

    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A0BM'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set gold = FINANCIAL_VEIN_GOLD_BONUS + LoadInteger( udg_hash, GetHandleId( caster ), StringHash( "vein" ) )
    
    call SaveInteger( udg_hash, GetHandleId( caster ), StringHash( "vein" ), gold )
    
    call moneyst(caster, gold)
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl" , caster, "origin" ) )
    if GetLocalPlayer() == GetOwningPlayer(caster) then
        call BlzSetAbilityExtendedTooltip( 'A0BM', words( caster, BlzGetAbilityExtendedTooltip('A0BM', 0), "|cffffffff", "|r", I2S(FINANCIAL_VEIN_GOLD_BONUS + gold) ), 0 )
    endif
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Financial_vein takes nothing returns nothing
    set gg_trg_Financial_vein = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Financial_vein, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Financial_vein, Condition( function Trig_Financial_vein_Conditions ) )
    call TriggerAddAction( gg_trg_Financial_vein, function Trig_Financial_vein_Actions )
endfunction

scope FinancialVein initializer Triggs
    private function ItemNullIf takes nothing returns boolean
        return GetUnitAbilityLevel(udg_FightEnd_Unit, 'A0BM') > 0
    endfunction

    private function ItemNull takes nothing returns nothing
        call SaveInteger( udg_hash, GetHandleId( udg_FightEnd_Unit ), StringHash( "vein" ), 0 )
        if GetLocalPlayer() == GetOwningPlayer(udg_FightEnd_Unit) then
            call BlzSetAbilityExtendedTooltip( 'A0BM', words( udg_FightEnd_Unit, BlzGetAbilityExtendedTooltip('A0BM', 0), "|cffffffff", "|r", "5" ), 0 )
        endif
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        call TriggerRegisterVariableEvent( trig, "udg_FightEnd_Real", EQUAL, 1.00 )
        call TriggerAddCondition( trig, Condition( function ItemNullIf ) )
        call TriggerAddAction( trig, function ItemNull)
        
        set trig = null
    endfunction
endscope