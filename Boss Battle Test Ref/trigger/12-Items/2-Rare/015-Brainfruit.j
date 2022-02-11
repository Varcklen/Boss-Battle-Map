globals
    constant integer BRAINFRUIT_BONUS = 2
endglobals

function Trig_Brainfruit_Conditions takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == 'I04H'
endfunction

function Trig_Brainfruit_Actions takes nothing returns nothing 
    local unit caster = GetManipulatingUnit()
    local integer bonus = 0
    local integer i

    set i = 1
    loop
        exitwhen i > SETS_COUNT
        if SetCount_GetPieces(caster, i) > 0 then
            set bonus = bonus + BRAINFRUIT_BONUS
        endif
        set i = i + 1
    endloop
    
    call statst(caster, bonus, bonus, bonus, 0, true)
    call DestroyEffect( AddSpecialEffectTarget("Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl", caster, "origin" ) )
    call stazisst( caster, GetManipulatedItem() )
    
    set caster = null
endfunction

//===========================================================================
function InitTrig_Brainfruit takes nothing returns nothing
    set gg_trg_Brainfruit = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Brainfruit, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddCondition( gg_trg_Brainfruit, Condition( function Trig_Brainfruit_Conditions ) )
    call TriggerAddAction( gg_trg_Brainfruit, function Trig_Brainfruit_Actions )
endfunction

