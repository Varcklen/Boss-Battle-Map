function Trig_Braccus_Rex_Change_Conditions takes nothing returns boolean
    return inv(udg_FightEnd_Unit, 'I071') > 0 or inv(udg_FightEnd_Unit, 'I072') > 0 or inv(udg_FightEnd_Unit, 'I06D') > 0 and not(udg_fightmod[3])
endfunction

function Trig_Braccus_Rex_Change_Actions takes nothing returns nothing
    local unit caster = udg_FightEnd_Unit
    local item it
    local integer i
    
    set i = 0
    loop
        exitwhen i > 5
        set it = UnitItemInSlot( caster, i)
        if GetItemTypeId(it) == 'I071' then
            call Inventory_ReplaceItemByNew(caster, it, 'I06D')
        elseif GetItemTypeId(it) == 'I06D' then
            call Inventory_ReplaceItemByNew(caster, it, 'I072')
        elseif GetItemTypeId(it) == 'I072' then
            call Inventory_ReplaceItemByNew(caster, it, 'I071')
        endif
        set i = i + 1
    endloop
    call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl", caster, "origin" ) )
    
    set it = null
    set caster = null
endfunction

//===========================================================================
function InitTrig_Braccus_Rex_Change takes nothing returns nothing
    set gg_trg_Braccus_Rex_Change = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Braccus_Rex_Change, "udg_FightEnd_Real", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_Braccus_Rex_Change, Condition( function Trig_Braccus_Rex_Change_Conditions ) )
    call TriggerAddAction( gg_trg_Braccus_Rex_Change, function Trig_Braccus_Rex_Change_Actions )
endfunction