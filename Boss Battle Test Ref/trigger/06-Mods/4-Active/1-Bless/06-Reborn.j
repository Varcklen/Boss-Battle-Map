globals
    constant integer MODE_REBORN_DAMAGE = 300
    constant integer MODE_REBORN_RADIUS = 400
endglobals

function Trig_Reborn_Conditions takes nothing returns boolean
    return IsUnitType( GetDyingUnit(), UNIT_TYPE_HERO) 
endfunction

function Trig_Reborn_Actions takes nothing returns nothing  
    call GroupAoE( GetDyingUnit(), null, GetUnitX( GetDyingUnit() ), GetUnitY( GetDyingUnit() ), MODE_REBORN_DAMAGE, MODE_REBORN_RADIUS, "enemy", "Units\\Undead\\Abomination\\AbominationExplosion.mdl", null )
endfunction

//===========================================================================
function InitTrig_Reborn takes nothing returns nothing
    set gg_trg_Reborn = CreateTrigger(  )
    call DisableTrigger( gg_trg_Reborn )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Reborn, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Reborn, Condition( function Trig_Reborn_Conditions ) )
    call TriggerAddAction( gg_trg_Reborn, function Trig_Reborn_Actions )
endfunction

