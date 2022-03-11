globals
    constant real BERRY_DEALER_R_BANANA_LIFE_TIME = 60
endglobals

function Trig_DealerR_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A189'
endfunction

function Trig_DealerR_Actions takes nothing returns nothing
    local unit caster
    local integer lvl
    local real x
    local real y
    local integer id
	local integer cyclA = 1
	local integer cyclAEnd
    
    if CastLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    elseif RandomLogic() then
        set caster = udg_Caster
        set lvl = udg_Level
        set x = GetUnitX( caster ) + GetRandomReal( -650, 650 )
        set y = GetUnitY( caster ) + GetRandomReal( -650, 650 )
        call textst( udg_string[0] + GetObjectName('A189'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
        set lvl = GetUnitAbilityLevel(GetSpellAbilityUnit(), GetSpellAbilityId())
        set x = GetLocationX( GetSpellTargetLoc() )
        set y = GetLocationY( GetSpellTargetLoc() )
    endif
    
	set cyclAEnd = lvl+1
	loop
		exitwhen cyclA > cyclAEnd
        call SpawnBanana( caster, Math_GetRandomX(x, 300), Math_GetRandomY(y, 300) )
		set cyclA = cyclA + 1
	endloop
	
    set caster = null
endfunction

//===========================================================================
function InitTrig_DealerR takes nothing returns nothing
    set gg_trg_DealerR = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_DealerR, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_DealerR, Condition( function Trig_DealerR_Conditions ) )
    call TriggerAddAction( gg_trg_DealerR, function Trig_DealerR_Actions )
endfunction

