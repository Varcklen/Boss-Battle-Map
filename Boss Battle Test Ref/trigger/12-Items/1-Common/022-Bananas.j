//TESH.scrollpos=0
//TESH.alwaysfold=0
function Trig_Bananas_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A0K9' and combat( GetSpellAbilityUnit(), true, GetSpellAbilityId() )
endfunction

function Trig_Bananas_Actions takes nothing returns nothing
    local unit caster
    local unit target
    local integer cyclA = 1
    local integer cyclAEnd
    local integer cyclB
    local integer r = 0
    
    if CastLogic() then
        set caster = udg_Caster
        set target = udg_Target
    elseif RandomLogic() then
        set caster = udg_Caster
        set target = randomtarget( caster, 900, "ally", "hero", "", "", "" )
        call textst( udg_string[0] + GetObjectName('A0K9'), caster, 64, 90, 10, 1.5 )
        if target == null then
            set caster = null
            return
        endif
    else
        set caster = GetSpellAbilityUnit()
        set target = GetSpellTargetUnit()
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > cyclAEnd
        call healst( caster, target, 300 )
        call DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Demon\\DemonLargeDeathExplode\\DemonLargeDeathExplode.mdl", target, "origin" ) )
        set cyclA = cyclA + 1
    endloop
    if IsUnitType( target, UNIT_TYPE_HERO) and caster != target then
	set cyclB = 0
        set r = 0
        loop
            exitwhen cyclB > 5
            if UnitHasItem(udg_hero[GetPlayerId(GetOwningPlayer(target)) + 1], UnitItemInSlot( udg_hero[GetPlayerId(GetOwningPlayer(target)) + 1], cyclB ) ) then
                set r = r + 1
            endif
            set cyclB = cyclB + 1
        endloop
	if r < 6 then
		call RemoveItem( GetItemOfTypeFromUnitBJ( caster, 'I04K') )
		call UnitAddItem( target, CreateItem('I04K', GetUnitX(target), GetUnitY(target) ) )
	endif
    endif
    
    set caster = null
    set target = null
endfunction

//===========================================================================
function InitTrig_Bananas takes nothing returns nothing
    set gg_trg_Bananas = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Bananas, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Bananas, Condition( function Trig_Bananas_Conditions ) )
    call TriggerAddAction( gg_trg_Bananas, function Trig_Bananas_Actions )
endfunction

