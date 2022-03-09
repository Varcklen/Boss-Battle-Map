globals
    unit Event_Hero_Kill_Unit
    real Event_Hero_Kill_Real
endglobals

function Trig_Kills_Conditions takes nothing returns boolean
    local integer index = GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1
    if IsUnitAlly(GetDyingUnit(), GetOwningPlayer(udg_hero[index])) then
        return false
    elseif combat( udg_hero[index], false, 0 ) == false then
        return false
    elseif GetUnitTypeId(GetKillingUnit()) != 'u000' and GetKillingUnit() != udg_hero[index] then
        return false
    elseif udg_fightmod[3] then
        return false
    elseif GetUnitName(GetDyingUnit()) == "dummy" then
        return false
    elseif GetKillingUnit() == null then
        return false
    elseif GetDyingUnit() == null then
        return false
    endif
    return true
endfunction

function Trig_Kills_Actions takes nothing returns nothing
    local unit hero = udg_hero[GetPlayerId(GetOwningPlayer(GetKillingUnit())) + 1]
    local integer i = GetUnitUserData(hero)
    local integer id = GetHandleId( hero )
    local integer s = LoadInteger( udg_hash, id, StringHash( "kill" ) ) + 1
    local integer b = LoadInteger( udg_hash, id, StringHash( "killb" ) ) + 1
    
    //Kills per game
    call SaveInteger( udg_hash, id, StringHash( "kill" ), s )
    //Kills per battle
    call SaveInteger( udg_hash, id, StringHash( "killb" ), b )
    //Is hero kill someone in battle?
    call SaveBoolean( udg_hash, id, StringHash( "kill" ), true )

    set Event_Hero_Kill_Unit = hero
    
    set Event_Hero_Kill_Real = 0.00
    set Event_Hero_Kill_Real = 1.00
    set Event_Hero_Kill_Real = 0.00

    set hero = null
endfunction

//===========================================================================
function InitTrig_Kills takes nothing returns nothing
    set gg_trg_Kills = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Kills, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition( gg_trg_Kills, Condition( function Trig_Kills_Conditions ) )
    call TriggerAddAction( gg_trg_Kills, function Trig_Kills_Actions )
endfunction

scope KillsBattleEndCount initializer Triggs
    private function FightStart takes nothing returns nothing
        call SaveInteger( udg_hash, GetHandleId( udg_FightStart_Unit ), StringHash( "killb" ), 0 )
    endfunction

    private function Triggs takes nothing returns nothing
        local trigger trig = CreateTrigger()
        
        call TriggerRegisterVariableEvent( trig, "udg_FightStart_Real", EQUAL, 1.00 )
        call TriggerAddAction( trig, function FightStart)
        
        set trig = null
    endfunction
endscope

