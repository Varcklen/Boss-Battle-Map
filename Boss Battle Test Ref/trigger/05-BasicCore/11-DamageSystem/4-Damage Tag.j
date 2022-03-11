function Trig_Damage_Tag_Actions takes nothing returns nothing
	local integer cyclA = 1
    local real r = udg_DamageEventAmount
    local real i = 8
       
    if udg_DamageEventType == udg_DamageTypeBlocked then
        call textst( "|cf0FF0510 dodge!", udg_DamageEventTarget, 75, 90, 10, 1.5 )
    elseif udg_DamageEventAmount >= 1 and ( GetPlayerController(GetOwningPlayer(udg_DamageEventTarget)) != MAP_CONTROL_USER or udg_DamageEventTarget == udg_unit[57] or udg_DamageEventTarget == udg_unit[58] )  then
        loop
            exitwhen cyclA > 1
            if r >= 200 and i < 16 then
                set r = r - 200
                set i = i + 1
                set cyclA = cyclA - 1
            endif
            set cyclA = cyclA + 1
        endloop
        if udg_DamageEventType == udg_DamageTypeCriticalStrike then
            if udg_IsDamageSpell then
                call textst( "|cf0FF1765" + I2S(R2I(udg_DamageEventAmount)) + "!", udg_DamageEventTarget, 64, GetRandomReal( 20, 150 ), i*1.25, 1 )
            else
                call textst( "|cf0FF0510" + I2S(R2I(udg_DamageEventAmount)) + "!", udg_DamageEventTarget, 64, GetRandomReal( 20, 150 ), i*1.25, 1 )
            endif
        elseif udg_IsDamageSpell then
            call textst( "|cf07510FF" + I2S(R2I(udg_DamageEventAmount)), udg_DamageEventTarget, 64, GetRandomReal( 20, 150 ), i, 1 )
        else
            call textst( "|cf0FFCC00" + I2S(R2I(udg_DamageEventAmount)), udg_DamageEventTarget, 64, GetRandomReal( 20, 150 ), i, 1 )
        endif
    endif
endfunction

//===========================================================================
function InitTrig_Damage_Tag takes nothing returns nothing
    set gg_trg_Damage_Tag = CreateTrigger(  )
    call TriggerRegisterVariableEvent( gg_trg_Damage_Tag, "udg_DamageEvent", EQUAL, 1.00 )
    call TriggerAddAction( gg_trg_Damage_Tag, function Trig_Damage_Tag_Actions )
endfunction

