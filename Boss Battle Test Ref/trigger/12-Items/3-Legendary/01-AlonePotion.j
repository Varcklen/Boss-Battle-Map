function Trig_AlonePotion_Conditions takes nothing returns boolean
    return GetSpellAbilityId() == 'A06W'
endfunction

function Trig_AlonePotion_Actions takes nothing returns nothing
    local integer cyclA = 0
    local integer cyclAEnd
    local integer i = 0
    local unit caster
    local real hp
    local real mp
    
    if CastLogic() then
        set caster = udg_Caster
    elseif RandomLogic() then
        set caster = udg_Caster
        call textst( udg_string[0] + GetObjectName('A06W'), caster, 64, 90, 10, 1.5 )
    else
        set caster = GetSpellAbilityUnit()
    endif

    set cyclAEnd = eyest( caster )
    loop
        exitwhen cyclA > 5
        if UnitHasItem(caster, UnitItemInSlot(caster, cyclA)) and GetItemType(UnitItemInSlot(caster, cyclA)) != ITEM_TYPE_POWERUP and GetItemType(UnitItemInSlot(caster, cyclA)) != ITEM_TYPE_PURCHASABLE then
            set i = i + 1
        endif
        set cyclA = cyclA + 1
    endloop
    if i <= 1 then
        call healst( caster, null, GetUnitState(caster, UNIT_STATE_MAX_LIFE) )
        call manast( caster, null, GetUnitState(caster, UNIT_STATE_MAX_MANA) )
        call DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", caster, "origin") )
    else
        set hp = GetUnitState( caster, UNIT_STATE_MAX_LIFE) * 0.05
        set mp = GetUnitState( caster, UNIT_STATE_MAX_MANA) * 0.05

        call spectimeunit( caster, "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl", "origin", 2 )
        set cyclA = 1
        loop
            exitwhen cyclA > cyclAEnd
            call healst( caster, null, hp )
            call manast( caster, null, mp )
            set cyclA = cyclA + 1
        endloop
    endif

    set caster = null
endfunction

//===========================================================================
function InitTrig_AlonePotion takes nothing returns nothing
    set gg_trg_AlonePotion = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_AlonePotion, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_AlonePotion, Condition( function Trig_AlonePotion_Conditions ) )
    call TriggerAddAction( gg_trg_AlonePotion, function Trig_AlonePotion_Actions )
endfunction

