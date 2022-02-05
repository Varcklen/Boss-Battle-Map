function Trig_Rocks_Conditions takes nothing returns boolean
    local integer cyclA = 0
    local boolean l = false
    
    loop
        exitwhen cyclA > 3
        if GetSpellAbilityId() == 'AAO1' + cyclA then
            set l = true
        endif
        set cyclA = cyclA + 1
    endloop
    return l
endfunction

function Trig_Rocks_Actions takes nothing returns nothing
    local unit u
    local integer rand = GetRandomInt( 1, 3 )
    
    if GetSpellAbilityId() == 'AAO1' then
        call healst( GetSpellAbilityUnit(), null, 50 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetSpellAbilityUnit(), "origin") )
    elseif GetSpellAbilityId() == 'AAO2' then
        call manast( GetSpellAbilityUnit(), null, 25 )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", GetSpellAbilityUnit(), "origin") )
    elseif GetSpellAbilityId() == 'AAO3' then
        set u = randomtarget( GetSpellAbilityUnit(), 600, "enemy", "", "", "", "" )
        if u != null then
            call dummyspawn( GetSpellAbilityUnit(), 1, 0, 0, 0 )
            call spectime("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl", GetUnitX( u ), GetUnitY( u ), 1 )
            call UnitDamageTarget( bj_lastCreatedUnit, u, 75, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
        endif
    else
        if rand == 1 then
            call statst( GetSpellAbilityUnit(), 1, 0, 0, 0, true )
            call textst( "|c00FF2020 +1 strength", GetSpellAbilityUnit(), 64, 90, 10, 1 )
        elseif rand == 2 then
            call statst( GetSpellAbilityUnit(), 0, 1, 0, 0, true )
            call textst( "|c0020FF20 +1 agility", GetSpellAbilityUnit(), 64, 90, 10, 1 )
        elseif rand == 3 then
            call statst( GetSpellAbilityUnit(), 0, 0, 1, 0, true )
            call textst( "|c002020FF +1 intelligence", GetSpellAbilityUnit(), 64, 90, 10, 1 )
        endif
    endif
    
    set u = null
endfunction

//===========================================================================
function InitTrig_Rocks takes nothing returns nothing
    set gg_trg_Rocks = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Rocks, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Rocks, Condition( function Trig_Rocks_Conditions ) )
    call TriggerAddAction( gg_trg_Rocks, function Trig_Rocks_Actions )
endfunction

