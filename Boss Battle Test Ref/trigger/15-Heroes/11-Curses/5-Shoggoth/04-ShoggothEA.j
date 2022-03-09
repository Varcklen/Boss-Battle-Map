function Trig_ShoggothEA_Conditions takes nothing returns boolean
    return GetUnitAbilityLevel( udg_DamageEventSource, 'A198' ) > 0 and not( udg_IsDamageSpell ) and luckylogic( udg_DamageEventSource, 1 + GetUnitAbilityLevel( udg_DamageEventSource, 'A198'), 1, 100 ) and IsUnitEnemy(udg_DamageEventSource, GetOwningPlayer(udg_DamageEventTarget))
endfunction

function ShoggothTent takes unit caster returns nothing
    local integer cyclA
    local real r
    local integer k
    local real xc
    local real yc
    local real x = GetUnitX(caster)+GetRandomReal( -400, 400 )
    local real y = GetUnitY(caster)+GetRandomReal( -400, 400 )
    local integer p = udg_entropy[GetPlayerId( GetOwningPlayer( caster ) ) + 1]

    if p > 100 then
        set p = 100
    endif
    
    if luckylogic( caster, p, 1, 100 ) then
        set k = GetRandomInt(3, 6)
        set r = 360/k
        set cyclA = 1
        loop
            exitwhen cyclA > k
            set xc = x + 200 * Cos( r * cyclA * bj_DEGTORAD)
            set yc = y + 200 * Sin( r * cyclA * bj_DEGTORAD)
            set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'n03F', xc, yc, 270 )
            call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
            call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
            call QueueUnitAnimation( bj_lastCreatedUnit, "stand" )
            set cyclA = cyclA + 1
        endloop
    else
        set bj_lastCreatedUnit = CreateUnit( GetOwningPlayer(caster), 'n03F', x, y, 270 )
        call UnitApplyTimedLife( bj_lastCreatedUnit , 'BTLF', 15 )
        call SetUnitAnimation( bj_lastCreatedUnit, "birth" )
        call QueueUnitAnimation( bj_lastCreatedUnit, "stand" )
    endif
endfunction

function Trig_ShoggothEA_Actions takes nothing returns nothing
    call ShoggothTent( udg_DamageEventSource )
endfunction

//===========================================================================
function InitTrig_ShoggothEA takes nothing returns nothing
    set gg_trg_ShoggothEA = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_ShoggothEA, "udg_DamageModifierEvent", EQUAL, 1.00 )
    call TriggerAddCondition( gg_trg_ShoggothEA, Condition( function Trig_ShoggothEA_Conditions ) )
    call TriggerAddAction( gg_trg_ShoggothEA, function Trig_ShoggothEA_Actions )
endfunction

